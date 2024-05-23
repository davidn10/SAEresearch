library(xgboost)
library(tidyverse)
library(parallel)
library(pbmcapply) # wrapper for mclapply that lets me see progress
library(povmap)
library(haven)
library("povmap")

#detach(package:povmap)
#devtools::install_github("SSA-Statistical-Team-Projects/povmap", ref="david3")

set.seed(7)

setwd("D:/SAE_project/MEX/2010/full_census_new")

#==============================================
# Unit-context models-hybrid
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)

sample<- read_dta("rawsamples_full/selected/sample_50.dta")
sample<-as.data.frame(sample)

beta<- read_dta("context/betavars_selected_nopsu/beta_50.dta")
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
                    #Ydump=paste0("results/results_ebp/predictions_sample/ydump_h_context_50_2010.csv")
                    )

X_smp <- model.matrix(ebp$fixed, ebp$framework$smp_data)   
n_smp<-as.vector(table(ebp$framework$smp_domains_vec))
dist_obs_dom<-unique(ebp$framework$pop_domains_vec) %in% unique(ebp$framework$smp_domains_vec)
Yhat<-X_smp%*%ebp$model_par$betas + rep(ebp$model_par$rand_eff[dist_obs_dom],n_smp)
Ybarhat_h2<-weighted.mean(Yhat,w=ebp$framework$smp_data$FACTOR)


simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
coefficients <- as.data.frame(((ebp$model_par$betas)))
colnames(simulation) <- c("area",  "fgt") 
names<-as.data.frame(rownames(coefficients))
coefficients<-cbind(names,coefficients)
colnames(coefficients) <- c("names","coefficients") 

residuals1<-as.data.frame(ebp$model_par$e0)
residuals2<-as.data.frame(ebp$model_par$e1)

homosk<-cbind(Yhat, residuals1, residuals2)
colnames(homosk) <- c("Yhat",  "residuals1", "residuals2") 

write_dta(simulation, "results/results_ebp/predictions_sample/nopsu/context_ebph_sim_50_2010.dta")
write_dta(homosk, "results/results_ebp/predictions_sample/nopsu/context_ebph_res_50_2010.dta")
write_dta(coefficients, "results/results_ebp/predictions_sample/nopsu/context_ebph_coef_50_2010.dta")
write.excel(ebp, "results/results_ebp/predictions_sample/nopsu/context_ebph_model_50_2010.xlsx")


#==============================================
# Unit-context models-nlme
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)

sample<- read_dta("rawsamples_full/selected/sample_50.dta")
sample<-as.data.frame(sample)

beta<- read_dta("context/betavars_selected_nopsu/beta_50.dta")
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
                    weights_type = "nlme",
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
                    #Ydump=paste0("results/results_ebp/predictions_sample/ydump_h_context_50_2010.csv")
)

X_smp <- model.matrix(ebp$fixed, ebp$framework$smp_data)   
n_smp<-as.vector(table(ebp$framework$smp_domains_vec))
dist_obs_dom<-unique(ebp$framework$pop_domains_vec) %in% unique(ebp$framework$smp_domains_vec)
Yhat<-X_smp%*%ebp$model_par$betas + rep(ebp$model_par$rand_eff[dist_obs_dom],n_smp)
Ybarhat_nlme2<-weighted.mean(Yhat,w=ebp$framework$smp_data$FACTOR)


simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
coefficients <- as.data.frame(((ebp$model_par$betas)))
colnames(simulation) <- c("area",  "fgt") 
names<-as.data.frame(rownames(coefficients))
coefficients<-cbind(names,coefficients)
colnames(coefficients) <- c("names","coefficients") 

residuals1<-as.data.frame(ebp$model_par$e0)
residuals2<-as.data.frame(ebp$model_par$e1)

homosk<-cbind(Yhat, residuals1, residuals2)
colnames(homosk) <- c("Yhat",  "residuals1", "residuals2") 

write_dta(simulation, "results/results_ebp/predictions_sample/nopsu/context_ebpnlme_sim_50_2010.dta")
write_dta(homosk, "results/results_ebp/predictions_sample/nopsu/context_ebpnlme_res_50_2010.dta")
write_dta(coefficients, "results/results_ebp/predictions_sample/nopsu/context_ebpnlme_coef_50_2010.dta")
write.excel(ebp, "results/results_ebp/predictions_sample/nopsu/context_ebpnlme_model_50_2010.xlsx")

