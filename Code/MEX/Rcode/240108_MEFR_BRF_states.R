#packageurl <- "http://cran.r-project.org/src/contrib/Archive/maptools/maptools_1.0-1.tar.gz"
#install.packages(packageurl, repos=NULL, type="source",dependencies = TRUE)

#packageurl <- "http://cran.r-project.org/src/contrib/Archive/SAEforest/SAEforest_1.0.0.tar.gz"
#install.packages(packageurl, repos=NULL, type="source",dependencies = TRUE)

library(SAEforest)
library(haven)

set.seed(7)

#Reading data
census<- read_dta("D:/SAE_project/MEX/2010/states/census/subarea/census_subarea.dta")
census<-as.data.frame(census)

mysamples <- list.files("D:/SAE_project/MEX/2010/states/subarea/samples") 

#Model and results
for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("D:/SAE_project/MEX/2010/states/subarea/samples/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      
      x_covar<-sample[,-(1:6)]
      x_covar<-as.data.frame(data.matrix(x_covar))
      
      poor_direct <- sample$poor_direct
      
      mySAEforest <- SAEforest_model(Y = poor_direct, X = x_covar, dName = "mun_id", smp_data = sample, pop_data = census, 
                                meanOnly = T, threshold=0,  MSE="nonparametric", smearing=FALSE) # add MSE="nonparametric",
      
      results <- as.data.frame(summarize_indicators(mySAEforest ,MSE=TRUE)) # add this ,MSE=TRUE
      write_dta(results, paste0("C:/Users/melyg/Desktop/SAE_Project/data/MEX/census_2010/states/results_SAEf/SAEf_", mysamples[i]))
}


###############################################
## BRF models
library(grf)
library(haven)
library(sp)
library(foreign)

set.seed(7)

census<- read_dta("D:/SAE_project/MEX/2010/states/census/subarea/census_subarea.dta")
census<-as.data.frame(census)

mysamples <- list.files("D:/SAE_project/MEX/2010/states/subarea/samples") 

#Model and results
for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("D:/SAE_project/MEX/2010/states/subarea/samples/",
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
      
      write_dta(results, paste0("C:/Users/melyg/Desktop/SAE_Project/data/MEX/census_2010/states/results_BRF/BRF_", mysamples[i]))
}

 


