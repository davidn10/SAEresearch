#detach(package:povmap)
#install.packages("D:/david/povmap", repos = NULL, type="source")
###############################################
## BRF models
library(povmap)
library(haven)
library(sp)
library(foreign)
library(doParallel)
library(dplyr)
set.seed(7)

#setwd("D:/SAE_project/MEX/2010/full_census_new/")
setwd("D:/david/SAE/SAE_research_with_Melany/MEX/2015/full_census_new")

census<- read_dta("census/census_subarea.dta")
census<-as.data.frame(census)
census<-census[complete.cases(census),]

gc()
cl <- makeCluster(8)
registerDoParallel(cl)
mcoptions <- list(preschedule=TRUE)


mysamples <- list.files("subarea/fullsamples") 


#Model and results
#for(i in 50:50) {                              # Head of for-loop
xgblist <- foreach(i=1:100,.options.multicore=mcoptions,.packages=c("haven","povmap","dplyr")) %dopar% { # Head of for-loop 
    
      assign(paste0("sample"),                                   # Read and store data frames
                read_dta(paste0("subarea/fullsamples/",
                                mysamples[i])))
      
      
      sample<-as.data.frame(sample)
      #drop_cols <- grep("^state_", names(sample), value = TRUE)  
      #sample <- sample[, !names(sample) %in% drop_cols] 
      
      sample<-sample[complete.cases(sample),]
      
      yvar <- as.vector(sample$poor_direct)
      xvars<-strsplit(colnames(sample[,-c(1:6)])," ")
      formula <-  paste(xvars,collapse=" + ")
      formula <- as.formula(paste0("poor_direct","~",formula))
      
      # tuning did worse 
      #tune <- povmap:::xgb_tune(fixed = formula,smp_data = sample,smp_weights="FACTOR_res2",domains="mun_id",transformation="no",objective = "reg:logistic")
      
      xgb_results <- povmap:::xgb(fixed = formula, smp_data=sample, 
                                pop_data=census,pop_weights="popwt",
                                domains="mun_id",sub_domains="psu_id", bootstrap=T, 
                                transformation="no",
                                smp_weights="FACTOR_res2",
                                # nround=tune$nround,
                                # max_depth=tune$max_depth,
                                # colsample_bytree =tune$colsample_bytree,
                                # colsample_bylevel =tune$colsample_bylevel,
                                # colsample_bynode = tune$colsample_bynode,
                                # subsample=tune$subsample,
                                # min_child_weight = tune$min_child_weight,
                                # eta=tune$eta,
                                # gamma=tune$gamma,
                                # max_delta_step = tune$max_delta_step,
                                # lambda=tune$lambda,
                                # alpha=tune$alpha,
                                na.rm=T,weightedBS=T, center_residuals=F,
                                objective = "reg:logistic"
      )
      
      
      
      write_dta(xgb_results$ind, paste0("results/results_xgb/output/sim_xgb_",mysamples[i]))
      povmap:::write.excel(xgb_results, paste0("results/results_xgb/model/model_",mysamples[i],".xlsx"))

      
      
      
}
parallel::stopCluster(cl = cl)
 


