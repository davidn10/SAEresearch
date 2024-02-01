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
                      
mysamples <- list.files("samples") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("samples/",
                             mysamples[i])))
      sample<-as.data.frame(sample)

      ## Selected variables for the model
      drop <- c("psu_id", "hid", "ENT", "mun_id", "pchinc","povline", "fgt0", "fgt1", "fgt2","fgt0_m", "fgt1_m", "fgt2_m", "ln_pchinc",
                "state_32","FACTOR", "FACTOR_res", "FACTOR_res2")
      coef_names<- colnames(sample[,!(names(sample) %in% drop)])
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
                          smp_data = sample,
                          smp_domains = "mun_id",
                          weights = "FACTOR",
                          weights_type = "nlme",
                          rescale_weights = T,
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          cpus = 10,
                          threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=0   #default is 50
                          #B=100   #default is 50
                          )
      
      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
      coefficients <- as.data.frame(((ebp$model$coefficients$fixed)))
      colnames(simulation) <- c("area", "mean", "fgt") 
      names<-as.data.frame(rownames(coefficients))
      coefficients<-cbind(names,coefficients)
      colnames(coefficients) <- c("names","coefficients") 
      write_dta(simulation, paste0("results/results_ebp/unit/output/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/results_ebp/unit/model/coef_",mysamples[i]))
      write.excel(ebp, paste0("results/results_ebp/unit/model/model_",mysamples[i],".xlsx"))
}


#==============================================
# Unit-context models
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)

mysamples <- list.files("context/samples") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("context/samples/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      
      ## Selected variables for the model
      drop <- c("psu_id", "hid", "ENT", "mun_id", "pchinc", "ln_pchinc","FACTOR", "FACTOR_res", "FACTOR_res2","state_32")
      coef_names<- colnames(sample[,!(names(sample) %in% drop)])
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
                          smp_data = sample,
                          smp_domains = "mun_id",
                          weights = "FACTOR",
                          weights_type = "nlme",
                          rescale_weights = T,
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          cpus = 10,
                          threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=0   #default is 50
                          #B=100   #default is 50
      )
      
      
      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
      coefficients <- as.data.frame(((ebp$model$coefficients$fixed)))
      colnames(simulation) <- c("area", "mean", "fgt") 
      names<-as.data.frame(rownames(coefficients))
      coefficients<-cbind(names,coefficients)
      colnames(coefficients) <- c("names","coefficients") 
      write_dta(simulation, paste0("results/results_ebp/context/output/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/results_ebp/context/model/coef_",mysamples[i]))
      write.excel(ebp, paste0("results/results_ebp/context/model/model_",mysamples[i],".xlsx"))
}