
###############################################
## BRF models
library(grf)
library(haven)
library(sp)
library(foreign)
library(doParallel)
library(qeML) 


set.seed(7)

setwd("D:/david/SAE/SAE_research_with_Melany/BRA/2010/full_census_new/")


census<- read_dta("census/census_subarea.dta")
census<-as.data.frame(census)

#sample<- read_dta("subarea/samples/sample_1.dta")
#sample<-as.data.frame(sample)

mysamples <- list.files("subarea/samples") 

#Model and results
gc()
cl <- makeCluster(10)
registerDoParallel(cl)
mcoptions <- list(preschedule=TRUE) 
#all.tunable.params <- c("sample.fraction", "mtry", "min.node.size", 
#                        "honesty.fraction", "honesty.prune.leaves", "alpha", 
#                        "imbalance.penalty")

#for(i in 1:length(mysamples)) {                              # Head of for-loop
brflist <- foreach(i=1:100,.options.multicore=mcoptions,.packages=c("haven","qeML")) %dopar% { # Head of for-loop 

      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("subarea/samples/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      sample<-sample[complete.cases(sample),]
      
      yvar <- as.vector(sample$poor_direct)
      #x_covar<-sample[,-(1:6)]
      x_covar<-sample[,-(1:6)]
      x_covar<-as.data.frame(data.matrix(x_covar))
      data <- data.frame("poor_direct"=sample$poor_direct,x_covar) 
      
      qeml_results <- qeXGBoost(data,"poor_direct",nRounds=280)
      
      
      #brf_results <- boosted_regression_forest(X=x_covar,Y = yvar, 
      #                                       sample.weights = sample$FACTOR_res2, 
      #                                         clusters = as.factor(sample$mun_id), 
      #                                         tune.parameters = c("mtry", "min.node.size", "alpha", "imbalance.penalty"), 
      #                                       #tune.parameters = NULL,
      #                                         sample.fraction=1,ci.group.size=1,
      #                                         honesty=F,num.trees=2000,tune.num.trees=400,boost.error.reduction=1) 
      
      

      predictions <- predict(qeml_results,x=census[,colnames(x_covar)])                                         
      
      
      
      
      select<-subset(census, select = c(mun_id, psu_id))
      results<-as.data.frame(cbind(select, predictions))
      
      write_dta(results, paste0("results/results_qeml/qeml_", mysamples[i]))
      
      
  
}

parallel::stopCluster(cl = cl)



