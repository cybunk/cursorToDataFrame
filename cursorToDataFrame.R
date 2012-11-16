#
# -R- Mongo Query to DataFrame
#	  author : Samuel Huron 

library("rmongodb") 
library("plyr")

last <- function(x) { return( x[length(x)] ) }

bsonToList <-function(key,v){
	val <- NULL
	for ( mykey in key){
		if (is.null(mongo.bson.value(v,mykey))){
			val <- cbind(val,NA)
		} else {
			if(mykey=="_id"){
				val <- cbind(val,as.character(mongo.bson.value(v,mykey)))
			}else{
				val <- cbind(val,mongo.bson.value(v,mykey))
			}
		}
	}
	return(val)
}

cursor2DataFrame <-function(cursor){
	d.key  	<- NULL
	c       <- NULL
	DF 		<- NULL
	i 		<- 1

	while (mongo.cursor.next(cursor)) {	
		if(i==1){
			iter  <- mongo.bson.iterator.create(mongo.cursor.value(cursor))
			while (mongo.bson.iterator.next(iter)){
				if(mongo.bson.iterator.type(iter)!=3){
						d.key <- cbind(d.key,mongo.bson.iterator.key(iter)) 
				}else{
					iter2  <- mongo.bson.iterator.create(iter)
					rootkey<- mongo.bson.iterator.key(iter)
					while (mongo.bson.iterator.next(iter2)){
						d.key <-  cbind(d.key,paste(rootkey,mongo.bson.iterator.key(iter2),sep="."))
					}
				}
			}
		}
		i 	  <- i+1
		v 	  <- mongo.cursor.value(cursor)
		d.val <- bsonToList(d.key,v)
		c 	  <- rbind(c,c(d.val))
	}

	DF <- as.data.frame(c)
	colnames(DF)<-d.key
	return(DF)
}