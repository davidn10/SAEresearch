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
census<- read_dta("D:/SAE_project/BRA/2010/census/census.dta")
census<-as.data.frame(census)

mysamples <- list.files("D:/SAE_project/BRA/2010/samples") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("D:/SAE_project/BRA/2010/samples/",
                             mysamples[i])))
      sample<-as.data.frame(sample)

      ## Selected variables for the model
      drop <- c("hid", "mun_id", "pchinc","fgt0", "fgt1", "fgt2","fgt0_m", "fgt1_m", "fgt2_m", "ln_pchinc","FACTOR_res", "FACTOR","FACTOR_res2")
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
                          rescale_weights = FALSE,
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          cpus = 20,
                          threshold = 5.098808322, #LOG 5.098808322 , nO LOG 163.8265625
                          na.rm=TRUE,
                          L=0   #default is 50
                          #B=100   #default is 50
                          )
      
      #simulation <- as.data.frame(estimators(ebp, indicator = c("Mean", "Head_Count")))

      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
      colnames(simulation) <- c("area", "mean", "fgt")      
      write_dta(simulation, paste0("C:/Users/melyg/Desktop/SAE_Project/data/BRA/results_ebp/unit/sim_ebp_", i, ".dta"))
}

#####################
## Rescaling weights
##Reading sample and census files

census<- read_dta("D:/SAE_project/BRA/2010/census/census.dta")
census<-as.data.frame(census)

mysamples <- list.files("D:/SAE_project/BRA/2010/samples") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("D:/SAE_project/BRA/2010/samples/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      
      ## Selected variables for the model
      drop <- c("hid", "mun_id", "pchinc","fgt0", "fgt1", "fgt2","fgt0_m", "fgt1_m", "fgt2_m", "ln_pchinc","FACTOR_res", "FACTOR","FACTOR_res2")
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
                          threshold = 5.098808322, #LOG 5.098808322 , nO LOG 163.8265625
                          na.rm=TRUE,
                          L=0   #default is 50
                          #B=100   #default is 50
      )
      
      #simulation <- as.data.frame(estimators(ebp, indicator = c("Mean", "Head_Count")))
      
      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
      colnames(simulation) <- c("area", "mean", "fgt")      
      write_dta(simulation, paste0("C:/Users/melyg/Desktop/SAE_Project/data/BRA/results_ebp/unit/sim_ebp_res_", i, ".dta"))
}

#==============================================
# Unit-context models
#==============================================


##Reading sample and census files
census<- read_dta("D:/SAE_project/BRA/2010/context/census/census.dta")
census<-as.data.frame(census)

mysamples <- list.files("D:/SAE_project/BRA/2010/context/samples") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("D:/SAE_project/BRA/2010/context/samples/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      
      ## Selected variables for the model
      drop <- c("hid", "mun_id", "pchinc","fgt0", "fgt1", "fgt2","fgt0_m", "fgt1_m", "fgt2_m", "ln_pchinc","FACTOR_res", "FACTOR","FACTOR_res2")
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
                          rescale_weights = FALSE,
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          cpus = 20,
                          threshold = 5.098808322, #LOG 5.098808322 , nO LOG 163.8265625
                          na.rm=TRUE,
                          L=0   #default is 50
                          #B=100   #default is 50
      )
      
      #simulation <- as.data.frame(estimators(ebp, indicator = c("Mean", "Head_Count")))
      
      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
      colnames(simulation) <- c("area", "mean", "fgt")      
      write_dta(simulation, paste0("C:/Users/melyg/Desktop/SAE_Project/data/BRA/results_ebp/context/sim_ebp_", i, ".dta"))
}

############################
## Rescaling weights
##Reading sample and census files
census<- read_dta("D:/SAE_project/BRA/2010/context/census/census.dta")
census<-as.data.frame(census)

mysamples <- list.files("D:/SAE_project/BRA/2010/context/samples") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("D:/SAE_project/BRA/2010/context/samples/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      
      ## Selected variables for the model
      drop <- c("hid", "mun_id", "pchinc","fgt0", "fgt1", "fgt2","fgt0_m", "fgt1_m", "fgt2_m", "ln_pchinc","FACTOR_res", "FACTOR","FACTOR_res2")
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
                          threshold = 5.098808322, #LOG 5.098808322 , nO LOG 163.8265625
                          na.rm=TRUE,
                          L=0   #default is 50
                          #B=100   #default is 50
      )
      
      #simulation <- as.data.frame(estimators(ebp, indicator = c("Mean", "Head_Count")))
      
      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
      colnames(simulation) <- c("area", "mean", "fgt")      
      write_dta(simulation, paste0("C:/Users/melyg/Desktop/SAE_Project/data/BRA/results_ebp/context/sim_ebp_res_", i, ".dta"))
}
