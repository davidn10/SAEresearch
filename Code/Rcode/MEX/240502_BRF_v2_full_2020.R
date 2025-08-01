
###############################################
## BRF models
library(grf)
library(haven)
library(sp)
library(foreign)
library(doParallel)

set.seed(7)

#setwd("D:/SAE_project/MEX/2010/full_census_new/")
setwd("H:/david/SAE/SAE_research_with_Melany/MEX/2020/full_census")

census<- read_dta("census/census_subarea.dta")
census<-as.data.frame(census)
census<-census[complete.cases(census),]

gc()
cl <- makeCluster(10)
registerDoParallel(cl)
mcoptions <- list(preschedule=TRUE)


mysamples <- list.files("subarea/samples") 

#Model and results
#for(i in 1:length(mysamples)) {                              # Head of for-loop
brflist <- foreach(i=1:100,.options.multicore=mcoptions,.packages=c("haven","grf")) %dopar% { # Head of for-loop 
    
      assign(paste0("sample"),                                   # Read and store data frames
                read_dta(paste0("subarea/samples/",
                                mysamples[i])))
      
      
      sample<-as.data.frame(sample)
      #drop_cols <- grep("^state_", names(sample), value = TRUE)  
      #sample <- sample[, !names(sample) %in% drop_cols] 
      
      sample<-sample[complete.cases(sample),]
      
      yvar <- as.vector(sample$poor_direct)
      x_covar<-sample[,-(1:6)]

      #x_covar_mun_id <- model.matrix(~ mun_id,sample)
      #onehot_encoder <- make_encoder(X = x_covar, G = as.factor(sample$mun_id), method = "one_hot")
      #means_encoder <- make_encoder(X = x_covar, G = as.factor(sample$mun_id), method = "means")
      #x_covar <- means_encoder(X=x_covar,G=as.factor(sample$mun_id))
      
     
      brf_results <- boosted_regression_forest(X=x_covar,Y = yvar, 
                                               sample.weights = sample$FACTOR_res2, 
                                               cluster = as.factor(sample$mun_id), 
                                              tune.parameters = "all", honesty=F,
                                              num.trees=10000
                                              ) 
 
          
      #brf_results <- ll_regression_forest(X=x_covar,Y=yvar,
      #                                 cluster = as.factor(sample$mun_id),
      #                                 equalize.cluster.weights = T, 
      #                                 tune.parameters = "all",
      #                                 honesty=F
      #                                   )
      
      
      predictions <- predict(brf_results,census[,colnames(x_covar)]) 
      #predictions <- subset(predictions,select=-ll.lambda)
      
      select<-subset(census, select = c(mun_id, psu_id))
      results<-as.data.frame(cbind(select, predictions))
      
      write_dta(results, paste0("results/results_BRF_v2/BRF_", mysamples[i]))
}
parallel::stopCluster(cl = cl)
 


