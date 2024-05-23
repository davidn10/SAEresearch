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
# Mexico: ELL Unit-level models
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
      
Y_true<- ell$alpha_model$model$transformed_eps_squared
Y_pred<- ell$alpha_model$fitted.values

ssresidfull<-sum((Y_true- Y_pred)^2) 
sstotfull <- sum((Y_true - mean(Y_true))^2)

#sprintf("percent variance explained, R^2: %1.2f%%", 100 * (1 - ssresidfull / sstotfull))

#==============================================
# Mexico: ELL Unit-level models 2015
#==============================================
setwd("D:/SAE_project/MEX/2015/full_census_new")

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
                    threshold = 7.1200103, #LOG 7.464 , nO LOG 1744.69
                    na.rm=TRUE,
                    L=100,   #default is 50
                    model_parameters="fixed",
                    indicators=c("Head_Count")
)

Y_true<- ell$alpha_model$model$transformed_eps_squared
Y_pred<- ell$alpha_model$fitted.values

ssresidfull2<-sum((Y_true- Y_pred)^2) 
sstotfull2 <- sum((Y_true - mean(Y_true))^2)


#==============================================
# Mexico: ELL Unit-level models 2020
#==============================================
setwd("D:/SAE_project/MEX/2020/full_census")

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
                    threshold = 7.3851231, #LOG 7.464 , nO LOG 1744.69
                    na.rm=TRUE,
                    L=100,   #default is 50
                    model_parameters="fixed",
                    indicators=c("Head_Count")
)

Y_true<- ell$alpha_model$model$transformed_eps_squared
Y_pred<- ell$alpha_model$fitted.values

ssresidfull3<-sum((Y_true- Y_pred)^2) 
sstotfull3 <- sum((Y_true - mean(Y_true))^2)



###Brazil case

setwd("D:/SAE_project/BRA/2010/full_census")

#==============================================
# Brazil: ELL Unit-level models
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)

sample<- read_dta("rawsamples/selected/sample_50.dta")
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
                    threshold = 5.098808322, #LOG 7.464 , nO LOG 1744.69
                    na.rm=TRUE,
                    L=100,   #default is 50
                    model_parameters="fixed",
                    indicators=c("Head_Count")
)

Y_true<- ell$alpha_model$model$transformed_eps_squared
Y_pred<- ell$alpha_model$fitted.values

ssresidfull4<-sum((Y_true- Y_pred)^2) 
sstotfull4 <- sum((Y_true - mean(Y_true))^2)


sprintf("MEX 2010, R^2: %1.2f%%", 100 * (1 - ssresidfull / sstotfull))
sprintf("MEX 2015, R^2: %1.2f%%", 100 * (1 - ssresidfull2 / sstotfull2))
sprintf("MEX 2020, R^2: %1.2f%%", 100 * (1 - ssresidfull3 / sstotfull3))
sprintf("BRA 2010, R^2: %1.2f%%", 100 * (1 - ssresidfull4 / sstotfull4))



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
