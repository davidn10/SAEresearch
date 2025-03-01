
###############################################
## BRF models
library(grf)
library(haven)
library(sp)
library(foreign)
library(sufrep)

set.seed(7)

#setwd("D:/SAE_project/MEX/2010/full_census_new/")
setwd("D:/david/SAE/SAE_research_with_Melany/MEX/2010/full_census_new")

census<- read_dta("census/census_subarea.dta")
census<-as.data.frame(census)
census<-census[complete.cases(census),]
#drop_cols <- grep("^state_", names(census), value = TRUE)  
#census <- census[, !names(sample) %in% drop_cols] 

#means_encoder <- make_encoder(X = census, G = as.factor(census$state), method = "means")
#census <- means_encoder(X=census,G=as.factor(census$mun_id))


#census <- cbind(census,x_covar_mun_id)

#sample<- read_dta("subarea/samples/sample_1.dta")
#sample<-as.data.frame(sample)

mysamples <- list.files("subarea/samples") 

#Model and results
for(i in 1:length(mysamples)) {                              # Head of for-loop
#for(i in 1:1) {                              # Head of for-loop
      #assign(paste0("sample"),                                   # Read and store data frames
      #       read_dta(paste0("subarea/samples/",
      #                       mysamples[i])))
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
                                              tune.parameters = "all", honesty=F 
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
      
      write_dta(results, paste0("results/results_BRF/BRF_", mysamples[i]))
}

 


