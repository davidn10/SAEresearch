library(xgboost)
library(tidyverse)
library(parallel)
library(pbmcapply) # wrapper for mclapply that lets me see progress
library(povmap)
library(haven)
library("povmap")

#detach(package:povmap)
#devtools::install_github("SSA-Statistical-Team-Projects/povmap", ref="david")

set.seed(7)

#==============================================
# Unit-level models
#==============================================

##Reading sample and census files
census<- read_dta("D:/SAE_project/MEX/2010/states/census/census_states.dta")
census<-as.data.frame(census)
                      
mysamples <- list.files("D:/SAE_project/MEX/2010/states/samples") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("D:/SAE_project/MEX/2010/states/samples/",
                             mysamples[i])))
      sample<-as.data.frame(sample)

      ## Selected variables for the model
      drop <- c("psu_id", "hid", "ENT", "mun_id", "pchinc","povline", "fgt0", "fgt1", "fgt2","fgt0_m", "fgt1_m", "fgt2_m", "ln_pchinc",
                "state_1", "state_2", "state_3","state_4","state_5","state_6","state_7","state_8","state_9","state_10","state_11","state_12",
                "state_13","state_14","state_15","state_16","state_17","state_18","state_19","state_20","state_21","state_22","state_23","state_24",
                "state_25","state_26","state_27","state_28","state_29","state_30","state_31","state_32","FACTOR", "FACTOR_res", "FACTOR_res2")
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
                          rescale_weights = F,
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          cpus = 20,
                          threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=0   #default is 50
                          #B=100   #default is 50
                          )
      

      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
      colnames(simulation) <- c("area", "mean", "fgt")      
      write_dta(simulation, paste0("C:/Users/melyg/Desktop/SAE_Project/data/MEX/census_2010/states/results_ebp/unit/sim_ebp_", i, ".dta"))
}

#==================
##Rescaled weights
##Reading sample and census files
census<- read_dta("D:/SAE_project/MEX/2010/states/census/census_states.dta")
census<-as.data.frame(census)

mysamples <- list.files("D:/SAE_project/MEX/2010/states/samples") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("D:/SAE_project/MEX/2010/states/samples/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      
      ## Selected variables for the model
      drop <- c("psu_id", "hid", "ENT", "mun_id", "pchinc","povline", "fgt0", "fgt1", "fgt2","fgt0_m", "fgt1_m", "fgt2_m", "ln_pchinc",
                "state_1", "state_2", "state_3","state_4","state_5","state_6","state_7","state_8","state_9","state_10","state_11","state_12",
                "state_13","state_14","state_15","state_16","state_17","state_18","state_19","state_20","state_21","state_22","state_23","state_24",
                "state_25","state_26","state_27","state_28","state_29","state_30","state_31","state_32","FACTOR", "FACTOR_res", "FACTOR_res2")
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
                          cpus = 20,
                          threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=0   #default is 50
                          #B=100   #default is 50
      )
      
      
      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
      colnames(simulation) <- c("area", "mean", "fgt")      
      write_dta(simulation, paste0("C:/Users/melyg/Desktop/SAE_Project/data/MEX/census_2010/states/results_ebp/unit/sim_ebp_res_", i, ".dta"))
}


#==============================================
# Unit-context models
#==============================================

##Reading sample and census files
census<- read_dta("D:/SAE_project/MEX/2010/states/census/context/census_states.dta")
census<-as.data.frame(census)

mysamples <- list.files("D:/SAE_project/MEX/2010/states/context/samples") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("D:/SAE_project/MEX/2010/states/context/samples/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      
      ## Selected variables for the model
      drop <- c("psu_id", "hid", "ENT", "mun_id", "pchinc", "ln_pchinc","FACTOR", "FACTOR_res", "FACTOR_res2")
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
                          rescale_weights = F,
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          cpus = 20,
                          threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=0   #default is 50
                          #B=100   #default is 50
      )
      
      
      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
      colnames(simulation) <- c("area", "mean", "fgt")      
      write_dta(simulation, paste0("C:/Users/melyg/Desktop/SAE_Project/data/MEX/census_2010/states/results_ebp/context/sim_ebp_", i, ".dta"))
}

#==================
##Rescaled weights

##Reading sample and census files
census<- read_dta("D:/SAE_project/MEX/2010/states/census/context/census_states.dta")
census<-as.data.frame(census)

mysamples <- list.files("D:/SAE_project/MEX/2010/states/context/samplesres") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("D:/SAE_project/MEX/2010/states/context/samplesres/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      
      ## Selected variables for the model
      drop <- c("psu_id", "hid", "ENT", "mun_id", "pchinc", "ln_pchinc","FACTOR", "FACTOR_res", "FACTOR_res2")
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
                          cpus = 20,
                          threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=0   #default is 50
                          #B=0   #default is 50
      )
      
      
      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
      colnames(simulation) <- c("area", "mean", "fgt")      
      write_dta(simulation, paste0("C:/Users/melyg/Desktop/SAE_Project/data/MEX/census_2010/states/results_ebp/context/sim_ebp_res_", i, ".dta"))
}

