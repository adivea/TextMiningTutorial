######### 2019 Staging data

######## Stage the Data

# To proceed, create a document term matrix.
# This is what you will be using from this point on.

dtm <- DocumentTermMatrix(docs)   
dtm   

# To inspect, you can use: inspect(dtm)
# This will, however, fill up your terminal quickly. So you may prefer to view a subset:
#   inspect(dtm[1:5, 1:20]) view first 5 docs & first 20 terms - modify as you like
# dim(dtm) This will display the number of documents & terms (in that order)
# 
# You’ll also need a transpose of this matrix. Create it using:

tdm <- TermDocumentMatrix(docs)   
tdm 


########### Explore the data

freq <- colSums(as.matrix(dtm))   
length(freq)   

ord <- order(freq)

# If you prefer to export the matrix to Excel:
  
m <- as.matrix(dtm)   
dim(m)   
write.csv(m, file="DocumentTermMatrix.csv")   


########### Focus

dtms <- removeSparseTerms(dtm, 0.2) # This makes a matrix that is 20% empty space, maximum.   
dtms


########### Word Frequency
# There are a lot of terms, so for now, just check out some of the most and least frequently occurring words.

freq <- colSums(as.matrix(dtm))
#Check out the frequency of frequencies.
#The ‘colSums()’ function generates a table reporting how often each word frequency occurs.
# Using the ’head()" function, below, we can see the distribution of the least-frequently used words.

head(table(freq), 20) # The ", 20" indicates that we only want the first 20 frequencies. 
# Feel free to change that number.
# The resulting output is two rows of numbers. The top number is the frequency with which words appear and the bottom number reflects how many words appear that frequently. Here, considering only the 20 lowest word frequencies, we can see that 1602 terms appear only once. 
# There are also a lot of others that appear very infrequently.

tail(table(freq), 20)
# Most frequent words: frequency of 140 is achieved by 1 word

### See the frequent words
freq <- colSums(as.matrix(dtms))   
freq   # unsorted alphabetical results

# sort them by frequency
freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)   
head(freq, 14)  


# An alternate view of term frequency:
#   This will identify all terms that appear frequently (in this case, 50 or more times).

findFreqTerms(dtm, lowfreq=100)   # Change "50" to whatever is most appropriate for your text data.


# Yet another way to do this, especially if you need visualisation in a chart/graph.
  
wf <- data.frame(word=names(freq), freq=freq)   
head(wf)  


######### Plot Word Frequencies
# Plot words that appear at least 50 times.

library(ggplot2)
p <- ggplot(subset(wf, freq>50), aes(x = reorder(word, -freq), y = freq)) +
  geom_bar(stat = "identity") + 
  theme(axis.text.x=element_text(angle=45, hjust=1))
p   



########## Plot Word Clouds!
## install.packages(ggwordcloud) not on CRAN yet
library(RColorBrewer)
library(wordcloud)
library(ggwordcloud)
?wordcloud()

set.seed(142) # should retain the same layout   
wordcloud(names(freq), freq, min.freq=100)   

# Plot the 50 most frequently occurring words with six color scales.
set.seed(142)   
wordcloud(names(freq), freq, min.freq=50, scale=c(5, .1), colors=brewer.pal(6, "Dark2"))   

# Plot the 100 most frequently occurring words with six color scale and 20% words rotated 90degrees
set.seed(142)   
dark2 <- brewer.pal(6, "Dark2")   
wordcloud(names(freq), freq, max.words=100, rot.per=0.5, colors=dark2)   
