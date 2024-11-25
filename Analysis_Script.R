# Manuscript Title:
# Early Pandemic Associations of Latitude, Sunshine Duration, and Vitamin D Status with COVID-19 Incidence and Fatalities: A Global Analysis of 187 Countries
# Prepared by Reagan M. Mogire

# -------------------------------------------------
# Load Necessary Libraries
# -------------------------------------------------
library(ggplot2)
library(tidyverse)
library(ggpmisc)
library(dplyr)
library(jtools)
library(ggrepel)
library(ggpubr)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(ggplot2)
library(tidyverse)
library(ggpmisc)
library(dplyr)
library(jtools)
library(ggrepel)

# -------------------------------------------------
# Table 1: Summary Statistics
# -------------------------------------------------
setwd("/Users/mogirerm/Library/CloudStorage/OneDrive-NationalInstitutesofHealth/Old work/COVID_19/Github")  # Set working directory (replace with your actual path)
mydata = read.csv("Dataset_For_Analysis.csv")

# Data cleaning
mydata <- mydata[!is.na(mydata$Hemisphere), ]   # Remove ships or entries with NA in Hemisphere
mydata$Cases <- as.numeric(mydata$Cases_30JN)   # Cases as of June 30
mydata$Deaths <- as.numeric(mydata$Deaths_30JN) # Deaths as of June 30
mydata$Population <- as.numeric(mydata$Population)  # Force variable to be numeric

# Calculate prevalence of cases and mortality rate
mydata$prevCases <- (mydata$Cases / mydata$Population) * 1e6   # Prevalence per million
mydata$MRDeaths <- (mydata$Deaths / mydata$Population) * 1e6   # Mortality rate per million
mydata$cfr <- (mydata$Deaths / mydata$Cases) * 100             # Case Fatality Rate (%)

# Number of countries by region
table(mydata$Region)

# Remove missing values
mydata2 <- mydata[!is.na(mydata$MRDeaths), ]  # Remove NAs in MRDeaths
mydata3 <- mydata[!is.na(mydata$prevCases), ] # Remove NAs in prevCases
mydata4 <- mydata[!is.na(mydata$Cases), ]     # Remove NAs in Cases
mydata5 <- mydata[!is.na(mydata$Deaths), ]    # Remove NAs in Deaths
mydata6 <- mydata[!is.na(mydata$cfr), ]       # Remove NAs in CFR

data.frame(colnames(mydata))  # Return column names

# Mean prevalence rate by region
aggregate(mydata3[, c(30)], list(mydata3$Region), mean)

# Mean mortality rate by region
aggregate(mydata2[, c(31)], list(mydata2$Region), mean)

# Case fatality rate by region
aggregate(mydata6[, c(32)], list(mydata6$Region), mean)

# Sum of cases by region
aggregate(mydata4[, c(28)], list(mydata$Region), sum)

# Sum of deaths by region
aggregate(mydata5[, c(29)], list(mydata$Region), sum)

# Overall statistics
n_distinct(mydata$Countryf)            # Number of distinct countries
sum(mydata$Cases)                      # Total number of cases
sum(mydata$Deaths)                     # Total number of deaths
mean(mydata$prevCases, na.rm = TRUE)   # Mean prevalence of cases
mean(mydata$MRDeaths, na.rm = TRUE)    # Mean mortality rate
mean(mydata$cfr, na.rm = TRUE)         # Mean case fatality rate

# -------------------------------------------------
# Table 2: Regression Analyses (June 30)
# -------------------------------------------------

# ----------------------------------
# Latitude Analysis
# ----------------------------------

dlat = read.csv("Dataset_For_Analysis.csv")
dlat <- dlat[!is.na(dlat$Hemisphere), ]  # Remove ships
dlat$Cases <- as.numeric(dlat$Cases_30JN)   # Cases as of June 30
dlat$Deaths <- as.numeric(dlat$Deaths_30JN) # Deaths as of June 30
dlat$Density <- as.numeric(dlat$Density)    # Force variable to be numeric
dlat$EDR <- as.numeric(dlat$EDR)           # Force variable to be numeric
dlat$GDP_PC <- as.numeric(dlat$GDP_PC)     # Force variable to be numeric

