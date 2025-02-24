
###############################################
## BRF models
library(povmap)
library(haven)
library(sp)
library(foreign)




set.seed(7)

#setwd("D:/SAE_project/MEX/2010/full_census_new/")
setwd("H:/david/SAE/SAE_research_with_Melany/MEX/2010/full_census_new")

census<- read_dta("census/census_subarea.dta")
census<-as.data.frame(census)


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
      sample<-sample[complete.cases(sample),]
      
      yvar <- as.vector(sample$poor_direct)
      x_covar<-sample[,-(1:6)]
      x_covar<-as.data.frame(data.matrix(x_covar))
      
      coef_names<- colnames(x_covar[,])
      formula <- paste0(coef_names[1])
      for (x in 2:length(coef_names)){
        formula <- paste0(formula, " + ", coef_names[x])
      }
      formula <- paste0("poor_direct ~ ", formula)
      formula <- as.formula(formula)
      
      xgb_tune <- povmap:::xgb_tune(fixed=formula, smp_data=sample, domains="mun_id", cluster="mun_id",data=sample) 
      
      ebp <- povmap:::ebp(fixed = ebpformula,
                          pop_data = census,
                          pop_domains = "mun_id",
                          pop_weights = "popwt",
                          smp_data = sample,
                          smp_domains = "mun_id",
                          weights = "FACTOR",
          
      #brf_results <- ll_regression_forest(X=x_covar,Y=yvar,
      #                                 cluster = as.factor(sample$mun_id),
      #                                 equalize.cluster.weights = T, 
      #                                 tune.parameters = "all",
      #                                 honesty=F
      #                                   )
      #subset_census <- census[,colnames(x_covar)]   
      #subset_census <- complete.cases(census)
      #predictions <- predict(brf_results,as.data.frame(subset_census)) 
      
      predictions <- predict(brf_results,census[,colnames(x_covar)]) 
      select<-subset(census, select = c(mun_id, psu_id))
      results<-as.data.frame(cbind(select, predictions))
      
      write_dta(results, paste0("results/results_XGB/XGB_", mysamples[i]))
}

 


