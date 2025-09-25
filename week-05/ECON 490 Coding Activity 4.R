################################################################################
# ECON 490 Coding Activity 4: Graphing with ggplot2
################################################################################

# In this activity, we'll review the following: 

#   - Functions and interacting with files and folders (covered via Swirl)
#   - Using ggplot2 to create graphs
#   - Working with ChatGPT to improve R code

# When you're finished with the questions below, save a copy of your code with
# your name included in the file name and then upload this file to the Canvas
# page for this assignment.



################################################################################
# Loading Required Packages
################################################################################

# Like the previous activities, we'll start by loading the tidyverse package: 

library(tidyverse) 

# In addition to the tidyverse package, we'll also use the ggplot2 package to 
# create graphs. The ggplot2 package should be automatically installed when you 
# installed tidyverse, so you should already have it on your computer. However, 
# we'll need to load it separately each time we want to use it: 

library(ggplot2)



################################################################################
# Swirl Lessons
################################################################################

# Let's start by continuing with several quick lessons from Swirl R. To get
# started with the Swirl lessons for this week, run the following lines:

library(swirl)

swirl()

# After entering your name, select the "R Programming" course. Before completing
# the questions below, you should complete the following lessons: 

#   2) Workspace and Files
#   9) Functions

# As with Coding Activity 1 and 2, you don't need to save or submit anything
# from the Swirl activities on Canvas.



################################################################################
#
# Coding Activity Questions
#
################################################################################

# Once you've completed the Swirl lessons above, you can complete the questions 
# included below. Each question is included as a comment, with space left below 
# for you to write out your answers as code. When you're done, save this file, 
# and upload it to Canvas.



################################################################################
# Question 1: Swirl Review Questions
################################################################################

# Let's start by reviewing several key functions used to interact with files 
# and folders on your computer. We can access the current working directory 
# using the getwd() function: 

getwd()

# To see a list of what files are available in your working directory, we can 
# use the list.files() function: 

list.files()

# In the space provided below, use the setwd() function below to set your
# working directory to the folder where you've saved the R code for this
# activity.





# For larger data analysis projects, including the capstone project for this
# class, its helpful to have a single folder where you store the data sets 
# you're using for your analysis. 

# In the space provided below, do the following:

#   - Use the dir.create() function to create a new folder named "data-sets" 
#   - Set your working directory to this new folder 
#   - Check the contents of this folder using list.files() - note that this 
#       folder should be empty because you just created it





# NOTE: I don't have any questions here about the Swirl lesson on Programming - 
# this isn't because it's not important! However, the main takeaway from that  
# lesson is to give you a general sense of what's going "underneath the hood"
# when you use functions in R. For these coding activities and your capstone 
# analysis (in most cases), you won't need to write your own functions. 



################################################################################
#
# Loading our State-Level Data Set 
#
################################################################################

# For the remaining questions, we'll explore one of the primary data sets for 
# the capstone project - the state-by-year ACS data set. This data set and 
# documentation is available on the Capstone Data Resources Canvas page. I've 
# also posted the file on the Canvas Page for this coding assignment. 

# To load the data set into R, we'll need to apply some of the tools we reviewed
# during the Swirl lessons. To get started, make sure that you've downloaded the
# .csv file posted to the Coding Activity 4 page (or Dropbox), named
# "state-by-year-ACS-data.csv". 

# Once you've saved this data set to your computer, enter the location where the
# file is saved on your computer in the setwd("") function below:

setwd("")

# We can check that the file is saved in your working directory using the 
# file.exists() function: 

file.exists("state-by-year-ACS-data.csv")

# After confirming that this data set is included in your working directory, you
# can load it into R using the read_csv() function:

state.data <- read_csv("state-by-year-ACS-data.csv") 

# The read_csv() function is from the tidyverse package - there's also tidyverse 
# functions to help you load data stored in other format (Excel, tabular, etc.). 

# Let's take a look at what variables are available in this data set: 

names(state.data)

# You can find a list of the variables included with this data set, and their
# coding + definitions, in the documentation PDF for this data set on the Canvas
# page for this assignment.




################################################################################
# Question 2: Grouping with the %>% Operator
################################################################################

# Let's get some additional practice working with %>%. Our state.data has data
# for each state over a 5 year period (from 2018 to 2022). We can use the code
# below to calculate averages across this time period for each state: 

