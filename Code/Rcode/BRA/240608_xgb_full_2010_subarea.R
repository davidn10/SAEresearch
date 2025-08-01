
###############################################
## XGB models
library(haven)
library(sp)
library(foreign)
library(doParallel)
library(povmap) 


set.seed(7)

setwd("D:/david/SAE/SAE_research_with_Melany/BRA/2010/full_census_new/")

##Reading sample and census files

mysamples <- list.files("subarea/samples",pattern=".dta") 
mybetas <- list.files("betavars_selected") 
mcoptions <- list(preschedule=TRUE) 
getDoParWorkers()

census<- read_dta("census/census_subarea.dta")
census<-as.data.frame(census)

#sample<- read_dta("subarea/samples/sample_1.dta")
#sample<-as.data.frame(sample)

#Model and results
gc()
cl <- makeCluster(10)
registerDoParallel(cl)
mcoptions <- list(preschedule=TRUE) 
#all.tunable.params <- c("sample.fraction", "mtry", "min.node.size", 
#                        "honesty.fraction", "honesty.prune.leaves", "alpha", 
#                        "imbalance.penalty")

#for(i in 1:length(mysamples)) {                              # Head of for-loop
ebplist <- foreach(i=1:100,.options.multicore=mcoptions,.packages=c("haven","povmap","magrittr")) %dopar% { # Head of for-loop 
  setwd("D:/david/SAE/SAE_research_with_Melany/BRA/2010/full_census_new/")

  ###Reading sample data
  assign(paste0("sample"),                                   # Read and store data frames
         read_dta(paste0("subarea/samples/",
                         mysamples[i])))
  sample<-as.data.frame(sample)
  drop <- c("psu_id", "mun_id", "poor_direct","FACTOR","FACTOR_res","FACTOR_res2")
  coef_names<- colnames(sample[,!(names(sample) %in% drop)])
  ebpformula <- paste0(coef_names[1])
  for (x in 2:length(coef_names)){
    ebpformula <- paste0(ebpformula, " + ", coef_names[x])
  }
  ebpformula <- paste0("poor_direct ~ ", ebpformula)
  ebpformula <- as.formula(ebpformula)
      
  xgb_tune_model <- povmap:::xgb_tune(fixed = ebpformula,
                                smp_data=sample,
                                smp_weights="FACTOR_res2",
                                domains="mun_id",
                                transformation = "no",
                                folds=10 
      ) 
  
      xgb <- povmap:::xgb(fixed = ebpformula,
                          pop_data = census,
                          pop_weights = "popwt",
                          smp_data = sample,
                          domains = "mun_id",
                          sub_domains = "psu_id", 
                          smp_weights = "FACTOR_res2",
                          transformation = "no", #"no", "log", "arcsin" 
                          na.rm=TRUE,
                          nround = xgb_tune_model$nround,
                          max_depth = xgb_tune_model$max_depth,
                          colsample_bytree = xgb_tune_model$colsample_bytree,
                          colsample_bylevel = xgb_tune_model$colsample_bytree,
                          colsample_bynode = xgb_tune_model$colsample_bynode,
                          subsample = xgb_tune_model$subsample,
                          min_child_weight = xgb_tune_model$min_child_weight,
                          eta = xgb_tune_model$min_child_weight,
                          gamma = xgb_tune_model$gamma,
                          max_delta_step = xgb_tune_model$max_delta_step,
                          lambda = xgb_tune_model$lambda,
                          alpha = xgb_tune_model$alpha
      )
      
      
      
    
      
      
      write_dta(xgb$ind, paste0("results/results_xgb/xgb_", mysamples[i]))
      
      
  
}

parallel::stopCluster(cl = cl)



