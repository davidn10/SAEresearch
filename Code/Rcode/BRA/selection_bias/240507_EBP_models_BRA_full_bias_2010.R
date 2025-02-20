#install.packages("tidyverse")
#install.packages("parallel")
#install.packages("pbmcapply")
#install.packages("haven")
#install.packages("usethis")
#install.packages("devtools")
#install.packages("remotes")


library("usethis")
library("remotes")
library("devtools")
#devtools::install_github("SSA-Statistical-Team-Projects/povmap", ref="david3")


library(tidyverse)
library(parallel)
library(pbmcapply) # wrapper for mclapply that lets me see progress
library(povmap)
library(haven)
library("povmap")

#detach(package:povmap)
#devtools::install_github("SSA-Statistical-Team-Projects/povmap", ref="david3")

set.seed(7)

#setwd("C:/Davidnewhouse2024/BRA/BRA_2000/2000/full_census")
setwd("D:/david/SAE/SAE_research_with_Melany/BRA/2010/full_census_new")

#==============================================
# Unit-level models-biased
#==============================================


###Biased version 2
##Reading sample and census files
census<- read_dta("census/census_bias.dta")
census<-as.data.frame(census)

mysamples <- list.files("rawsamples_bias/bias11b11/selected") 
mybetas <- list.files("vars_selected_bias/bias11b11/betavars_selected_bias") 

#for(i in 1:length(mysamples)) {                              # Head of for-loop
for(i in 58:59) {                              # Head of for-loop
      ### Variables for EBP model
      assign(paste0("beta"),                                   # Read and store data frames
             read_dta(paste0("vars_selected_bias/bias11b11/betavars_selected_bias/",
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
             read_dta(paste0("rawsamples_bias/bias11b11/selected/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      
      ## EBP estimation
      ebp <- povmap:::ebp(fixed = ebpformula,
                          pop_data = census,
                          pop_domains = "mun_id",
                          pop_weights = "popwt",
                          smp_data = sample,
                          smp_domains = "mun_id",
                          #weights = "weights",
                          #weights_type = "nlme",
                          nlme_opt="optim",
                          #rescale_weights = T,
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          cpus = 10,
                          threshold = 5.3249649, #ln(105.86997)
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
      write_dta(simulation, paste0("results/bias/results_ebp/unit/output_bias11b11/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/bias/results_ebp/unit/model_bias11b11/coef_",mysamples[i]))
      write.excel(ebp, paste0("results/bias/results_ebp/unit/model_bias11b11/model_",mysamples[i],".xlsx"))
}

#==============================================
# Unit-level models-unbiased
#==============================================

##Reading sample and census files
census<- read_dta("census/census_bias.dta")
census<-as.data.frame(census)

mysamples <- list.files("rawsamples_bias/nobias/selected") 
mybetas <- list.files("vars_selected_bias/nobias/betavars_selected_nobias") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
  ### Variables for EBP model
  assign(paste0("beta"),                                   # Read and store data frames
         read_dta(paste0("vars_selected_bias/nobias/betavars_selected_nobias/",
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
         read_dta(paste0("rawsamples_bias/nobias/selected/",
                         mysamples[i])))
  sample<-as.data.frame(sample)
  
  ## EBP estimation
  ebp <- povmap:::ebp(fixed = ebpformula,
                      pop_data = census,
                      pop_domains = "mun_id",
                      pop_weights = "popwt",
                      smp_data = sample,
                      smp_domains = "mun_id",
                      #weights = "weights",
                      #weights_type = "nlme",
                      nlme_opt="optim",
                      #rescale_weights = T,
                      transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                      MSE = F,
                      cpus = 10,
                      threshold = 5.3249649, #ln(105.86997)
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
  write_dta(simulation, paste0("results/bias/results_ebp/unit/output_nobias/sim_ebp_",mysamples[i]))
  write_dta(coefficients, paste0("results/bias/results_ebp/unit/model_nobias/coef_",mysamples[i]))
  write.excel(ebp, paste0("results/bias/results_ebp/unit/model_nobias/model_",mysamples[i],".xlsx"))
}

#==============================================
# Unit-context models-biased
#==============================================


###BIas version 2
##Reading sample and census files
census<- read_dta("census/census_bias.dta")
census<-as.data.frame(census)

mysamples <- list.files("rawsamples_bias/bias11b11/selected") 
mybetas <- list.files("vars_selected_bias/context/bias11b11/betavars_selected_bias") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      ### Variables for EBP model
      assign(paste0("beta"),                                   # Read and store data frames
             read_dta(paste0("vars_selected_bias/context/bias11b11/betavars_selected_bias/",
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
             read_dta(paste0("rawsamples_bias/bias11b11/selected/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      
      ## EBP estimation
      ebp <- povmap:::ebp(fixed = ebpformula,
                          pop_data = census,
                          pop_domains = "mun_id",
                          pop_weights = "popwt",
                          smp_data = sample,
                          smp_domains = "mun_id",
                          #weights = "weights",
                          #weights_type = "nlme",
                          nlme_opt="optim",
                          #rescale_weights = T,
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          cpus = 10,
                          threshold = 5.3249649, #ln(105.86997)
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
      write_dta(simulation, paste0("results/bias/results_ebp/context/output_bias11b11/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/bias/results_ebp/context/model_bias11b11/coef_",mysamples[i]))
      write.excel(ebp, paste0("results/bias/results_ebp/context/model_bias11b11/model_",mysamples[i],".xlsx"))
}


#==============================================
# Unit-context models-Unbiased
#==============================================

##Reading sample and census files
census<- read_dta("census/census_bias.dta")
census<-as.data.frame(census)

mysamples <- list.files("rawsamples_bias/nobias/selected") 
mybetas <- list.files("vars_selected_bias/context/nobias/betavars_selected_nobias") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
  ### Variables for EBP model
  assign(paste0("beta"),                                   # Read and store data frames
         read_dta(paste0("vars_selected_bias/context/nobias/betavars_selected_nobias/",
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
         read_dta(paste0("rawsamples_bias/nobias/selected/",
                         mysamples[i])))
  sample<-as.data.frame(sample)
  
  ## EBP estimation
  ebp <- povmap:::ebp(fixed = ebpformula,
                      pop_data = census,
                      pop_domains = "mun_id",
                      pop_weights = "popwt",
                      smp_data = sample,
                      smp_domains = "mun_id",
                      #weights = "weights",
                      #weights_type = "nlme",
                      nlme_opt="optim",
                      #rescale_weights = T,
                      transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                      MSE = F,
                      cpus = 10,
                      threshold = 5.3249649, #ln(105.86997)
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
  write_dta(simulation, paste0("results/bias/results_ebp/context/output_nobias/sim_ebp_",mysamples[i]))
  write_dta(coefficients, paste0("results/bias/results_ebp/context/model_nobias/coef_",mysamples[i]))
  write.excel(ebp, paste0("results/bias/results_ebp/context/model_nobias/model_",mysamples[i],".xlsx"))
}


