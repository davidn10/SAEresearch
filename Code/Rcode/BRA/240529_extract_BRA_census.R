library(censobr)
library(arrow)
library(dplyr)
library(ggplot2)
library(haven)

#Link for documentation: "https://cran.r-project.org/web/packages/censobr/vignettes/documentation.html"

setwd("D:/SAE_project/BRA")


###Individual level data
dta<-data_dictionary(year = 2010, dataset = 'population', showProgress = FALSE)

pop <- read_population(year = 2010,
                       columns = c('abbrev_state', 'V0001','V0002','V0011','V0300','V0010','V1001','V1002','V1003','V1004','V1006','V0502','V0601','V6033',
                                   'V0606','V0627','V0628','V0629','V0630','V0631','V0632','V0633','V0634','V0635','V6400','V0639','V0640','V0641','V0642',
                                   'V0643','V0644','V0645','V6511','V6513','V0652','V6521','V6525','V6527','V6529','V6531','V5060','V5070', 'V0654', 'V0648',
                                   'V6036', 'V6900', 'V6910', 'V6920', 'V6930'),
                       add_labels = 'pt',
                       showProgress = FALSE)
df <- pop |>
      filter(abbrev_state == "MG") |>                                                    
      collect()

#Collect groups 1 of states

final<-as.data.frame(df)
write_dta(final, "2010/full_census/rawdata/BRA_1_2010.dta")

#Collect groups 2 of states
df <- pop |>
      filter(abbrev_state == "AC" | abbrev_state == "AL" | abbrev_state == "AM" | abbrev_state == "AP") |>                                                    
      collect()

final<-as.data.frame(df)
write_dta(final, "2010/full_census/rawdata/BRA_2_2010.dta")

#Collect groups 3 of states
df <- pop |>
      filter(abbrev_state == "BA" | abbrev_state == "CE") |>                                                    
      collect()

final<-as.data.frame(df)
write_dta(final, "2010/full_census/rawdata/BRA_3_2010.dta")

#Collect groups 4 of states
df <- pop |>
      filter(abbrev_state == "DF" | abbrev_state == "ES" | abbrev_state == "GO" | abbrev_state == "MA") |>                                                    
      collect()

final<-as.data.frame(df)
write_dta(final, "2010/full_census/rawdata/BRA_4_2010.dta")

#Collect groups 5 of states
df <- pop |>
      filter(abbrev_state == "MS" | abbrev_state == "MT" | abbrev_state == "PA" | abbrev_state == "PB") |>                                                    
      collect()

final<-as.data.frame(df)
write_dta(final, "2010/full_census/rawdata/BRA_5_2010.dta")


#Collect groups 6 of states
df <- pop |>
      filter(abbrev_state == "PE" | abbrev_state == "PI" | abbrev_state == "PR") |>                                                    
      collect()

final<-as.data.frame(df)
write_dta(final, "2010/full_census/rawdata/BRA_6_2010.dta")

#Collect groups 7 of states
df <- pop |>
      filter(abbrev_state == "RJ" | abbrev_state == "RN") |>                                                    
      collect()

final<-as.data.frame(df)
write_dta(final, "2010/full_census/rawdata/BRA_7_2010.dta")

#Collect groups 8 of states
df <- pop |>
      filter(abbrev_state == "RO" | abbrev_state == "RR" | abbrev_state == "RS") |>                                                    
      collect()

final<-as.data.frame(df)
write_dta(final, "2010/full_census/rawdata/BRA_8_2010.dta")

#Collect groups 9 of states
df <- pop |>
      filter(abbrev_state == "SC" | abbrev_state == "SE" | abbrev_state == "TO") |>                                                    
      collect()

final<-as.data.frame(df)
write_dta(final, "2010/full_census/rawdata/BRA_9_2010.dta")

#Collect groups 10 of states
df <- pop |>
      filter(abbrev_state == "SP") |>                                                    
      collect()

final<-as.data.frame(df)
write_dta(final, "2010/full_census/rawdata/BRA_10_2010.dta")


###household level data
#hh<-data_dictionary(year = 2010, dataset = 'households', showProgress = FALSE)

hs <- read_households(year = 2010, 
                      showProgress = FALSE)
final<-as.data.frame(hs)
write_dta(final, "2010/full_census/rawdata/BRA_VIV_2010.dta")


####################################################################3
dta<-data_dictionary(year = 2000, dataset = 'population', showProgress = FALSE)

