# Here we try including all census variables 
# This makes performance worse. 
###############################################
## BRF models
library(grf)
library(haven)
library(sp)
library(foreign)
library(doParallel)
 


set.seed(7)

setwd("D:/david/SAE/SAE_research_with_Melany/BRA/2010/full_census_new/")


census<- read_dta("census/census_subarea.dta")
census<-as.data.frame(census)

#sample<- read_dta("subarea/samples/sample_1.dta")
#sample<-as.data.frame(sample)
mysamples <- list.files("subarea_ebp",pattern=".dta") 

#mysamples <- list.files("subarea/samples") 

#Model and results
gc()
cl <- makeCluster(10)
registerDoParallel(cl)
mcoptions <- list(preschedule=TRUE) 
#all.tunable.params <- c("sample.fraction", "mtry", "min.node.size", 
#                        "honesty.fraction", "honesty.prune.leaves", "alpha", 
#                        "imbalance.penalty")

#for(i in 1:100) {                              # Head of for-loop
brflist <- foreach(i=1:100,.options.multicore=mcoptions,.packages=c("haven","grf")) %dopar% { # Head of for-loop 
       setwd("D:/david/SAE/SAE_research_with_Melany/BRA/2010/full_census_new/")
      #assign(paste0("sample"),                                   # Read and store data frames
      #       read_dta(paste0("subarea/samples/",
      #                       mysamples[i])))
  
  assign(paste0("sample"),                                   # Read and store data frames
         read_dta(paste0("subarea_ebp/",
                         mysamples[i])))
  
      sample<-as.data.frame(sample)
      sample<-sample[complete.cases(sample),]
      sample <- sample[,c("psu_id","poor_direct","FACTOR")]
      sample <- merge(x=sample,y=census,by="psu_id",all.x=T)
      
      yvar <- as.vector(sample$poor_direct)
      #x_covar<-sample[,-(1:6)]
      x_covar<-sample[,-(1:4)]
      #x_covar[,c("popwt")] <- NULL 
      x_covar<-as.data.frame(data.matrix(x_covar))
      
      wbar <- ave(sample$FACTOR,sample$mun_id)
      sample$FACTOR <- sample$FACTOR/wbar 
      
      brf_results <- boosted_regression_forest(X=x_covar,Y = yvar, 
                                             sample.weights = sample$FACTOR, 
                                               clusters = as.factor(sample$mun_id), 
                                               #tune.parameters = c("mtry", "min.node.size", "alpha", "imbalance.penalty"), 
                                              tune.parameters = "all",
                                               ci.group.size=1,
                                               honesty=F,num.trees=10000) 
      
      
      #predictions_smp <- unlist(predict(brf_results,sample[,colnames(x_covar)]))
      #sample$FACTOR_res3 <- as.numeric(sample$FACTOR_res2 / (predictions_smp * (1-predictions_smp)))
      
      #brf_results <- boosted_regression_forest(X=x_covar,Y = yvar, 
                                               #sample.weights = sample$FACTOR_res3, 
                                               #clusters = as.factor(sample$mun_id), 
                                               #tune.parameters = c("mtry", "min.node.size", "alpha", "imbalance.penalty"), 
                                               #tune.parameters = "all",
                                               #ci.group.size=1,
                                               #honesty=F,num.trees=10000) 
      
      predictions <- predict(brf_results,census[,colnames(x_covar)]) 
      select<-subset(census, select = c(mun_id, psu_id))
      results<-as.data.frame(cbind(select, predictions))
      
            
      write_dta(results, paste0("results/results_BRF_v2/BRF_", mysamples[i]))
      rm(brf_results)
      
  
}

parallel::stopCluster(cl = cl)