state.data.poverty.avg <- state.data %>% 
  group_by(state_name) %>% 
  summarize(avg.poverty_rate = mean(poverty_rate))

# Let's see what our new state.data.poverty.avg data set looks like: 

str(state.data.poverty.avg)

# Our state.data.poverty.avg object has 51 rows, corresponding to each of the 50
# states in addition to DC, and 2 columns. The first column is state_name, which
# identifies each row of our new data set and avg.poverty_rate, which is the 
# average of the poverty_rate variable, calculated separately for each state. 



# In the space provided below, use %>% and group_by() to calculate the average
# of the labor_force_participation_rate and incwage variables. As part of your
# code, use the filter() function to remove the District of Columbia. Save your
# output as state.data.emp.avg.







# In the space provided below, calculate the annual average of the employment
# variables from above - labor_force_participation_rate and incwage - averaged
# across all states in each year. Now, instead of grouping over states, we want
# to group by year. Save your output as emp.over.time.

# NOTE: This new object should have 5 rows corresponding to each of the 5 years 
# between 2018 to 2022. You do not need to remove DC. 





################################################################################
# Question 3: Graphing Single Variables with ggplot2
################################################################################

# The ggplot2 package let's you create a wide variety of graphs. To get a sense
# of how ggplot2 works, let's take a look at a simple example. Suppose we want
# to show the distribution of poverty rates across states. 

# To do this, we'll want to create a histogram using the state.data.poverty.avg
# data set we created above: 

ggplot(state.data.poverty.avg, aes(x = avg.poverty_rate)) + 
  geom_histogram() 

# Our histogram should appear in the "Plots" window of RStudio. Let's take a 
# look at the structure of the code above - the first line uses the ggplot() 
# function to tell R: 

#   - What data we're working with (the first argument inside the parentheses)
#   - What we want to plot (the second argument in parentheses, inside the 
#       aes() function)

# What happens if we only included that first line? Let's see: 

ggplot(state.data.poverty.avg, aes(x = avg.poverty_rate))

# Check the "Plots" window again - we get a blank graph, with average poverty
# rates on the X axis. This first line just "sets the stage" by telling R what
# data we want to plot.

# To actually draw a specific graph, we need to use the "+" and include the 
# second line from the code above. 

ggplot(state.data.poverty.avg, aes(x = avg.poverty_rate)) + 
  geom_histogram() 

# Now we're back to our original histogram from above - in the second line, 
# the geom_histogram() tells R that we want to draw a histogram. We can use
# the "+" operator to specify additional options to customize our graph: 

ggplot(state.data.poverty.avg, aes(x = avg.poverty_rate)) + 
  geom_histogram(color = "black", fill = "grey") + 
  labs(title = "Histogram of Poverty Rates Across US States (2018-2022)", 
       y = "Frequency", 
       x = "Poverty Rate")

# In the space provided below, use the state.data.emp.avg data set you defined
# above to create a histogram of your average incwage variable, including the
# following options:

#   - An updated title for your graph
#   - An updated label for your x-axis





################################################################################
# Question 4: Using ChatGPT to Improve Graphs (Pt. 1)
################################################################################

# One of the most useful applications of ChatGPT when using R is helping with
# graphing - ggplot2 has lots of options for customizing graphs, and remembering
# all of them can be tricky! Let's get ChatGPT's help with improving the 
# histogram you drew above using incwage.

# Open a new ChatGPT session, and tell it that you are using R + tidyverse +
# ggplot2 to draw a histogram. Ask it for help doing the following:

#   - Adding a footnote at the bottom of your graph indicating your data source
#       (here, the source is "American Community Survey (1-Year Files))

#   - Adding a vertical line to indicate the average value of your X-variable

# As part of your prompt, you can provide your ggplot2 code above - ChatGPT will
# give you updated code with the elements above added. 



# In the space provided below, combined your original code from Q3 above with
# the code that ChatGPT provided you. Use this code to create an updated version
# of your histogram from Q3.





# In the space provided below, assess the quality of ChatGPT's response. Did 
# the code run correctly? Is there anything that doesn't look right? 





# ChatGPT works best when used iteratively - you give it a prompt, it gives you 
# some code, then you adjust with a new prompt (or modify the code it gives you 
# in R). In the space provided below, make any changes you think are necessary
# to your new graph (either adjusting things manually or using ChatGPT again). 
# If your graph looks good already, just say so!





