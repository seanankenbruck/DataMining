# DataMining HW1 - Association Analysis #
setwd('C:/Users/Sean Ankenbruck/Desktop/MSA/DataMining/homework1/')
library(arules)

restaurant = read.transactions("restaurantData.csv", format = "single", sep = ",", cols=c(3,1),
                              rm.duplicates = FALSE, encoding="utf-8")
# Creates a sparse matrix (order by item on menu)
summary(restaurant)

# Examine the first 5 observations, obs1 are headers
inspect(restaurant[1:5])

# Visualize the frequency of items
itemFrequency(restaurant[, 1:3])

itemFrequencyPlot(restaurant, support=0.1)
itemFrequencyPlot(restaurant, topN=20)

# Visualization of the sparse matrix for the first hundred items
image(restaurant[2:100])

# apriori function learns association rules from the transaction data
apriori(restaurant)

# Set support and confidence levels to learn more rules
rules <- apriori(restaurant, parameter=list(support=0.1, confidence=0.25, minlen=2))
rules
summary(rules)

# Inspect first three rules
inspect(rules[1:17])
inspect(sort(rules, by="confidence")[1:17])

