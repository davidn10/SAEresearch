
###############################################
## XGB models
library(haven)
library(sp)
library(foreign)
library(doParallel)
library(povmap) 


set.seed(7)

setwd("D:/david/SAE/SAE_research_with_Melany/BRA/2010/full_census_new/")

##Reading sample and census files

mysamples <- list.files("subarea_ebp",pattern=".dta") 
mybetas <- list.files("betavars_selected") 
mcoptions <- list(preschedule=TRUE) 
getDoParWorkers()

census<- read_dta("census/census_subarea.dta")
census<-as.data.frame(census)

#sample<- read_dta("subarea/samples/sample_1.dta")
#sample<-as.data.frame(sample)

#Model and results
gc()
cl <- makeCluster(10)
registerDoParallel(cl)
mcoptions <- list(preschedule=TRUE) 
#all.tunable.params <- c("sample.fraction", "mtry", "min.node.size", 
#                        "honesty.fraction", "honesty.prune.leaves", "alpha", 
#                        "imbalance.penalty")

#for(i in 1:length(mysamples)) {                              # Head of for-loop
ebplist <- foreach(i=1:100,.options.multicore=mcoptions,.packages=c("haven","povmap")) %dopar% { # Head of for-loop 

  ###Reading sample data
  assign(paste0("sample"),                                   # Read and store data frames
         read_dta(paste0("subarea_ebp/",
                         mysamples[i])))
  sample<-as.data.frame(sample)
  # rescale weights 
  wbar <- ave(sample$FACTOR,sample$mun_id)
  sample$FACTOR <- sample$FACTOR/wbar 
  wbar <- NULL 
  drop <- c("psu_id", "mun_id", "poor_direct","FACTOR")
  coef_names<- colnames(sample[,!(names(sample) %in% drop)])
  ebpformula <- paste0(coef_names[1])
  for (x in 2:length(coef_names)){
    ebpformula <- paste0(ebpformula, " + ", coef_names[x])
  }
  ebpformula <- paste0("poor_direct ~ ", ebpformula)
  ebpformula <- as.formula(ebpformula)
      
      ebp <- povmap:::hdp(fixed = ebpformula,
                          pop_data = census,
                          pop_domains = "mun_id",
                          pop_weights = "popwt",
                          smp_data = sample,
                          smp_domains = "mun_id",
                          weights = "FACTOR",
                          transformation = "no", #"no", "log", "box.cox", "log.shift", "ordernorm"
                          MSE = F,
                          na.rm=TRUE
                          #threshold = 5.3249649, #LOG 7.464 , nO LOG 1744.69
                          
                          #Ydump=paste0("results/results_ebp/all/unit/model/ydump_",mysamples[i],".csv")
      )
      
      
      simulation <- as.data.frame(cbind(levels(ebp$ind$Domain), ebp$ind$Mean))
      coefficients <- as.data.frame(((ebp$model$coefficients)))
      colnames(simulation) <- c("area",  "fgt") 
      names<-as.data.frame(rownames(coefficients))
      coefficients<-cbind(names,coefficients)
      colnames(coefficients) <- c("names","coefficients") 
      write_dta(simulation, paste0("results/results_hdp/output_h/sim_ebp_",mysamples[i]))
     # write_dta(coefficients, paste0("results/results_hdp/model_h/coef_",mysamples[i]))
      #povmap:::write.excel(ebp, paste0("results/results_hdp/model_h/model_",mysamples[i],".xlsx"))
      
      
  
}

parallel::stopCluster(cl = cl)



