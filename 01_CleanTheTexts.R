#######   Textmining

####### https://rpubs.com/pjmurphy/265713


## Get your data
cname <- file.path("./data/", "texts")   
cname   
dir(cname)

## Get R packages for text mining
library(tm)

## Lets load texts to R
docs <- VCorpus(DirSource(cname))   
summary(docs)

## For details about documents in the corpus, use the inspect(docs) command.
inspect(docs[1])


# To write out the full text, use writeLines()
class(docs[1])
writeLines(as.character(docs[1]))


## Remove unwanted diacritics 

# ?removePunctuation()
# ?regexp says:
#   ‘[:punct:]’ Punctuation characters:
#   ‘! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { |
#           } ~’.

docs <- tm_map(docs,removePunctuation)   
writeLines(as.character(docs[1])) # Check to see if it worked.
# The 'writeLines()' function is commented out to save space.

for (j in seq(docs)) {
  docs[[j]] <- gsub( "â\200","-", docs[[j]])  # reinsert hyphen
  docs[[j]] <- gsub( "â\200\231","", docs[[j]]) # remove apostrophe
  docs[[j]] <- gsub("@"," ", docs[[j]])
  docs[[j]] <- gsub("\\|", " ", docs[[j]])
  docs[[j]] <- gsub("\u2028", " ", docs[[j]]) 
  docs[[j]] <- gsub("/"," ", docs[[j]])
}

?gsub()

## Removing numbers:

docs <- tm_map(docs, removeNumbers)   
writeLines(as.character(docs[1])) # Check to see if it worked.

## Converting to lowercase:
#A s before, we want a word to appear exactly the same every time it appears. We therefore change everything to lowercase.

docs <- tm_map(docs, tolower)   
docs <- tm_map(docs, PlainTextDocument)
DocsCopy <- docs
# writeLines(as.character(docs[1])) # Check to see if it worked.

# Removing “stopwords” (common words) that usually have no analytic value.
#  In every text, there are a lot of common, and uninteresting words (a, and, also, the, etc.). Such words are frequent by their nature, and will confound your analysis if they remain in the text.


# For a list of the stopwords, see:   
length(stopwords("english"))   
stopwords("english")   
stopwords("french")

docs <- tm_map(docs, removeWords, stopwords("english"))   
docs <- tm_map(docs, PlainTextDocument)
writeLines(as.character(docs[1])) # Check to see if it worked.


## Removing particular words:
#   If you find that a particular word or two appear in the output, but are not of value to your particular analysis. You can remove them, specifically, from the text.

docs <- tm_map(docs, removeWords, c("syllogism", "tautology", "im"))   
# Just remove the words "syllogism" and "tautology" and "im". 
# These words don't actually exist in these texts. But this is how you would remove them if they had.


## Combining words that should stay together

# If you wish to preserve a concept is only apparent as a collection of two or more words, then you can combine them or reduce them to a meaningful acronym before you begin the analysis. Here, I am using examples that are particular to qualitative data analysis.

for (j in seq(docs))
{
  docs[[j]] <- gsub("fake news", "fake_news", docs[[j]])
  docs[[j]] <- gsub("inner city", "inner-city", docs[[j]])
  docs[[j]] <- gsub("politically correct", "politically_correct", docs[[j]])
}
docs <- tm_map(docs, PlainTextDocument)


## Removing common word endings (e.g., “ing”, “es”, “s”)

# This is referred to as “stemming” documents. We stem the documents so that 
# a word will be recognizable to the computer, despite whether or not it may have 
#a variety of possible endings in the original text.
# 
# Note: The “stem completion” function is currently problemmatic, and stemmed words are 
# often annoying to read. For now, I have this section commented out. But you are welcome 
# to try these functions (by removing the hashtag from the beginning of the line) if they interest you. 
#Just don’t expect them to operate smoothly.
# 
# This procedure has been a little hanky in the recent past, so I change the name of the data object when I do this to keep from overwriting what I have done to this point.

## Note: I did not run this section of code for this particular example.
# docs_st <- tm_map(docs, stemDocument)   
# docs_st <- tm_map(docs_st, PlainTextDocument)
# writeLines(as.character(docs_st[1])) # Check to see if it worked.
# docs <- docs_st


## Then add common endings to improve intrepretability.

# This appears not to be working right now. You are welcome to try it, but there are numerous reports of 
#   the stemCompletion function not being currently operational.
# Note: This code was not run for this particular example either.
#   Read it as a potential how-to.
# docs_stc <- tm_map(docs_st, stemCompletion, dictionary = DocsCopy, lazy=TRUE)
# docs_stc <- tm_map(docs_stc, PlainTextDocument)
# writeLines(as.character(docs_stc[1])) # Check to see if it worked.
# docs <- docs_stc

#If the stemming and/or stem completion worked, then convert the corpus beck to “docs” using ‘docs <- docs_st’ or ‘docs <- docs_stc’.

# Stripping unnecesary whitespace from your documents:
#   The above preprocessing will leave the documents with a lot of “white space”. White space is the result of all the left over spaces that were not removed along with the words that were deleted. The white space can, and should, be removed.

docs <- tm_map(docs, stripWhitespace)

# writeLines(as.character(docs[1])) # Check to see if it worked.


### To Finish
# Be sure to use the following script once you have completed preprocessing.
# This tells R to treat your preprocessed documents as text documents.

docs <- tm_map(docs, PlainTextDocument)

### This is the end of the preprocessing stage.