# Replace zeros with NA to avoid issues in regression
dlat$EDR[which(dlat$EDR == 0)] <- NA
dlat$Density[which(dlat$Density == 0)] <- NA
dlat$GDP_PC[which(dlat$GDP_PC == 0)] <- NA

dlat$Population <- as.numeric(dlat$Population)  # Force variable to be numeric
dlat$prevCases <- (dlat$Cases / dlat$Population) * 1e6  # Prevalence per million
dlat$prevCases[which(dlat$prevCases == 0)] <- 0.0001    # Adjust zeros for log transformation

dlat$Deaths[which(dlat$Deaths == 0)] <- 0.0001          # Adjust zeros for log transformation
dlat$MRDeaths <- (dlat$Deaths / dlat$Population) * 1e6  # Mortality rate per million

dlat$Deaths[which(dlat$Deaths == 0)] <- NA    # Convert zeros to NA
dlat$Cases[which(dlat$Cases == 0)] <- NA      # Convert zeros to NA
dlat$cfr <- (dlat$Deaths / dlat$Cases) * 100  # Case Fatality Rate (%)
dlat$cfr[which(dlat$cfr == 0)] <- 0.0001      # Adjust zeros for log transformation

# Prevalence of cases vs latitude
reg1 = lm(log(dlat$prevCases) ~ dlat$Latitude)
summary(reg1)
summ(reg1, confint = TRUE, digits = 3)

# Multivariable regression including confounders
reg1 = lm(log(dlat$prevCases) ~ dlat$Latitude + log(dlat$EDR) + log(dlat$Density) + log(dlat$GDP_PC))
summary(reg1)
summ(reg1, confint = TRUE, digits = 3)

# Mortality rate vs latitude
reg1 = lm(log(dlat$MRDeaths) ~ dlat$Latitude)
summary(reg1)
summ(reg1, confint = TRUE, digits = 3)

# Multivariable regression including confounders
reg1 = lm(log(dlat$MRDeaths) ~ dlat$Latitude + log(dlat$EDR) + log(dlat$Density) + log(dlat$GDP_PC))
summary(reg1)
summ(reg1, confint = TRUE, digits = 3)

# Case Fatality Rate vs latitude
reg1 = lm(log(dlat$cfr) ~ dlat$Latitude)
summary(reg1)
summ(reg1, confint = TRUE, digits = 3)

# Multivariable regression including confounders
reg1 = lm(log(dlat$cfr) ~ dlat$Latitude + log(dlat$EDR) + log(dlat$Density) + log(dlat$GDP_PC))
summary(reg1)
summ(reg1, confint = TRUE, digits = 3)

# ----------------------------------
# Sunshine Analysis
# ----------------------------------

dsun = read.csv("Dataset_For_Analysis.csv")
dsun <- dsun[!is.na(dsun$Hemisphere), ]  # Remove ships
dsun$Cases <- as.numeric(dsun$Cases_30JN)   # Cases as of June 30
dsun$Deaths <- as.numeric(dsun$Deaths_30JN) # Deaths as of June 30

# Calculate average sunshine hours
clnames <- c("Jan", "Feb", "Mar", "Apr", "May", "June")
dsun$avghours <- rowMeans(dsun[clnames])  # Average sunshine hours for the first six months

# Convert variables to numeric
dsun$Density <- as.numeric(dsun$Density)   # Force variable to be numeric
dsun$EDR <- as.numeric(dsun$EDR)          # Force variable to be numeric
dsun$Sunshine <- as.numeric(dsun$Sunshine) # Force variable to be numeric
dsun$GDP_PC <- as.numeric(dsun$GDP_PC)     # Force variable to be numeric