#==============================================
# Unit-context models-wow
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)

sample<- read_dta("rawsamples_full/selected/sample_50.dta")
sample<-as.data.frame(sample)

beta<- read_dta("context/betavars_selected_nopsu/beta_50.dta")
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
                    weights = NULL,
                    #weights_type = "nlme",
                    nlme_opt="optim",
                    #rescale_weights = T,
                    transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                    MSE = F,
                    cpus = 10,
                    threshold = 6.869814491, #LOG 7.464 , nO LOG 1744.69
                    na.rm=TRUE,
                    L=100,   #default is 50
                    model_parameters="fixed",
                    indicators=c("Head_Count")
                    #Ydump=paste0("results/results_ebp/predictions_sample/ydump_h_context_50_2010.csv")
)

X_smp <- model.matrix(ebp$fixed, ebp$framework$smp_data)   
n_smp<-as.vector(table(ebp$framework$smp_domains_vec))
dist_obs_dom<-unique(ebp$framework$pop_domains_vec) %in% unique(ebp$framework$smp_domains_vec)
Yhat<-X_smp%*%ebp$model_par$betas + rep(ebp$model_par$rand_eff[dist_obs_dom],n_smp)
Ybarhat_wow2<-mean(Yhat)


simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
coefficients <- as.data.frame(((ebp$model_par$betas)))
colnames(simulation) <- c("area",  "fgt") 
names<-as.data.frame(rownames(coefficients))
coefficients<-cbind(names,coefficients)
colnames(coefficients) <- c("names","coefficients") 

residuals1<-as.data.frame(ebp$model_par$e0)
residuals2<-as.data.frame(ebp$model_par$e1)

homosk<-cbind(Yhat, residuals1, residuals2)
colnames(homosk) <- c("Yhat",  "residuals1", "residuals2") 

write_dta(simulation, "results/results_ebp/predictions_sample/nopsu/context_ebpwow_sim_50_2010.dta")
write_dta(homosk, "results/results_ebp/predictions_sample/nopsu/context_ebpwow_res_50_2010.dta")
write_dta(coefficients, "results/results_ebp/predictions_sample/nopsu/context_ebpwow_coef_50_2010.dta")
write.excel(ebp, "results/results_ebp/predictions_sample/nopsu/context_ebpwow_model_50_2010.xlsx")


#==============================================
# Unit-context models-G
#==============================================

##Reading sample and census files
census<- read_dta("census/census.dta")
census<-as.data.frame(census)

sample<- read_dta("rawsamples_full/selected/sample_50.dta")
sample<-as.data.frame(sample)

beta<- read_dta("context/betavars_selected_nopsu/beta_50.dta")
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
                    weights_type = "Guadarrama",
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
                    #Ydump=paste0("results/results_ebp/predictions_sample/ydump_h_context_50_2010.csv")
)

X_smp <- model.matrix(ebp$fixed, ebp$framework$smp_data)   
n_smp<-as.vector(table(ebp$framework$smp_domains_vec))
dist_obs_dom<-unique(ebp$framework$pop_domains_vec) %in% unique(ebp$framework$smp_domains_vec)
Yhat<-X_smp%*%ebp$model_par$betas + rep(ebp$model_par$rand_eff[dist_obs_dom],n_smp)
Ybarhat_g2<-mean(Yhat)


simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean, ebp$ind$Head_Count))
coefficients <- as.data.frame(((ebp$model_par$betas)))
colnames(simulation) <- c("area",  "fgt") 
names<-as.data.frame(rownames(coefficients))
coefficients<-cbind(names,coefficients)
colnames(coefficients) <- c("names","coefficients") 

residuals1<-as.data.frame(ebp$model_par$e0)
residuals2<-as.data.frame(ebp$model_par$e1)

homosk<-cbind(Yhat, residuals1, residuals2)
colnames(homosk) <- c("Yhat",  "residuals1", "residuals2") 

write_dta(simulation, "results/results_ebp/predictions_sample/nopsu/context_ebpg_sim_50_2010.dta")
write_dta(homosk, "results/results_ebp/predictions_sample/nopsu/context_ebpg_res_50_2010.dta")
write_dta(coefficients, "results/results_ebp/predictions_sample/nopsu/context_ebpg_coef_50_2010.dta")
write.excel(ebp, "results/results_ebp/predictions_sample/nopsu/context_ebpg_model_50_2010.xlsx")



