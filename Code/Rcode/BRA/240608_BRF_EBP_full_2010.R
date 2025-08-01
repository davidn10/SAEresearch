
###############################################
## BRF models
library(grf)
library(haven)
library(sp)
library(foreign)

set.seed(7)

setwd("D:/david/SAE/SAE_research_with_Melany/BRA/2010/full_census_new/")


census<- read_dta("census/census_subarea.dta")
census<-as.data.frame(census)

#sample<- read_dta("subarea/samples/sample_1.dta")
#sample<-as.data.frame(sample)

mysamples <- list.files("subarea/samples") 

#Model and results

cl <- makeCluster(10)
registerDoParallel(cl)
mcoptions <- list(preschedule=TRUE) 
ebpformula <- poor_direct ~ predictions

#for(i in 1:length(mysamples)) {                              # Head of for-loop
brflist <- foreach(i=1:100,.options.multicore=mcoptions,.packages=c("haven","grf","povmap")) %dopar% { # Head of for-loop 

      assign(paste0("sample"),                                   # Read and store data frames
             read_dta(paste0("subarea/samples/",
                             mysamples[i])))
      sample<-as.data.frame(sample)
      sample<-sample[complete.cases(sample),]
      
      yvar <- as.vector(sample$poor_direct)
      x_covar<-sample[,-(1:6)]
      x_covar<-as.data.frame(data.matrix(x_covar))
      
      brf_results <- boosted_regression_forest(X=x_covar,Y = yvar, 
                                               sample.weights = sample$FACTOR_res2, 
                                               cluster = as.factor(sample$mun_id), 
                                               tune.parameters = "all", honesty=F,num.trees=10000) 
      
      predictions <- predict(brf_results,census[,colnames(x_covar)]) 
      
      smp_predictions <- predict(brf_results,sample[,colnames(x_covar)])
      sample2 <- cbind(sample$poor_direct,sample$mun_id,sample$FACTOR,smp_predictions)
      census2 <- cbind(census$mun_id,census$popwt,predictions)
      colnames(sample2)[1:3] <- c("poor_direct","mun_id","FACTOR")
      colnames(census2)[1:2] <- c("mun_id","popwt")
      ebp <- povmap:::ebp(fixed = ebpformula,
                          pop_data = census2,
                          pop_domains = "mun_id",
                          pop_weights = "popwt",
                          smp_data = sample2,
                          smp_domains = "mun_id",
                          weights = "FACTOR",
                          weights_type = "hybrid",
                          nlme_opt="optim",
                          rescale_weights = T,
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          threshold = NULL, 
                          na.rm=TRUE,
                          L=0,   #default is 50
                          model_parameters="fixed",
                          indicators=c("Mean")
      )
      
      
      #select<-subset(census, select = c(mun_id, psu_id))
      #results<-as.data.frame(cbind(select, predictions))
      #write_dta(results, paste0("results/results_BRF_v2/BRF_", mysamples[i]))
      
      
      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean))
      coefficients <- as.data.frame(((ebp$model$coefficients$fixed)))
      colnames(simulation) <- c("area",  "fgt") 
      names<-as.data.frame(rownames(coefficients))
      coefficients<-cbind(names,coefficients)
      colnames(coefficients) <- c("names","coefficients") 
      write_dta(simulation, paste0("results/results_BRF_EBP/output_h/sim_ebp_",mysamples[i]))
      write_dta(coefficients, paste0("results/results_BRF_EBP/model_h/coef_",mysamples[i]))
      povmap:::write.excel(ebp, paste0("results/results_BRF_EBP/model_h/model_",mysamples[i],".xlsx"))
      
}
parallel::stopCluster(cl = cl)
 