# Replace zeros with NA to avoid issues in regression
dsun$EDR[which(dsun$EDR == 0)] <- NA
dsun$Density[which(dsun$Density == 0)] <- NA
dsun$GDP_PC[which(dsun$GDP_PC == 0)] <- NA

# Prevalence of cases vs sunshine
dsun$Population <- as.numeric(dsun$Population)  # Force variable to be numeric
dsun$prevCases <- (dsun$Cases / dsun$Population)  # Calculate prevalence

g = lm(log(dsun$prevCases) ~ log(dsun$avghours))
summary(g)
summ(g, confint = TRUE, digits = 3)

# Multivariable regression including confounders
g = lm(log(dsun$prevCases) ~ log(dsun$avghours) + log(dsun$EDR) + log(dsun$Density) + log(dsun$GDP_PC))
summary(g)
summ(g, confint = TRUE, digits = 3)

# Mortality rate vs sunshine
dsun$Deaths[which(dsun$Deaths == 0)] <- 0.0001   # Adjust zeros for log transformation
dsun$MRDeaths <- (dsun$Deaths / dsun$Population) * 1e6  # Mortality rate per million

g = lm(log(dsun$MRDeaths) ~ log(dsun$avghours))
summary(g)
summ(g, confint = TRUE, digits = 2)

# Multivariable regression including confounders
g = lm(log(dsun$MRDeaths) ~ log(dsun$avghours) + log(dsun$EDR) + log(dsun$Density) + log(dsun$GDP_PC))
summary(g)
summ(g, confint = TRUE, digits = 2)

# Case Fatality Rate vs sunshine
dsun$Deaths[which(dsun$Deaths == 0)] <- NA    # Convert zeros to NA
dsun$Cases[which(dsun$Cases == 0)] <- NA      # Convert zeros to NA
dsun$cfr <- (dsun$Deaths / dsun$Cases) * 100  # Case Fatality Rate (%)
dsun$cfr[which(dsun$cfr == 0)] <- 0.0001      # Adjust zeros for log transformation

g = lm((dsun$cfr) ~ log(dsun$avghours))
summary(g)
summ(g, confint = TRUE, digits = 2)

# Multivariable regression including confounders
g = lm((dsun$cfr) ~ log(dsun$avghours) + log(dsun$EDR) + log(dsun$Density) + log(dsun$GDP_PC))
summary(g)
summ(g, confint = TRUE, digits = 2)

# ----------------------------------
# Vitamin D Analysis
# ----------------------------------

dvitd <- read.csv("Dataset_For_Analysis.csv", header = TRUE)
dvitd$Cases <- as.numeric(dvitd$Cases_30JN)     # Cases as of June 30
dvitd$Deaths <- as.numeric(dvitd$Deaths_30JN)   # Deaths as of June 30
dvitd <- dvitd[!is.na(dvitd$Hemisphere), ]      # Remove ships
dvitd$vitd[which(dvitd$vitd == 0)] <- NA        # Replace zeros with NA

# Convert variables to numeric
dvitd$Density <- as.numeric(dvitd$Density)    # Force variable to be numeric
dvitd$EDR <- as.numeric(dvitd$EDR)           # Force variable to be numeric
dvitd$GDP_PC <- as.numeric(dvitd$GDP_PC)     # Force variable to be numeric
dvitd$vitd <- as.numeric(dvitd$vitd)         # Force variable to be numeric

# Replace zeros with NA to avoid issues in regression
dvitd$EDR[which(dvitd$EDR == 0)] <- NA
dvitd$Density[which(dvitd$Density == 0)] <- NA
dvitd$GDP_PC[which(dvitd$GDP_PC == 0)] <- NA

# Prevalence of cases vs Vitamin D levels
dvitd$Population <- as.numeric(dvitd$Population)  # Force variable to be numeric
dvitd$prevCases <- (dvitd$Cases / dvitd$Population)  # Calculate prevalence

g = lm(log(dvitd$prevCases) ~ dvitd$vitd)
summary(g)
summ(g, confint = TRUE, digits = 3)

