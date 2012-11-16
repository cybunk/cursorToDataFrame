#
# -R- Mongo 
# author : Samuel Huron 

library("rmongodb") 
source("cursorToDataFrame.R")

mongo                   <- mongo.create()
ns.collectionName       <- "DbName.collectionName"

if (mongo.is.connected(mongo)){

	# Make my field selections
	buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "_id", 1L)
    mongo.bson.buffer.append(buf, "myField", 1L)
    fields <- mongo.bson.from.buffer(buf)

    # Make my query to the DB
    query  <- mongo.bson.empty()
    # Query the DB and get the result
	result <- mongo.find(mongo,ns.events,query,sort=mongo.bson.empty(),fields)
	# Transform it to data frame 
	DF 	   <- cursor2DataFrame(result)

	print(summary(DF))
    plot(DF)
}


