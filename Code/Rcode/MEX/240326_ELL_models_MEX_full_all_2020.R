library(xgboost)
library(tidyverse)
library(parallel)
library(pbmcapply) # wrapper for mclapply that lets me see progress
library(povmap)
library(haven)
library("povmap")

#detach(package:povmap)
#devtools::install_github("SSA-Statistical-Team-Projects/povmap", ref="david3")

set.seed(7)

setwd("C:/Users/wb462478/Desktop/SAE_project/MEX/2020/full_census")

#==============================================
# Unit-level models
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)
census$hhsize2 <- census$hhsize^2 

mysamples <- list.files("rawsamples_full/selected") 
mybetas <- list.files("betavars_selected") 
myalphas <- list.files("alphavars_selected") 

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
      
      ### Variables for Alpha model
      assign(paste0("alpha"),                                   # Read and store data frames
             read_dta(paste0("alphavars_selected/",
                             myalphas[i])))
      alpha<-as.data.frame(alpha)
      coef_anames<- colnames(alpha[,])
      alphaformula <- paste0(coef_anames[1])
      for (x in 2:length(coef_anames)){
            alphaformula <- paste0(alphaformula, " + ", coef_anames[x])
      }
      alphaformula  <- as.formula(paste0("~",alphaformula))
      
      ###Reading sample data
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("rawsamples_full/selected/",
                             mysamples[i])))
      sample<-as.data.frame(sample)

      ## EBP estimation
      ell <- povmap:::ell(fixed = ebpformula,
                          alpha = alphaformula,
                          pop_data = census,
                          pop_domains = "mun_id",
                          pop_weights = "popwt",
                          smp_data = sample,
                          smp_domains = "mun_id",
                          weights = "FACTOR",
                          rescale_weights = T,
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          #MSE = F,
                          errors="nonnormal",
                          threshold = 7.3851231, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=100,   #default is 50
                          model_parameters="fixed",
                          indicators=c("Head_Count")
                          )
      
      simulation <- as.data.frame(cbind(levels(ell$ind$Domain), ell$ind$Mean, ell$ind$Head_Count))
      coefficients <- as.data.frame(((ell$model_par$betas)))
      #residuals <- as.data.frame(((ell$model_par$residuals)))
      colnames(simulation) <- c("area",  "fgt") 
      names<-as.data.frame(rownames(coefficients))
      coefficients<-cbind(names,coefficients)
      colnames(coefficients) <- c("names","coefficients") 
      write_dta(simulation, paste0("results/results_ell/unit/output/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/results_ell/unit/model/coef_",mysamples[i]))
      write.excel(ell, paste0("results/results_ell/unit/model/model_",mysamples[i],".xlsx"))
}


#==============================================
# Unit-context models
#==============================================

# ##Reading sample and census files
# census<- read_dta("census/census_context.dta")
# census<-as.data.frame(census)
# 
# mysamples <- list.files("rawsamples_full/selected") 
# mybetas <- list.files("context/betavars_selected") 
# myalphas <- list.files("context/alphavars_selected") 
# 
# for(i in 1:length(mysamples)) {                              # Head of for-loop
#       ### Variables for EBP model
#       assign(paste0("beta"),                                   # Read and store data frames
#              read_dta(paste0("context/betavars_selected/",
#                              mybetas[i])))
#       beta<-as.data.frame(beta)
#       coef_names<- colnames(beta[,])
#       ebpformula <- paste0(coef_names[1])
#       for (x in 2:length(coef_names)){
#             ebpformula <- paste0(ebpformula, " + ", coef_names[x])
#       }
#       ebpformula <- paste0("ln_pchinc ~ ", ebpformula)
#       ebpformula <- as.formula(ebpformula)
#       
#       ### Variables for Alpha model
#       assign(paste0("alpha"),                                   # Read and store data frames
#              read_dta(paste0("context/alphavars_selected/",
#                              myalphas[i])))
#       alpha<-as.data.frame(alpha)
#       coef_anames<- colnames(alpha[,])
#       alphaformula <- paste0(coef_anames[1])
#       for (x in 2:length(coef_anames)){
#             alphaformula <- paste0(alphaformula, " + ", coef_anames[x])
#       }
#       alphaformula  <- as.formula(paste0("~",alphaformula))
#       
#       ###Reading sample data
#       assign(paste0("sample"),                                   # Read and store data frames
#              read_dta(paste0("rawsamples_full/selected/",
#                              mysamples[i])))
#       sample<-as.data.frame(sample)
#       
#       ## EBP estimation
#       ell <- povmap:::ell(fixed = ebpformula,
#                           alpha = alphaformula,
#                           pop_data = census,
#                           pop_domains = "mun_id",
#                           pop_weights = "popwt",
#                           smp_data = sample,
#                           smp_domains = "mun_id",
#                           weights = "FACTOR",
#                           rescale_weights = T,
#                           transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
#                           #MSE = F,
#                           errors="nonnormal",
#                           threshold = 7.3851231, #LOG 7.464 , nO LOG 1744.69
#                           na.rm=TRUE,
#                           L=100,   #default is 50
#                           model_parameters="fixed",
#                           indicators=c("Head_Count")
#       )
#       
#       simulation <- as.data.frame(cbind(levels(ell$ind$Domain), ell$ind$Mean, ell$ind$Head_Count))
#       coefficients <- as.data.frame(((ell$model_par$betas)))
#       #residuals <- as.data.frame(((ell$model_par$residuals)))
#       colnames(simulation) <- c("area",  "fgt") 
#       names<-as.data.frame(rownames(coefficients))
#       coefficients<-cbind(names,coefficients)
#       colnames(coefficients) <- c("names","coefficients") 
#       write_dta(simulation, paste0("results/results_ell/context/output/sim_ebp_",mysamples[i]))
#       write_dta(coefficients, paste0("results/results_ell/context/model/coef_",mysamples[i]))
#       #write.excel(levels(ell$model_par), paste0("results/results_ell/context/model/model_",mysamples[i],".xlsx"))
# }
# 