# Multivariable regression including confounders
g = lm(log(dvitd$prevCases) ~ dvitd$vitd + log(dvitd$EDR) + log(dvitd$Density) + log(dvitd$GDP_PC))
summary(g)
summ(g, confint = TRUE, digits = 3)

# Mortality rate vs Vitamin D levels
dvitd$Deaths[which(dvitd$Deaths == 0)] <- 0.0001   # Adjust zeros for log transformation
dvitd$MRDeaths <- (dvitd$Deaths / dvitd$Population) * 1e6  # Mortality rate per million

g = lm(log(dvitd$MRDeaths) ~ dvitd$vitd)
summary(g)
summ(g, confint = TRUE, digits = 3)

# Multivariable regression including confounders
g = lm(log(dvitd$MRDeaths) ~ dvitd$vitd + log(dvitd$EDR) + log(dvitd$Density) + log(dvitd$GDP_PC))
summary(g)
summ(g, confint = TRUE, digits = 3)

# Case Fatality Rate vs Vitamin D levels
dvitd$Deaths[which(dvitd$Deaths == 0)] <- NA    # Convert zeros to NA
dvitd$Cases[which(dvitd$Cases == 0)] <- NA      # Convert zeros to NA
dvitd$cfr <- (dvitd$Deaths / dvitd$Cases) * 100 # Case Fatality Rate (%)
dvitd$vitd[which(dvitd$vitd == 0)] <- NA        # Replace zeros with NA
dvitd$cfr[which(dvitd$cfr == 0)] <- 0.0001      # Adjust zeros for log transformation

g = lm(log(dvitd$cfr) ~ dvitd$vitd)
summary(g)
summ(g, confint = TRUE, digits = 3)

# Multivariable regression including confounders
g = lm(log(dvitd$cfr) ~ dvitd$vitd + log(dvitd$EDR) + log(dvitd$Density) + log(dvitd$GDP_PC))
summary(g)
summ(g, confint = TRUE, digits = 3)


# -------------------------------------------------
# Supplementary Analyses for March and September
# -------------------------------------------------
# Supplementary Table 1: Effect of latitude, amount of sunshine, and Vitamin D status on COVID-19 prevalence, mortality rate, and case fatality rate in the month of March and August

# You can replicate the above analyses for different dates (e.g., March 31, September 30)
# by adjusting the 'Cases' and 'Deaths' variables accordingly.

# Example for March 31:
# dlat$Cases <- as.numeric(dlat$Cases_31MR)
# dlat$Deaths <- as.numeric(dlat$Deaths_31MR)
# Proceed with the same steps as above.

# Example for Sept 30:
# dlat$Cases <- as.numeric(dlat$Cases_30S)
# dlat$Deaths <- as.numeric(dlat$Deaths_30S)
# Proceed with the same steps as above.


# -------------------------------------------------
# Figure 2: Correlation Graphs
# -------------------------------------------------

# Latitude Analysis
# Cases vs Latitude
dlat = read.csv("Dataset_For_Analysis.csv")
dlat <- dlat[!is.na(dlat$Hemisphere), ]  # Remove ships
dlat$Cases <- as.numeric(dlat$Cases_30JN)   # Cases as of June 30
dlat$Deaths <- as.numeric(dlat$Deaths_30JN) # Deaths as of June 30
dlat$Population <- as.numeric(dlat$Population)  # Force variable to be numeric

# Calculate prevalence, mortality rate, and CFR
dlat$prevCases <- (dlat$Cases / dlat$Population) * 1e6  # Prevalence per million
dlat$MRDeaths <- (dlat$Deaths / dlat$Population) * 1e6  # Mortality rate per million
dlat$cfr <- (dlat$Deaths / dlat$Cases) * 100             # Case Fatality Rate (%)

