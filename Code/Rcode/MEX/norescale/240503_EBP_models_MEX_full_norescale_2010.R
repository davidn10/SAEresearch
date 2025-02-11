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

#setwd("C:/Users/wb462478/Desktop/SAE_project/MEX/2010/full_census_new")
setwd("D:/david/SAE/SAE_research_with_Melany/MEX/2010/full_census_new")

#==============================================
# Unit-level models
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)
census$hhsize2 <- census$hhsize^2 

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
      #sample$FACTOR <- sample$FACTOR/100 
      ###Reading sample data
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("rawsamples_full/selected/",
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
                          rescale_weights = F,
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          cpus = 10,
                          threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=100,   #default is 50
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
      write_dta(simulation, paste0("results/results_ebp_norescale/unit/output_h/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/results_ebp_norescale/unit/model_h/coef_",mysamples[i]))
      write.excel(ebp, paste0("results/results_ebp_norescale/unit/model_h/model_",mysamples[i],".xlsx"))
}


#==============================================
# Unit-context models
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)
census$hhsize2 <- census$hhsize^2 

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
      
      ###Reading sample data
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("rawsamples_full/selected/",
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
                          nlme_returnobject=T, 
                          rescale_weights = F,
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          cpus = 10,
                          threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=100,   #default is 50
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
      write_dta(simulation, paste0("results/results_ebp_norescale/context/output_h/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/results_ebp_norescale/context/model_h/coef_",mysamples[i]))
      write.excel(ebp, paste0("results/results_ebp_norescale/context/model_h/model_",mysamples[i],".xlsx"))
}