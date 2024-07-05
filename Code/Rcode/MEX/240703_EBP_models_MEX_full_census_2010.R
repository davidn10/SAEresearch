library(xgboost)
library(tidyverse)
library(parallel)
library(pbmcapply) # wrapper for mclapply that lets me see progress
library(povmap)
library(haven)
library("povmap")

#detach(package:povmap)
#devtools::install_github("SSA-Statistical-Team-Projects/povmap", ref="david2")

set.seed(7)

setwd("D:/SAE_project/MEX/2010/full_census_new")

#==============================================
# Unit-level models
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)

mysamples <- list.files("rawsamples_full/selected") 
mybetas <- list.files("betavars_selected") 


for(i in 1:length(mysamples)) {                              # Head of for-loop
      ### Variables for EBP model
      assign(paste0("beta"),                                   # Read and store data frames
             read_dta(paste0("betavars_selected/",
                             mybetas[i])))
      beta<-as.data.frame(beta)
      coef_names<- colnames(beta[,])
      ebpformula <- paste0(coef_names[1])
      for (x in 2:length(coef_names)){
            ebpformula <- paste0(ebpformula, " + ", coef_names[x])
      }
      ebpformula <- paste0("ln_pchinc ~ ", ebpformula)
      ebpformula <- as.formula(ebpformula)
      
      ## EBP estimation
      ebp <- povmap:::ebp(fixed = ebpformula,
                          pop_data = census,
                          pop_domains = "mun_id",
                          pop_weights = "popwt",
                          smp_data = census,
                          smp_domains = "mun_id",
                          weights = "popwt",
                          weights_type = "hybrid",
                          nlme_opt="optim",
                          rescale_weights = T,
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          cpus = 10,
                          threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=0,   #default is 50
                          model_parameters="fixed",
                          indicators=c("Head_Count")
                          )
      
      X_smp <- model.matrix(ebp$fixed, ebp$framework$smp_data)   
      n_smp<-as.vector(table(ebp$framework$smp_domains_vec))
      dist_obs_dom<-unique(ebp$framework$pop_domains_vec) %in% unique(ebp$framework$smp_domains_vec)
      Yhat<-X_smp%*%ebp$model_par$betas + rep(ebp$model_par$rand_eff[dist_obs_dom],n_smp)
      Ybarhat<-mean(Yhat)
      Yhat<-as.data.frame(Yhat)
      Ybarhat<-as.data.frame(Ybarhat)
      write.csv(Ybarhat, paste0("results/results_ebp/context/census_h/ybarhat_",mysamples[i],".csv"))
      write_dta(Yhat, paste0("results/results_ebp/context/census_h/yhat_",mysamples[i]))
      write.excel(ebp, paste0("results/results_ebp/context/census_h/model_",mysamples[i],".xlsx"))
      
      }


#==============================================
# Unit-context models
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)

mysamples <- list.files("rawsamples_full/selected") 
mybetas <- list.files("context/betavars_selected") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      ### Variables for EBP model
      assign(paste0("beta"),                                   # Read and store data frames
             read_dta(paste0("context/betavars_selected/",
                             mybetas[i])))
      beta<-as.data.frame(beta)
      coef_names<- colnames(beta[,])
      ebpformula <- paste0(coef_names[1])
      for (x in 2:length(coef_names)){
            ebpformula <- paste0(ebpformula, " + ", coef_names[x])
      }
      ebpformula <- paste0("ln_pchinc ~ ", ebpformula)
      ebpformula <- as.formula(ebpformula)
      

      ## EBP estimation
      ebp <- povmap:::ebp(fixed = ebpformula,
                          pop_data = census,
                          pop_domains = "mun_id",
                          pop_weights = "popwt",
                          smp_data = census,
                          smp_domains = "mun_id",
                          weights = "popwt",
                          weights_type = "hybrid",
                          nlme_opt="optim",
                          rescale_weights = T,
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          cpus = 10,
                          threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=0,   #default is 50
                          model_parameters="fixed",
                          indicators=c("Head_Count")
                          #Ydump=paste0("results/results_ebp/all/unit/model/ydump_",mysamples[i],".csv")
      )
      
      X_smp <- model.matrix(ebp$fixed, ebp$framework$smp_data)   
      n_smp<-as.vector(table(ebp$framework$smp_domains_vec))
      dist_obs_dom<-unique(ebp$framework$pop_domains_vec) %in% unique(ebp$framework$smp_domains_vec)
      Yhat<-X_smp%*%ebp$model_par$betas + rep(ebp$model_par$rand_eff[dist_obs_dom],n_smp)
      Ybarhat<-mean(Yhat)
      Yhat<-as.data.frame(Yhat)
      Ybarhat<-as.data.frame(Ybarhat)
      write.csv(Ybarhat, paste0("results/results_ebp/context/census_h/ybarhat_",mysamples[i],".csv"))
      write_dta(Yhat, paste0("results/results_ebp/context/census_h/yhat_",mysamples[i]))
      write.excel(ebp, paste0("results/results_ebp/context/census_h/model_",mysamples[i],".xlsx"))
}