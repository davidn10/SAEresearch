library(tidyverse)
library(parallel)
library(pbmcapply) # wrapper for mclapply that lets me see progress
library(povmap)
library(haven)
library("povmap")

#detach(package:povmap)
#devtools::install_github("SSA-Statistical-Team-Projects/povmap", ref="david2")

set.seed(7)

#setwd("D:/SAE_project/MEX/2010/full_census_new")
setwd("D:/david/SAE/SAE_research_with_Melany/MEX/2015/full_census_new")

#==============================================
# Sample 1
#==============================================

##Reading sample and census files
census<- read_dta("census/census_subebp.dta")
census<-as.data.frame(census)

mysamples <- list.files("subarea_ebp/sample1") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      ###Reading sample data
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("subarea_ebp/sample1/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      drop <- c("psu_id", "mun_id", "poor_direct","FACTOR","FACTOR_res","FACTOR_res2")
      coef_names<- colnames(sample[,!(names(sample) %in% drop)])
      ebpformula <- paste0(coef_names[1])
      for (x in 2:length(coef_names)){
            ebpformula <- paste0(ebpformula, " + ", coef_names[x])
      }
      ebpformula <- paste0("poor_direct ~ ", ebpformula)
      ebpformula <- as.formula(ebpformula)
      
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
                          threshold = NULL, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=100,   #default is 50
                          model_parameters="fixed",
                          indicators=c("Mean")
      )
      
      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean))
      coefficients <- as.data.frame(((ebp$model$coefficients$fixed)))
      colnames(simulation) <- c("area",  "mean") 
      names<-as.data.frame(rownames(coefficients))
      coefficients<-cbind(names,coefficients)
      colnames(coefficients) <- c("names","coefficients") 
      write_dta(simulation, paste0("results/results_sub_ebp/sample1/output_h/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/results_sub_ebp/sample1/model_h/coef_",mysamples[i]))
      write.excel(ebp, paste0("results/results_sub_ebp/sample1/model_h/model_",mysamples[i],".xlsx"))
}


### Sample2
mysamples <- list.files("subarea_ebp/sample2") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      ###Reading sample data
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("subarea_ebp/sample2/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      drop <- c("psu_id", "mun_id", "poor_direct","FACTOR","FACTOR_res","FACTOR_res2")
      coef_names<- colnames(sample[,!(names(sample) %in% drop)])
      ebpformula <- paste0(coef_names[1])
      for (x in 2:length(coef_names)){
            ebpformula <- paste0(ebpformula, " + ", coef_names[x])
      }
      ebpformula <- paste0("poor_direct ~ ", ebpformula)
      ebpformula <- as.formula(ebpformula)
      
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
                          threshold = NULL, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=100,   #default is 50
                          model_parameters="fixed",
                          indicators=c("Mean")
      )
      
      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean))
      coefficients <- as.data.frame(((ebp$model$coefficients$fixed)))
      colnames(simulation) <- c("area",  "mean") 
      names<-as.data.frame(rownames(coefficients))
      coefficients<-cbind(names,coefficients)
      colnames(coefficients) <- c("names","coefficients") 
      write_dta(simulation, paste0("results/results_sub_ebp/sample2/output_h/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/results_sub_ebp/sample2/model_h/coef_",mysamples[i]))
      write.excel(ebp, paste0("results/results_sub_ebp/sample2/model_h/model_",mysamples[i],".xlsx"))
}

### Sample3
mysamples <- list.files("subarea_ebp/sample3") 

for(i in 1:length(mysamples)) {                              # Head of for-loop
      ###Reading sample data
      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("subarea_ebp/sample3/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      drop <- c("psu_id", "mun_id", "poor_direct","FACTOR","FACTOR_res","FACTOR_res2")
      coef_names<- colnames(sample[,!(names(sample) %in% drop)])
      ebpformula <- paste0(coef_names[1])
      for (x in 2:length(coef_names)){
            ebpformula <- paste0(ebpformula, " + ", coef_names[x])
      }
      ebpformula <- paste0("poor_direct ~ ", ebpformula)
      ebpformula <- as.formula(ebpformula)
      
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
                          threshold = NULL, #LOG 7.464 , nO LOG 1744.69
                          na.rm=TRUE,
                          L=100,   #default is 50
                          model_parameters="fixed",
                          indicators=c("Mean")
      )
      
      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean))
      coefficients <- as.data.frame(((ebp$model$coefficients$fixed)))
      colnames(simulation) <- c("area",  "mean") 
      names<-as.data.frame(rownames(coefficients))
      coefficients<-cbind(names,coefficients)
      colnames(coefficients) <- c("names","coefficients") 
      write_dta(simulation, paste0("results/results_sub_ebp/sample3/output_h/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/results_sub_ebp/sample3/model_h/coef_",mysamples[i]))
      write.excel(ebp, paste0("results/results_sub_ebp/sample3/model_h/model_",mysamples[i],".xlsx"))
}