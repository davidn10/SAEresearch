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
mysamples <- list.files("E:/SAE_project/MEX/2010/samples") 
mycensus  <- list.files("E:/SAE_project/MEX/2010/census") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("E:/SAE_project/MEX/2010/samples/",
                             mysamples[i])))
      assign(paste0("census"),                                   # Read and store data frames
             read_dta(paste0("E:/SAE_project/MEX/2010/census/",
                             mycensus[i])))
      sample<-as.data.frame(sample)
      census<-as.data.frame(census)
      
      ## Selected variables for the model
      drop <- c("psu_id", "hid", "mun_id", "pchinc","povline", "fgt0", "fgt1", "fgt2","fgt0_m", "fgt1_m", "fgt2_m", "ln_pchinc","FACTOR2")
      coef_names<- colnames(sample[,!(names(sample) %in% drop)])
      ebpformula <- paste0(coef_names[1])
      for (x in 1:length(coef_names)){
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
                          weights = "FACTOR2",
                          weights_type = "nlme",
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          cpus = 20,
                          threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=0   #default is 50
                          #B=100   #default is 50
                          )
      
      #simulation <- as.data.frame(estimators(ebp, indicator = c("Mean", "Head_Count")))

      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
      colnames(simulation) <- c("area", "mean", "fgt")      
      write_dta(simulation, paste0("C:/Users/melyg/Desktop/SAE_Project/data/MEX/census_2010/results_ebp/unit/sim_ebp_", i, ".dta"))
}

#==============================================
# Unit-context models
#==============================================


##Reading sample and census files
mysamples <- list.files("E:/SAE_project/MEX/2010/context/samples") 
mycensus  <- list.files("E:/SAE_project/MEX/2010/context/census") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("E:/SAE_project/MEX/2010/context/samples/",
                             mysamples[i])))
      assign(paste0("census"),                                   # Read and store data frames
             read_dta(paste0("E:/SAE_project/MEX/2010/context/census/",
                             mycensus[i])))
      sample<-as.data.frame(sample)
      census<-as.data.frame(census)
      
      ## Selected variables for the model
      drop <- c("hid", "mun_id", "pchinc","povline", "ln_pchinc","FACTOR2")
      coef_names<- colnames(sample[,!(names(sample) %in% drop)])
      ebpformula <- paste0(coef_names[1])
      for (x in 1:length(coef_names)){
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
                          weights = "FACTOR2",
                          weights_type = "nlme",
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          cpus = 20,
                          threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=0   #default is 50
                          #B=100   #default is 50
      )
      
      #simulation <- as.data.frame(estimators(ebp, indicator = c("Mean", "Head_Count")))
      
      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
      colnames(simulation) <- c("area", "mean", "fgt")      
      write_dta(simulation, paste0("C:/Users/melyg/Desktop/SAE_Project/data/MEX/census_2010/results_ebp/context/sim_ebp_", i, ".dta"))
}