# Plot prevalence vs latitude
my.formula <- y ~ x
pCasesL <- ggplot(data = dlat, aes(x = Latitude, y = log(Cases))) +
  geom_smooth(method = "lm", se = TRUE, formula = my.formula) +
  stat_poly_eq(formula = my.formula,
               eq.with.lhs = "italic(hat(y))~`=`~",
               aes(label = paste(..eq.label.., ..rr.label.., sep = "*plain(\",\")~")),
               parse = TRUE) +
  ggtitle("A. Prevalence vs latitude") +
  labs(y = "Prevalence of COVID-19 cases \n (log scale)", x = "Latitude") +
  geom_point() +
  theme(axis.line.x = element_line(colour = 'black', size = 0.5, linetype = 'solid'),
        axis.line.y = element_line(colour = 'black', size = 0.5, linetype = 'solid'))
pCasesL

#Mortality rate vs lat
my.formula <- y~x
pDeathsL <- ggplot(data = dlat, aes(x=Latitude, y = log(MRDeaths) )) +
  geom_smooth(method = "lm", se= T, formula = my.formula) +
  stat_poly_eq(formula = my.formula,
               eq.with.lhs = "italic(hat(y))~`=`~",
               aes(label = paste(..eq.label.., ..rr.label.., sep = "*plain(\",\")~")),
               parse = TRUE)+
  ggtitle("B. Mortality rate vs latitude")+
  labs(y= "Mortality rate \n (log scale)", x =  "Latitude")+
  geom_point()+
  theme(axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.5, linetype='solid'))
pDeathsL

#CFR vs lat
#plot  using latitude
my.formula <- y~x
pCFRL <- ggplot(data = dlat, aes(x=Latitude, y = log(cfr) )) +
  geom_smooth(method = "lm", se= T, formula = my.formula) +
  stat_poly_eq(formula = my.formula,
               eq.with.lhs = "italic(hat(y))~`=`~",
               aes(label = paste(..eq.label.., ..rr.label.., sep = "*plain(\",\")~")),
               parse = TRUE)+
  ggtitle("C. Case fatality rate vs latitude")+
  labs(y= "Case fatality rate (%) \n (log scale)", x =  "Latitude")+
  geom_point()+
  theme(axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.5, linetype='solid'))
pCFRL


#SUNSHINE
#####PREV Cases vs sunshine
#prepare dataset
dsun = read.csv("Dataset_For_Analysis.csv")
dsun$Cases <- as.numeric(dsun$Cases_30JN) # replace values with the correct ones for these analyses
dsun$Deaths <- as.numeric(dsun$Deaths_30JN) # replace values with the correct ones for these analyses
clnames <- c("Jan", "Feb", "Mar", "Apr", "May", "June")
dsun$avghours <- rowMeans(dsun[clnames] ) # find avarage for the first six months

dsun$Population <- as.numeric(dsun$Population) # force variable to be numeric
dsun$prevCases <- (dsun$Cases/dsun$Population) # calculate prevalence
dsun$MRDeaths <- (dsun$Deaths/dsun$Population*1000000) # calculate prevalence
dsun$cfr <- (dsun$Deaths/dsun$Cases*100) # calculate CFR

#prevalence cases vs sunshine

my.formula <- y ~ x
pCasesS <- ggplot(data = dsun, aes(x=log(avghours), y = log(prevCases) )) +
  geom_smooth(method = "lm", se= T, formula = my.formula) +
  stat_poly_eq(formula = my.formula,
               eq.with.lhs = "italic(hat(y))~`=`~",
               aes(label = paste(..eq.label.., ..rr.label.., sep = "*plain(\",\")~")),
               parse = TRUE)+
  ggtitle("D. Prevalence vs hours of sunshine")+
  labs(y= "Prevalence of COVID-19 cases \n (log scale)", x =  "Average hours of sunshine (hrs)\n (log scale)")+
  geom_point()+
  theme(axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.5, linetype='solid'))

pCasesS

#Mortality rate vs sunshine

