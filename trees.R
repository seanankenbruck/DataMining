# Decision Trees - Breast Cancer Data
# Read in the UCT Breast Cancer Data, create training and test
setwd('C:/Users/Sean Ankenbruck/Desktop/MSA/Fall2/DataMining/trees/')

options(digits=2)
load("breast_cancer.Rdata")
set.seed(7515)
perm=sample(1:699)
BC_randomOrder=BCdata[perm,]
train = BC_randomOrder[1:floor(0.75*699),] #training data
test = BC_randomOrder[(floor(0.75*699)+1):699,] #test data

# Build a default decision tree using entropy as the metric
# rpart package is the most popular for building trees
library("rpart")
tree = rpart(Target~.- Target, data=train, method='class',
             parms=list(split='entropy'))

# Plot the tree
.pardefault = par()
par(mai=c(.2,.2,.2,.2))
plot(tree,uniform=T) # uniform = T causes branches to be same length
text(tree)
#text(tree, use.n=T)
par(.pardefault)
# Tells us the most prevalent target class at each leaf
# Does not display the predicted probability of that outcome in that leaf

# It might be a good idea to examine variable importance to determine the best split
tree$variable.importance
# and create a bar plot to quickly show the differences
library(lattice)
barchart(tree$variable.importance[order(tree$variable.importance)],
         xlab='Importance', horiz=T, xlim=c(0,2000), ylab='Variable',
         main='Variable Importance', cex.names=0.8, las=2, col='orange')

# Computing Validation Misclassification
# predict() allows us to apply a model to a new set of data
# resulting output is a vector of predictions
tscores = predict(tree,type='class')
tscores
scores = predict(tree,test,type='class')
cat('Training Misclassification Rate:', sum(tscores!=train$Target)/nrow(train))
cat('Validation Misclassification Rate:', sum(scores!=test$Target)/nrow(test))

# Better visual tree
library("rattle") # Fancy tree plot
library("rpart.plot") # Enhanced tree plots
library("RColorBrewer") # Color selection for fancy tree plot
library("party") # Alternative decision tree algorithm
library("partykit") # Convert rpart object to BinaryTree
# fancyRpartPlot(tree) # Looks completely terrible but has
# # potential for smaller trees, fewer classes
#
# prp(tree)
# prp(tree, type =3, extra=100) # label branches, label nodes with % of obs
# prp(tree, type =3, extra=2) # label branches, label nodes with misclass rate
# prp(tree, type =3, extra=8) # label branches, label nodes with pred prob of class
# # BEWARE WITH BINARY TREES WHERE WE TYPICALLY WANT TO SHOW PROB OF SUCCESS/FAILURE
# # FOR EVERY NODE IN THE TREE!
prp(tree, type =0, extra=8, leaf.round=1, border.col=1,
        + box.col=brewer.pal(10,"Set3")[tree$frame$yval], )