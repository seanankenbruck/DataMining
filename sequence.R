# Sequence Analysis - FaultCodes
setwd('C:/Users/Sean Ankenbruck/Desktop/MSA/Fall2/DataMining/sequence/')
# Load data
faults = load("FaultCodes.Rdata")

# use the seqecreate from the TraMineR package to create an event sequence object
# that serves as a starting place for mining.
install.packages('TraMineR')
library(TraMineR)

# From there, we have to subset the rules that we're interested in
FCseqdata = seqecreate(id=FC$vehicleID, timestamp=FC$sequence, event=FC$Code)
FCsubseqdata <- seqefsub(FCseqdata, pMinSupport=0.005)

# Finally, to get the same output that we receive from enterprise miner, 
# we have to use the undocumented function TraMineR:::seqerules
rules = TraMineR:::seqerules(FCsubseqdata)
head(rules)

# Values of support are simply the number of vehicles that exhibit that rule
# probably want to convert this to a probability / percentage
# can then order rules however, usually by lift
rules$Support = rules$Support/15075
# By Support
rules=rules[order(-rules$Support),]
# By Confidence
rules=rules[order(-rules$Conf),]
# By Lift
rules=rules[order(-rules$Lift),]
rules[1:10,]
