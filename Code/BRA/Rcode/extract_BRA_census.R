library(censobr)
library(arrow)
library(dplyr)
library(ggplot2)
library(haven)

#Link for documentation: "https://cran.r-project.org/web/packages/censobr/vignettes/documentation.html"

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

final<-as.data.frame(df)
write_dta(final, "C:/Users/melyg/Desktop/SAE_Project/data/BRA/BRA_MG_2010.dta")

###household level data
hh<-data_dictionary(year = 2010, dataset = 'households', showProgress = FALSE)

hs <- read_households(year = 2010, 
                      showProgress = FALSE)
final<-as.data.frame(hs)
write_dta(final, "C:/Users/melyg/Desktop/SAE_Project/data/BRA/BRA_VIV_2010.dta")

#Only Minas Gerais
df <- hs |>
      filter(abbrev_state == "MG") |>                                                    
      collect()

final<-as.data.frame(df)
write_dta(final, "C:/Users/melyg/Desktop/SAE_Project/data/BRA/BRA_MG_VIV_2010.dta")


####################################################################3

pop <- read_population(year = 2000,
                       columns = c('abbrev_state', 'V0300','V0400','V0401','V0402','V0403','V4752','V4754','V0408','V0428','V0429','V0430','V0431','V0432',
                                   'V0433','V0434','V4355','V4300','V0439','V0440','V4511','V4512','V4513','V4614','V4522','V4523','V4525'),
                       showProgress = FALSE)
df <- pop |>
      filter(abbrev_state == "MG") |>                                                    
      collect()

final<-as.data.frame(df)

write_dta(final, "C:/Users/melyg/Desktop/SAE_Project/data/BRA/BRA_MG_2000.dta")

###household level data
hs <- read_households(year = 2000, 
                      showProgress = FALSE)
final<-as.data.frame(hs)
write_dta(final, "C:/Users/melyg/Desktop/SAE_Project/data/BRA/BRA_VIV_2000.dta")

#Only Minas Gerais
df <- hs |>
      filter(abbrev_state == "MG") |>                                                    
      collect()

final<-as.data.frame(df)
write_dta(final, "C:/Users/melyg/Desktop/SAE_Project/data/BRA/BRA_MG_VIV_2000.dta")

