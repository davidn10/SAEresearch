#packageurl <- "http://cran.r-project.org/src/contrib/Archive/maptools/maptools_1.0-1.tar.gz"
#install.packages(packageurl, repos=NULL, type="source",dependencies = TRUE)

#packageurl <- "http://cran.r-project.org/src/contrib/Archive/SAEforest/SAEforest_1.0.0.tar.gz"
#install.packages(packageurl, repos=NULL, type="source",dependencies = TRUE)

library(SAEforest)
library(haven)

set.seed(7)

setwd("D:/SAE_project/MEX/2010/full_census")

#Reading data
census<- read_dta("subarea/census/census_subarea.dta")
census<-as.data.frame(census)

mysamples <- list.files("subarea/samples") 

#Model and results
for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("subarea/samples/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      
      x_covar<-sample[,-(1:6)]
      x_covar<-as.data.frame(data.matrix(x_covar))
      
      poor_direct <- sample$poor_direct
      
      mySAEforest <- SAEforest_model(Y = poor_direct, X = x_covar, dName = "mun_id", smp_data = sample, pop_data = census, 
                                meanOnly = T, threshold=0,  MSE="nonparametric", smearing=FALSE) 
      
      results <- as.data.frame(summarize_indicators(mySAEforest ,MSE=TRUE)) 
      write_dta(results, paste0("subarea/results_SAEf/SAEf_", mysamples[i]))
}


