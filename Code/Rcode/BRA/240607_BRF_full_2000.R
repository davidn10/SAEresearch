
###############################################
## BRF models
library(grf)
library(haven)
library(sp)
library(foreign)

set.seed(7)

setwd("D:/SAE_project/BRA/2000/full_census/")


census<- read_dta("census/census_subarea.dta")
census<-as.data.frame(census)

sample<- read_dta("subarea/samples/sample_1.dta")
sample<-as.data.frame(sample)

mysamples <- list.files("subarea/samples") 

#Model and results
for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("subarea/samples/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      sample<-sample[complete.cases(sample),]
      
      yvar <- as.vector(sample$poor_direct)
      x_covar<-sample[,-(1:6)]
      x_covar<-as.data.frame(data.matrix(x_covar))
      
      brf_results <- boosted_regression_forest(X=x_covar,Y = yvar, 
                                               sample.weights = sample$FACTOR, 
                                               cluster = as.factor(sample$mun_id), 
                                               tune.parameters = "all", honesty=T) 
      
      predictions <- predict(brf_results,census[,colnames(x_covar)]) 
      select<-subset(census, select = c(mun_id, psu_id))
      results<-as.data.frame(cbind(select, predictions))
      
      write_dta(results, paste0("results/results_BRF/BRF_", mysamples[i]))
}

 


