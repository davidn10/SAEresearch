library(xgboost)
library(tidyverse)
library(parallel)
library(pbmcapply) # wrapper for mclapply that lets me see progress
library(povmap)
library(haven)
library("povmap")

#detach(package:povmap)
#devtools::install_github("SSA-Statistical-Team-Projects/povmap", ref="master")

set.seed(7)

setwd("D:/SAE_project/MEX/2010/full_census_new")

#==============================================
# Unit-level models
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)

sample<- read_dta("rawsamples_full/selected/sample_50.dta")
sample<-as.data.frame(sample)

beta<- read_dta("betavars_selected/beta_50.dta")
beta<-as.data.frame(beta)

coef_names<- colnames(beta[,])
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
                    weights_type = "hybrid",
                    nlme_opt="optim",
                    rescale_weights = T,
                    transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                    MSE = F,
                    cpus = 10,
                    threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
                    na.rm=TRUE,
                    L=100,   #default is 50
                    model_parameters="fixed",
                    indicators=c("Head_Count")
      )
      
simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
coefficients <- as.data.frame(((ebp$model_par$betas)))
colnames(simulation) <- c("area",  "fgt") 
names<-as.data.frame(rownames(coefficients))
coefficients<-cbind(names,coefficients)
colnames(coefficients) <- c("names","coefficients") 
write_dta(simulation, "results/model_sample/unit_ebp_sim_50.dta")
write_dta(coefficients, "results/model_sample/unit_ebp_coef_50.dta")
write.excel(ebp, "results/model_sample/unit_ebp_model_50.xlsx")



#==============================================
# Unit-context models
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)

sample<- read_dta("rawsamples_full/selected/sample_50.dta")
sample<-as.data.frame(sample)

beta<- read_dta("context/betavars_selected/beta_50.dta")
beta<-as.data.frame(beta)

coef_names<- colnames(beta[,])
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
                    weights_type = "hybrid",
                    nlme_opt="optim",
                    rescale_weights = T,
                    transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                    MSE = F,
                    cpus = 10,
                    threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
                    na.rm=TRUE,
                    L=100,   #default is 50
                    model_parameters="fixed",
                    indicators=c("Head_Count")
)

simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
coefficients <- as.data.frame(((ebp$model_par$betas)))
colnames(simulation) <- c("area", "fgt") 
names<-as.data.frame(rownames(coefficients))
coefficients<-cbind(names,coefficients)
colnames(coefficients) <- c("names","coefficients") 
write_dta(simulation, "results/model_sample/context_ebp_sim_50.dta")
write_dta(coefficients, "results/model_sample/context_ebp_coef_50.dta")
write.excel(ebp, "results/model_sample/context_ebp_model_50.xlsx")

#==============================================
# ELL Unit-level models
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)

sample<- read_dta("rawsamples_full/selected/sample_50.dta")
sample<-as.data.frame(sample)

beta<- read_dta("betavars_selected/beta_50.dta")
beta<-as.data.frame(beta)

alpha<- read_dta("alphavars_selected/alpha_50.dta")
alpha<-as.data.frame(alpha)

coef_names<- colnames(beta[,])
ebpformula <- paste0(coef_names[1])
for (x in 2:length(coef_names)){
      ebpformula <- paste0(ebpformula, " + ", coef_names[x])
}
ebpformula <- paste0("ln_pchinc ~ ", ebpformula)
ebpformula <- as.formula(ebpformula)
      
coef_anames<- colnames(alpha[,])
alphaformula <- paste0(coef_anames[1])
for (x in 2:length(coef_anames)){
      alphaformula <- paste0(alphaformula, " + ", coef_anames[x])
}
alphaformula  <- as.formula(paste0("~",alphaformula))
      
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
                    threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
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
write_dta(simulation, "results/model_sample/unit_ell_sim_50.dta")
write_dta(coefficients, "results/model_sample/unit_ell_coef_50.dta")
#write.excel(ebp, "results/model_sample/unit_ebp_model_50.xlsx")


#==============================================
# ELL Context-level models
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)

sample<- read_dta("rawsamples_full/selected/sample_50.dta")
sample<-as.data.frame(sample)

beta<- read_dta("context/betavars_selected/beta_50.dta")
beta<-as.data.frame(beta)

alpha<- read_dta("context/alphavars_selected/alpha_50.dta")
alpha<-as.data.frame(alpha)

coef_names<- colnames(beta[,])
ebpformula <- paste0(coef_names[1])
for (x in 2:length(coef_names)){
      ebpformula <- paste0(ebpformula, " + ", coef_names[x])
}
ebpformula <- paste0("ln_pchinc ~ ", ebpformula)
ebpformula <- as.formula(ebpformula)

coef_anames<- colnames(alpha[,])
alphaformula <- paste0(coef_anames[1])
for (x in 2:length(coef_anames)){
      alphaformula <- paste0(alphaformula, " + ", coef_anames[x])
}
alphaformula  <- as.formula(paste0("~",alphaformula))

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
                    threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
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
write_dta(simulation, "results/model_sample/context_ell_sim_50.dta")
write_dta(coefficients, "results/model_sample/context_ell_coef_50.dta")
#write.excel(ebp, "results/model_sample/unit_ebp_model_50.xlsx")
