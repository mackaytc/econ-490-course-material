################################################################################
# ECON 490 R Code for Capstone Advice for Outline Advice Metrics Slides
################################################################################

# We'll use several data sets in the code below. If you'd like to run the code, 
# make sure to set your working directory to wherever you've saved the CPS 
# data set that we used for the Data Analysis Output homework assignment.

rm(list = ls())

# Load necessary libraries

library(tidyverse)
library(ggplot2)

# Change working directory below: 

setwd(paste0("C:/Users/macka/CSU Fullerton Dropbox/Taylor Mackay/", 
             "ECON-490-capstone-data/Individual-Level CPS Data"))

# Load CPS data set used in class activities and homework: 

cps.data <- readRDS("individual-level-CPS-data.Rds")

# Load capstone crime data set:  

crime.url <- paste0("https://raw.githubusercontent.com/mackaytc/R-resources/", 
                    "main/data/crime-data-state-by-year/", 
                    "crime-data-state-by-year.csv")

crime.data <- read_csv(crime.url)

# Load capstone longer-run state economic data: 

state.data <- paste0("https://raw.githubusercontent.com/mackaytc/R-resources/", 
                     "main/data/longer-run-state-level-data/", 
                     "longer-run-state-by-year-data.csv")

state.data <- read_csv(state.data)

# Combine both data sets using inner_join(): 

working.data <- inner_join(state.data, crime.data, 
                           by = c("year", "statefip", "state_name")) %>% 
  select(-total_population.x)

################################################################################
# Filtering and Splitting Your Data 
################################################################################

# Key points from the slides: 

#   - Sometimes we want to filter our data to include only specific observations
#       (especially when we have individual-level data)...

#   - If you have aggregated data (i.e., state or county level) think twice 
#       before you split your data across e.g. years - ask yourself, "Is there
#       an interaction regression I can run?"

# Let's revisit crime ~ unemployment rate regressions using state-by-year level
# data. Here's the simple OLS relationship we've seen previously: 

summary(lm(rate_property_crime ~ unemp_rate, working.data))

# Filtering data to run for just a subset of observations - let's say we only 
# want to include California. Compare this to full sample output above:

CA.data <- filter(working.data, state_name == "California")

# Regression below uses only California observations - we're estimating the Y~X
# relationship ONLY for California. 

summary(lm(rate_property_crime ~ unemp_rate, CA.data))

# KEY POINT: We've seen another way to do this that uses all of our available 
# data (which helps with precision == smaller SE's, more flexibilty, etc.). 

# We can use interaction regression with a 0/1 variable for being California (1
# if California and 0 otherwise) - start by creating this using ifelse()

working.data <- mutate(working.data, 
                       CA.indicator = ifelse(state_name == "California", 1, 0))

# Check our new variable: 

table(working.data$state_name, working.data$CA.indicator)

# Now include it in our regression above by interacting with unemp_rate (NOTE
# that we're using our ORIGINAL full working data set here): 

CA.interaction <- 
  lm(rate_property_crime ~ unemp_rate + CA.indicator + 
       unemp_rate:CA.indicator, working.data)

summary(CA.interaction)

# For all non-CA states, each percentage point increase in unemployment rates is 
# associated with the following increase in crime rates: 

CA.interaction$coefficients["unemp_rate"]

# In California, this relationship is given by: 

CA.interaction$coefficients["unemp_rate"] + 
  CA.interaction$coefficients["unemp_rate:CA.indicator"]

################################################################################
# Checking for Missing Data, Outliers, and "Weird Data"
################################################################################

# Let's use the CPS data set to see several common functions for inspecting 
# your data. 

# Summary() function provides standard descriptive output based on what type of 
# variable you're summarizing. 

# The inc.wage variable is numeric - notice all the NA's!

summary(cps.data$inc.wage)

# Citizenship is a factor variable, so we get the number of observations with 
# each level of the variable. 

summary(cps.data$citizen)

# The table() function is also useful for checking factor variables: 

table(cps.data$poverty.status)

# Let's take a look at the weekly earnings variable - the max value is $2,885: 

summary(cps.data$weekly.earnings)

# We can draw a density plot of earnings at the upper end of the earnings range:

ggplot(aes(x = weekly.earnings), 
       data = filter(cps.data, weekly.earnings > 2000)) + 
  geom_density()
(cps.data$weekly.earnings)

# Hmm, notice how things spike at the right hand side of the distribution? 

filter(cps.data, weekly.earnings > 2000) %>% 
  pull(weekly.earnings) %>% 
  table()

# Earnings are "top-coded" in Census data sets - this means that for weekly 
# earnings, everyone with an income above $2,885 gets assigned $2,885 as their 
# income value for privacy reasons. 

# As a general rule of thumb, if you're using a top-coded variable in a
# regression, you should keep these observations, but remember that this
# top-coding is an important piece of context for interpretation. 

# Last note - if you have a numeric variable where some values should be counted
# as missing / NA, you can set them to missing using the following template. 

# Let's use the ind variable as an example - we want to set all the values of 
# ind == 770 to missing.

# Let's see how many total missing values ind has: 

nrow(filter(cps.data, is.na(ind)))

# Now, let's see how many observations have ind == 770 (should be 29,713): 

nrow(filter(cps.data, ind == 770))

# Finally, set these values to missing and check again:

cps.data <- mutate(cps.data, 
                   ind.recode = na_if(ind, 770))

# The code above says, create a new variable named ind.recode that is equal to 
# ind for all observations of ind EXCEPT those with ind == 770, which all get
# set equal to NA / missing

nrow(filter(cps.data, ind.recode == 770))


################################################################################
# R2 and Adding Explanatory Variables
################################################################################

# Let's return to the property crime ~ unemployment rate regression considered
# above. Here's our baseline regression: 

summary(lm(rate_property_crime ~ unemp_rate, working.data))

# Let's try adding state and year FEs - note that this substantively changes 
# the interpretation of the effect we're estimating!

summary(lm(rate_property_crime ~ unemp_rate +  
             as.factor(year) + as.factor(state_name), working.data))

# Now, let's add some extra explanatory variables - we can add non-linear 
# time variables here, then interact them with state: 

summary(lm(rate_property_crime ~ unemp_rate +  
             as.factor(year) + as.factor(state_name)
           + year^2:as.factor(state_name) +  year^3:as.factor(state_name), 
           working.data))

# Our R2 has gone up... but it's not clear if we've really improved our answer
# to our research question (likely not - these additional terms probably result
# in us "over fitting" the data and introduce noise in our estimates). 