my.formula <- y ~ x
pDeathsS <- ggplot(data = dsun, aes(x=log(avghours), y = log(MRDeaths) )) +
  geom_smooth(method = "lm", se= T, formula = my.formula) +
  stat_poly_eq(formula = my.formula,
               eq.with.lhs = "italic(hat(y))~`=`~",
               aes(label = paste(..eq.label.., ..rr.label.., sep = "*plain(\",\")~")),
               parse = TRUE)+
  ggtitle("E. Mortality rate vs hours of sunshine")+
  labs(y= "Mortality rate \n (log scale)", x =  "Average hours of sunshine (hrs)\n (log scale)")+
  geom_point()+
  theme(axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.5, linetype='solid'))

pDeathsS

#CFR vs sunshine

my.formula <- y ~ x
pCFRS <- ggplot(data = dsun, aes(x=log(avghours), y = log(cfr) )) +
  geom_smooth(method = "lm", se= T, formula = my.formula) +
  stat_poly_eq(formula = my.formula,
               eq.with.lhs = "italic(hat(y))~`=`~",
               aes(label = paste(..eq.label.., ..rr.label.., sep = "*plain(\",\")~")),
               parse = TRUE)+
  ggtitle("F. Case fatality rate vs hours of sunshine")+
  labs(y= "Case fatality rate (%)\n (log scale)", x =  "Average hours of sunshine (hrs)\n (log scale)")+
  geom_point()+
  theme(axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.5, linetype='solid'))

pCFRS


#VITD
#prepare vitamin D  dataset
dvitd <- read.csv("Dataset_For_Analysis.csv", header = T)
dvitd$Cases <- as.numeric(dvitd$Cases_30JN) # replace values with the correct ones for these analyses
dvitd$Deaths <- as.numeric(dvitd$Deaths_30JN) # replace values with the correct ones for these analyses
dvitd <-dvitd[!is.na(dvitd$Hemisphere), ] #remove ships
dvitd$vitd[which(dvitd$vitd==0)]=NA # replace all vitamin D levels equal to zero to NA
dvitd$Population <- as.numeric(dvitd$Population) # force variable to be numeric
dvitd$prevCases <- (dvitd$Cases/dvitd$Population) # calculate prevalence
dvitd$MRDeaths <- (dvitd$Deaths/dvitd$Population*1000000) # calculate prevalence
dvitd$cfr <- (dvitd$Deaths/dvitd$Cases*100) # calculate CFR

#prevalence of Cases vs vitd
my.formula <- y ~ x
pCasesV <- ggplot(data = dvitd, aes(x=vitd, y = log(prevCases) )) +
  geom_smooth(method = "lm", se= T, formula = my.formula) +
  stat_poly_eq(formula = my.formula,
               eq.with.lhs = "italic(hat(y))~`=`~",
               aes(label = paste(..eq.label.., ..rr.label.., sep = "*plain(\",\")~")),
               parse = TRUE)+
  ggtitle("G. Prevalence vs mean 25(OH)D levels")+
  labs(y= "Prevalence of COVID-19 cases \n (log scale)", x =  "25(OH)D levels \n (nmol/L)")+
  geom_point()+
  theme(axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.5, linetype='solid'))
pCasesV

# Mortality rate vs vitd

#prevalence of Cases vs vitd
my.formula <- y ~ x
pDeathsV <- ggplot(data = dvitd, aes(x=vitd, y = log(MRDeaths) )) +
  geom_smooth(method = "lm", se= T, formula = my.formula) +
  stat_poly_eq(formula = my.formula,
               eq.with.lhs = "italic(hat(y))~`=`~",
               aes(label = paste(..eq.label.., ..rr.label.., sep = "*plain(\",\")~")),
               parse = TRUE)+
  ggtitle("H. Mortality rate vs mean 25(OH)D levels")+
  labs(y= "Mortality rate \n (log scale)", x =  "25(OH)D levels \n (nmol/L)")+
  geom_point()+
  theme(axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.5, linetype='solid'))