pop <- read_population(year = 2000,
                       columns = c('abbrev_state', 'V0102','V0103','V0104','V0105','V1005','V1006','V0300',
                                   'V0401','V0402','V0403','V4752','V4754','V0408','V0428','V0429','V0430',
                                   'V0431','V0432','V0433','V0434','V4300','V0439','V0440','V0441','V0442','V0443','V0447',
                                   'V4511', 'V0455','PES_PESSOA','AREAP','V4512','V4513','V4614','V4522','V4523','V4525'),
                       showProgress = FALSE)
df <- pop |>
      filter(abbrev_state == "MG") |>                                                    
      collect()

final<-as.data.frame(df)

#Collect groups 1 of states

final<-as.data.frame(df)
#write_dta(final, "2010/rawdata/BRA_MG_2010.dta")
write_dta(final, "2000/rawdata/BRA_1_2000.dta")

#Collect groups 2 of states
df <- pop |>
      filter(abbrev_state == "AC" | abbrev_state == "AL" | abbrev_state == "AM" | abbrev_state == "AP") |>                                                    
      collect()

final<-as.data.frame(df)
#write_dta(final, "2010/rawdata/BRA_AC_AL_AM_AP_2010.dta")
write_dta(final, "2000/rawdata/BRA_2_2000.dta")

#Collect groups 3 of states
df <- pop |>
      filter(abbrev_state == "BA" | abbrev_state == "CE") |>                                                    
      collect()

final<-as.data.frame(df)
#write_dta(final, "2010/rawdata/BRA_BA_CE_2010.dta")
write_dta(final, "2000/rawdata/BRA_3_2000.dta")

#Collect groups 4 of states
df <- pop |>
      filter(abbrev_state == "DF" | abbrev_state == "ES" | abbrev_state == "GO" | abbrev_state == "MA") |>                                                    
      collect()

final<-as.data.frame(df)
#write_dta(final, "2010/rawdata/BRA_DF_ES_GO_MA_2010.dta")
write_dta(final, "2000/rawdata/BRA_4_2000.dta")

#Collect groups 5 of states
df <- pop |>
      filter(abbrev_state == "MS" | abbrev_state == "MT" | abbrev_state == "PA" | abbrev_state == "PB") |>                                                    
      collect()

final<-as.data.frame(df)
#write_dta(final, "2010/rawdata/BRA_MS_MT_PA_PB_2010.dta")
write_dta(final, "2000/rawdata/BRA_5_2000.dta")


#Collect groups 6 of states
df <- pop |>
      filter(abbrev_state == "PE" | abbrev_state == "PI" | abbrev_state == "PR") |>                                                    
      collect()

final<-as.data.frame(df)
#write_dta(final, "2010/rawdata/BRA_PE_PI_PR_2010.dta")
write_dta(final, "2000/rawdata/BRA_6_2000.dta")

#Collect groups 7 of states
df <- pop |>
      filter(abbrev_state == "RJ" | abbrev_state == "RN") |>                                                    
      collect()

final<-as.data.frame(df)
#write_dta(final, "2010/rawdata/BRA_RJ_RN_2010.dta")
write_dta(final, "2000/rawdata/BRA_7_2000.dta")

#Collect groups 8 of states
df <- pop |>
      filter(abbrev_state == "RO" | abbrev_state == "RR" | abbrev_state == "RS") |>                                                    
      collect()

final<-as.data.frame(df)
#write_dta(final, "2010/rawdata/BRA_RO_RR_RS_2010.dta")
write_dta(final, "2000/rawdata/BRA_8_2000.dta")

#Collect groups 9 of states
df <- pop |>
      filter(abbrev_state == "SC" | abbrev_state == "SE" | abbrev_state == "TO") |>                                                    
      collect()

final<-as.data.frame(df)
#write_dta(final, "2010/rawdata/BRA_SC_SE_TO_2010.dta")
write_dta(final, "2000/rawdata/BRA_9_2000.dta")

#Collect groups 10 of states
df <- pop |>
      filter(abbrev_state == "SP") |>                                                    
      collect()

final<-as.data.frame(df)
#write_dta(final, "2010/rawdata/BRA_SP_2010.dta")
write_dta(final, "2000/rawdata/BRA_10_2000.dta")

###household level data
dta<-data_dictionary(year = 2000, dataset = 'households', showProgress = FALSE)

hs <- read_households(year = 2000, 
                      showProgress = FALSE)
final<-as.data.frame(hs)
write_dta(final, "2000/rawdata/BRA_VIV_2000.dta")


