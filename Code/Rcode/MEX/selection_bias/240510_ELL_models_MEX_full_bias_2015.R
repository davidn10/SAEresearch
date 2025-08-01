library(xgboost)
library(tidyverse)
library(parallel)
library(pbmcapply) # wrapper for mclapply that lets me see progress
library(povmap)
library(haven)
library("povmap")
library(doParallel)
# adjust number of clusters depending on available memory and file size 
cl <- makeCluster(5)
registerDoParallel(cl)

#detach(package:povmap)
#devtools::install_github("SSA-Statistical-Team-Projects/povmap", ref="david3")

set.seed(7)

setwd("C:/Users/wb462478/Desktop/SAE_project/MEX/2015/full_census_new")

#==============================================
# Unit-level models
#==============================================

##Reading sample and census files
census<- read_dta("census/census_bias.dta")
census<-as.data.frame(census)

mysamples <- list.files("rawsamples_bias/bias55/selected") 
mybetas <- list.files("vars_selected_bias/bias55/betavars_selected_bias") 
myalphas <- list.files("vars_selected_bias/bias55/alphavars_selected_bias") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      ### Variables for EBP model
      assign(paste0("beta"),                                   # Read and store data frames
             read_dta(paste0("vars_selected_bias/bias55/betavars_selected_bias/",
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
             read_dta(paste0("vars_selected_bias/bias55/alphavars_selected_bias/",
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
             read_dta(paste0("rawsamples_bias/bias55/selected/",
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
                          threshold =7.1200103, #LOG 7.464 , nO LOG 1744.69
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
      write_dta(simulation, paste0("results/bias/results_ell/unit/output_bias55/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/bias/results_ell/unit/model_bias55/coef_",mysamples[i]))
      #write.excel(levels(ell$model_par), paste0("results/results_ell/unit/model/model_",mysamples[i],".xlsx"))
}


#Biased version 2

##Reading sample and census files
census<- read_dta("census/census_bias.dta")
census<-as.data.frame(census)

mysamples <- list.files("rawsamples_bias/bias11b11/selected") 
mybetas <- list.files("vars_selected_bias/bias11b11/betavars_selected_bias") 
myalphas <- list.files("vars_selected_bias/bias11b11/alphavars_selected_bias") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
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
  
  ### Variables for Alpha model
  assign(paste0("alpha"),                                   # Read and store data frames
         read_dta(paste0("vars_selected_bias/bias11b11/alphavars_selected_bias/",
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
         read_dta(paste0("rawsamples_bias/bias11b11/selected/",
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
                      threshold = 7.1200103, #LOG 7.464 , nO LOG 1744.69
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
  write_dta(simulation, paste0("results/bias/results_ell/unit/output_bias11b11/sim_ebp_",mysamples[i]))
  write_dta(coefficients, paste0("results/bias/results_ell/unit/model_bias11b11/coef_",mysamples[i]))
  #write.excel(levels(ell$model_par), paste0("results/results_ell/unit/model/model_",mysamples[i],".xlsx"))
}

#==============================================
# Unit-level models-unbiased
#==============================================

##Reading sample and census files
census<- read_dta("census/census_bias.dta")
census<-as.data.frame(census)

mysamples <- list.files("rawsamples_bias/nobias/selected") 
mybetas <- list.files("vars_selected_bias/nobias/betavars_selected_nobias") 
myalphas <- list.files("vars_selected_bias/nobias/alphavars_selected_nobias") 

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
      
      ### Variables for Alpha model
      assign(paste0("alpha"),                                   # Read and store data frames
             read_dta(paste0("vars_selected_bias/nobias/alphavars_selected_nobias/",
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
             read_dta(paste0("rawsamples_bias/nobias/selected/",
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
                          threshold = 7.1200103, #LOG 7.464 , nO LOG 1744.69
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
      write_dta(simulation, paste0("results/bias/results_ell/unit/output_nobias/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/bias/results_ell/unit/model_nobias/coef_",mysamples[i]))
      #write.excel(levels(ell$model_par), paste0("results/results_ell/unit/model/model_",mysamples[i],".xlsx"))
}



#==============================================
# Unit-level models-biased
#==============================================

##Reading sample and census files
census<- read_dta("census/census_bias.dta")
census<-as.data.frame(census)

mysamples <- list.files("rawsamples_bias/bias55/selected") 
mybetas <- list.files("vars_selected_bias/bias55/betavars_selected_bias") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
  ### Variables for EBP model
  assign(paste0("beta"),                                   # Read and store data frames
         read_dta(paste0("vars_selected_bias/bias55/betavars_selected_bias/",
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
         read_dta(paste0("rawsamples_bias/bias55/selected/",
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
                      threshold = 7.1200103, #LOG 7.464 , nO LOG 1744.69
                      na.rm=TRUE,
                      L=100,   #default is 50
                      model_parameters="fixed",
                      indicators=c("Head_Count")
  )
  
  simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
  coefficients <- as.data.frame(((ebp$model$coefficients$fixed)))
  colnames(simulation) <- c("area",  "fgt") 
  names<-as.data.frame(rownames(coefficients))
  coefficients<-cbind(names,coefficients)
  colnames(coefficients) <- c("names","coefficients") 
  write_dta(simulation, paste0("results/bias/results_ebp/unit/output_bias55/sim_ebp_",mysamples[i]))
  write_dta(coefficients, paste0("results/bias/results_ebp/unit/model_bias55/coef_",mysamples[i]))
  write.excel(ebp, paste0("results/bias/results_ebp/unit/model_bias55/model_",mysamples[i],".xlsx"))
}


###Biased version 2
##Reading sample and census files
census<- read_dta("census/census_bias.dta")
census<-as.data.frame(census)

mysamples <- list.files("rawsamples_bias/bias11b11/selected") 
mybetas <- list.files("vars_selected_bias/bias11b11/betavars_selected_bias") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
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
                      weights = "FACTOR",
                      weights_type = "hybrid",
                      nlme_opt="optim",
                      rescale_weights = T,
                      transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                      MSE = F,
                      cpus = 10,
                      threshold = 7.1200103, #LOG 7.464 , nO LOG 1744.69
                      na.rm=TRUE,
                      L=100,   #default is 50
                      model_parameters="fixed",
                      indicators=c("Head_Count")
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
                      weights = "FACTOR",
                      weights_type = "hybrid",
                      nlme_opt="optim",
                      rescale_weights = T,
                      transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                      MSE = F,
                      cpus = 10,
                      threshold = 7.1200103, #LOG 7.464 , nO LOG 1744.69
                      na.rm=TRUE,
                      L=100,   #default is 50
                      model_parameters="fixed",
                      indicators=c("Head_Count")
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
# Unit-context models
#==============================================

##Reading sample and census files
census<- read_dta("census/census_bias.dta")
census<-as.data.frame(census)

mysamples <- list.files("rawsamples_bias/bias55/selected") 
mybetas <- list.files("vars_selected_bias/context/bias55/betavars_selected_bias") 
myalphas <- list.files("vars_selected_bias/context/bias55/alphavars_selected_bias") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      ### Variables for EBP model
      assign(paste0("beta"),                                   # Read and store data frames
             read_dta(paste0("vars_selected_bias/context/bias55/betavars_selected_bias/",
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
             read_dta(paste0("vars_selected_bias/context/bias55/alphavars_selected_bias/",
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
             read_dta(paste0("rawsamples_bias/bias55/selected/",
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
                          threshold = 7.1200103, #LOG 7.464 , nO LOG 1744.69
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
      write_dta(simulation, paste0("results/bias/results_ell/context/output_bias55/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/bias/results_ell/context/model_bias55/coef_",mysamples[i]))
      #write.excel(levels(ell$model_par), paste0("results/results_ell/context/model/model_",mysamples[i],".xlsx"))
}

### Biased version 2

##Reading sample and census files
census<- read_dta("census/census_bias.dta")
census<-as.data.frame(census)

mysamples <- list.files("rawsamples_bias/bias11b11/selected") 
mybetas <- list.files("vars_selected_bias/context/bias11b11/betavars_selected_bias") 
myalphas <- list.files("vars_selected_bias/context/bias11b11/alphavars_selected_bias") 

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
  
  ### Variables for Alpha model
  assign(paste0("alpha"),                                   # Read and store data frames
         read_dta(paste0("vars_selected_bias/context/bias11b11/alphavars_selected_bias/",
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
         read_dta(paste0("rawsamples_bias/bias11b11/selected/",
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
                      threshold = 7.1200103, #LOG 7.464 , nO LOG 1744.69
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
  write_dta(simulation, paste0("results/bias/results_ell/context/output_bias11b11/sim_ebp_",mysamples[i]))
  write_dta(coefficients, paste0("results/bias/results_ell/context/model_bias11b11/coef_",mysamples[i]))
  #write.excel(levels(ell$model_par), paste0("results/results_ell/context/model/model_",mysamples[i],".xlsx"))
}

#==============================================
# Unit-context models-unbiased
#==============================================

##Reading sample and census files
census<- read_dta("census/census_bias.dta")
census<-as.data.frame(census)

mysamples <- list.files("rawsamples_bias/nobias/selected") 
mybetas <- list.files("vars_selected_bias/context/nobias/betavars_selected_nobias") 
myalphas <- list.files("vars_selected_bias/context/nobias/alphavars_selected_nobias") 

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
      
      ### Variables for Alpha model
      assign(paste0("alpha"),                                   # Read and store data frames
             read_dta(paste0("vars_selected_bias/context/nobias/alphavars_selected_nobias/",
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
             read_dta(paste0("rawsamples_bias/nobias/selected/",
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
                          threshold = 7.1200103, #LOG 7.464 , nO LOG 1744.69
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
      write_dta(simulation, paste0("results/bias/results_ell/context/output_nobias/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/bias/results_ell/context/model_nobias/coef_",mysamples[i]))
      #write.excel(levels(ell$model_par), paste0("results/results_ell/context/model/model_",mysamples[i],".xlsx"))
}

