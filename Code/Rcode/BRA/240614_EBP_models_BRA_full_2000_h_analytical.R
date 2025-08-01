library(tidyverse)
library(parallel)
library(pbmcapply) # wrapper for mclapply that lets me see progress
library(povmap)
library(haven)
library("povmap")
library(foreach)
#detach(package:povmap)
#devtools::install_github("SSA-Statistical-Team-Projects/povmap", ref="david2")

set.seed(7)

#setwd("D:/SAE_project/BRA/2000/full_census")
setwd("D:/david/SAE/SAE_research_with_Melany/BRA/2000/full_census/BRA_2000_new")

#==============================================
# Unit-level models
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)

mysamples <- list.files("rawsamples/selected") 
mybetas <- list.files("betavars_selected") 

for (i in 1:length(mysamples)) {                              # Head of for-loop
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
      
      ###Reading sample data
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("rawsamples/selected/",
                             mysamples[i])))
      sample<-as.data.frame(sample)

      ## EBP estimation
      ebp <- povmap:::ebp(fixed = ebpformula,
                          pop_data = census,
                          pop_domains = "mun_id",
                          pop_weights = "popwt",
                          smp_data = sample,
                          smp_domains = "mun_id",
                          weights = "FACTOR",
                          weights_type = "hybrid",
                          nlme_opt="optim",
                          rescale_weights = T,
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          cpus = 10,
                          threshold = 4.6622116, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=0,   #default is 50
                          model_parameters="fixed",
                          indicators=c("Head_Count")
                          #Ydump=paste0("results/results_ebp/all/unit/model/ydump_",mysamples[i],".csv")
                          )
      
      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
      coefficients <- as.data.frame(((ebp$model$coefficients$fixed)))
      colnames(simulation) <- c("area",  "fgt") 
      names<-as.data.frame(rownames(coefficients))
      coefficients<-cbind(names,coefficients)
      colnames(coefficients) <- c("names","coefficients") 
      write_dta(simulation, paste0("results/results_ebp/unit_a/output/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/results_ebp/unit_a/model_h/coef_",mysamples[i]))
      write.excel(ebp, paste0("results/results_ebp/unit_a/model_h/model_",mysamples[i],".xlsx"))
      #saveRDS(object=ebp,file=paste0("results/results_ebp/unit_a/model_h/object_",mysamples[i]))
}


#==============================================
# Unit-context models
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)

mysamples <- list.files("rawsamples/selected") 
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
      
      ###Reading sample data
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("rawsamples/selected/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      
      ## EBP estimation
      ebp <- povmap:::ebp(fixed = ebpformula,
                          pop_data = census,
                          pop_domains = "mun_id",
                          pop_weights = "popwt",
                          smp_data = sample,
                          smp_domains = "mun_id",
                          weights = "FACTOR",
                          weights_type = "hybrid",
                          nlme_opt="optim",
                          rescale_weights = T,
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          cpus = 10,
                          threshold = 4.6622116, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=0,   #default is 50
                          model_parameters="fixed",
                          indicators=c("Head_Count")
                          #Ydump=paste0("results/results_ebp/all/unit/model/ydump_",mysamples[i],".csv")
      )
      
      
      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
      coefficients <- as.data.frame(((ebp$model$coefficients$fixed)))
      colnames(simulation) <- c("area", "fgt") 
      names<-as.data.frame(rownames(coefficients))
      coefficients<-cbind(names,coefficients)
      colnames(coefficients) <- c("names","coefficients") 
      write_dta(simulation, paste0("results/results_ebp/context_a/output_h/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/results_ebp/context_a/model_h/coef_",mysamples[i]))
      write.excel(ebp, paste0("results/results_ebp/context_a/model_h/model_",mysamples[i],".xlsx"))
      #saveRDS(object=ebp,file=paste0("results/results_ebp/context_a/model_h/object_",mysamples[i]))
}