################################################################################
# Question 5: Graphing the Relationship between Multiple Variables 
################################################################################

# In Q3, we plotted the distribution of a single variable. We might also want 
# to create graphs showing the relationship between two variables. Here's a list
# of common graph types and their corresponding ggplot() functions: 

#   - Scatter plots: use geom_point()
#   - Line plots: use geom_line()
#   - Fitted lines within a plot: use geom_smooth()

# Like we mentioned above, ChatGPT is helpful when graphing things. If you don't
# know the specific function to use for a given draft, you can tell ChatGPT the
# kind of graph you'd like to draw (and even provide the data you're using) and
# it can provide you with the appropriate ggplot2 functions.

# You can also find other commonly-used functions and examples of graphs at the 
# following URL: 

# http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html#google_vignette

# Let's work through an example of graphing two variables using ggplot2. Run the
# following code, then take a look at the output in the "Plots" window:

ggplot(state.data, aes(x = hhincome, y = food_stamp_recipiency))

# Now we've set up the plot with household income and food stamp recipiency
# rates as our axes. We can use the geom_point() function listed above to draw a
# scatter plot of these two variables:

ggplot(state.data, aes(x = hhincome, y = food_stamp_recipiency)) + 
  geom_point()



# In the space provided below, use the state.data.emp.avg you created above to
# draw a scatter plot the average values of incwage (on the X-axis) and labor
# force participation (on the Y-axis). Make sure to include a title and clear
# axis labels.





################################################################################
# Question 6: Including Qualitative Information in Scatter Plots
################################################################################

# Suppose we're interested in the relationship between wage income and poverty 
# rates for states on the West Coast. We can start by subsetting our data and 
# drawing the following scatter plot: 

west.coast.data <- filter(state.data, 
                          state_name == "california" | 
                            state_name == "oregon"   | 
                            state_name == "washington")

ggplot(west.coast.data, aes(x = incwage, y = poverty_rate)) + 
  geom_point()

# Each point on the graph above represents a particular state + year. But its 
# not clear which point corresponds to which state. We can identify states
# using the color() option inside the aes() function like so: 

ggplot(west.coast.data, 
       aes(x = incwage, y = poverty_rate, color = state_name)) + 
  geom_point()

# Now we can identify the state corresponding to each point. Our graph could 
# use a bit of cleaning up, however. 

# In the space provided below, copy and paste the graph code above, then 
# add a descriptive graph title and labels for your Y- and X-axes.





################################################################################
# Question 7: Using ChatGPT to Improve Graphs (Pt. 2)
################################################################################

# Let's use ChatGPT to add clean up the scatter plot you created in Q6 above. 
# Tell ChatGPT that you're using R + tidyverse + ggplot2 to create a graph, 
# then copy your R code and ask it to do the following: 

#   - Add a fitted line using lm() 
#   - Change the formatting of the Y-axis to be percentage values
#   - Change the formatting of the X-axis to be dollar values
#   - Change the title of the legend to be "State"

# In the space provided below, paste your code from Q6 and add in the code
# suggestions provided by ChatGPT as well. Make any necessary changes to ensure
# your code runs successfully.





################################################################################
# Question 8: Exporting Graphs
################################################################################

# We can save ggplots as objects that we display later: 

scatter.plot <- 
  ggplot(state.data, aes(x = hhincome, y = food_stamp_recipiency)) + 
  geom_point()

scatter.plot

# The ggsave() function saves the last ggplot we've displayed in the "Plots" 
# window. The dimensions of the picture file that is exported from the "Plots"
# window are specified in inches.  

ggsave("scatter-plot.png", width = 6, height = 4) 

# In the space provided below, use the state.data data set to create a scatter
# plot of hhincome and our HS graduation rate variable, and include a fitted
# line using the geom_smooth() function. Make sure to include a title and axis
# labels for your graph. Export this graph as a .png file using the ggsave()
# function.





################################################################################
# End of Activity
################################################################################

# Once you've included responses to each of the questions above, save this file
# with your name included in the file name, and upload your code to Canvas. 

# Make sure that you upload your .R code file (and NOT another file e.g.,
# something HTML formatted). Remember that you don't need to submit anything for
# the swirl lessons.