pDeathsV

#CFR vs vitd 

my.formula <- y ~ x
pCFRV <- ggplot(data = dvitd, aes(x=vitd, y = log(cfr) )) +
  geom_smooth(method = "lm", se= T, formula = my.formula) +
  stat_poly_eq(formula = my.formula,
               eq.with.lhs = "italic(hat(y))~`=`~",
               aes(label = paste(..eq.label.., ..rr.label.., sep = "*plain(\",\")~")),
               parse = TRUE)+
  ggtitle("I. Case fatality rate vs mean 25(OH)D levels")+
  labs(y= "Case fatality rate (%) \n (log scale)", x =  "25(OH)D levels \n (nmol/L)")+
  geom_point()+
  theme(axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.5, linetype='solid'))
pCFRV

# Arrange all plots into one page
library(ggpubr)
ggarrange(pCasesL, pDeathsL, pCFRL, pCasesS, pDeathsS, pCFRS, pCasesV, pDeathsV, pCFRV, ncol = 3, nrow = 3)

# Save the figure
ggsave("Figure_2.pdf", height = 14, width = 12)


# -------------------------------------------------
# World Maps: Prevalence and CFR by Country
# -------------------------------------------------

# World maps - showing prevalence and CFR by country

# Load world map data
world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)

# Calculate centroids for label placement
world_points <- st_centroid(world)
world_points <- cbind(world, st_coordinates(st_centroid(world$geometry)))

# Load main dataset
maindataset = read.csv("Dataset_For_Analysis.csv")
maindataset$Population <- as.numeric(maindataset$Population)  # Force variable to be numeric
maindataset$Cases <- as.numeric(maindataset$Cases_30JN)       # Cases as of June 30
maindataset$Deaths <- as.numeric(maindataset$Deaths_30JN)     # Deaths as of June 30
maindataset$prevCases <- ((maindataset$Cases / maindataset$Population) * 1e6)  # Prevalence per million
maindataset$cfr <- (maindataset$Deaths / maindataset$Cases) * 100              # Case Fatality Rate (%)

maindataset = maindataset %>% select(Country4, Prevalence, cfr, Country_prev, Country_cfr)
maindataset <- maindataset %>% rename(name = Country4)  # Rename for merging

# Merge dataset
mainworld = merge(world, maindataset, by = "name", all = TRUE)
world_points <- merge(world_points, maindataset, by = "name", all = TRUE)

# Plot CFR by country
ggplot(data = mainworld) +
  geom_sf(aes(fill = cfr)) +
  scale_fill_gradient(low = "yellow", high = "red", na.value = "grey") +
  ggtitle("COVID-19 Case Fatality Rate") +
  xlab("Longitude") + ylab("Latitude") +
  theme(panel.grid.major = element_line(color = gray(0.5), size = 0.5),
        panel.background = element_rect(fill = "aliceblue")) +
  coord_sf(ylim = c(-50, 90)) +
  geom_text(data = world_points, aes(x = X, y = Y, label = Country_cfr),
            size = 1.5, color = "black", fontface = "bold", check_overlap = FALSE)
ggsave("Figure_1_CFR_Map.pdf", height = 8, width = 13)

# Plot Prevalence by country
ggplot(data = mainworld) +
  geom_sf(aes(fill = Prevalence)) +
  scale_fill_gradient(low = "yellow", high = "red", na.value = "grey") +
  ggtitle("Prevalence of COVID-19") +
  xlab("Longitude") + ylab("Latitude") +
  theme(panel.grid.major = element_line(color = gray(0.5), size = 0.5),
        panel.background = element_rect(fill = "aliceblue")) +
  coord_sf(ylim = c(-50, 90)) +
  geom_text(data = world_points, aes(x = X, y = Y, label = Country_prev),
            size = 1.5, color = "black", fontface = "bold", check_overlap = FALSE)
ggsave("Supplementary_Figure_1_Prevalence_Map.pdf", height = 8, width = 13)
