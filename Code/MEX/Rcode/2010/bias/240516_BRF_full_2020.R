
###############################################
## BRF models
library(grf)
library(haven)
library(sp)
library(foreign)

set.seed(7)

setwd("C:/Users/wb462478/Desktop/SAE_project/MEX/2020/full_census/")


census<- read_dta("census/census_subarea_bias.dta")
census<-as.data.frame(census)

#sample<- read_dta("subarea/bias55/sample_1.dta")
#sample<-as.data.frame(sample)

mysamples <- list.files("subarea/bias55") 

#Model and results
for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("subarea/bias55/",
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
      
      write_dta(results, paste0("results/bias/results_BRF/output_bias55/BRF_", mysamples[i]))
}

 
### LArge bias

mysamples <- list.files("subarea/bias11b11") 

#Model and results
for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("subarea/bias11b11/",
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
      
      write_dta(results, paste0("results/bias/results_BRF/output_bias11b11/BRF_", mysamples[i]))
}


### No bias

mysamples <- list.files("subarea/nobias") 

#Model and results
for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("subarea/nobias/",
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
      
      write_dta(results, paste0("results/bias/results_BRF/output_nobias/BRF_", mysamples[i]))
}
