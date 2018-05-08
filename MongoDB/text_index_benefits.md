Text Indexes: Benefits
What More Can Text Indexes Do?

We have come a long way in this article learning about text indexes. There are many other concepts that you can experiment with text indexes. But owing to the scope of this article, we will not be able to discuss them in detail today. Nevertheless, let’s have a brief look at what these functionalities are:

    Text indexes provide multi-language support, allowing you to search in different languages using the $language operator. MongoDB currently supports around 15 languages, including French, German, Russian, etc.
    Text indexes can be used in aggregation pipeline queries. The match stage in an aggregate search can specify the use of a full-text search query.
    You can use your regular operators for projections, filters, limits, sorts, etc., while working with text indexes.

MongoDB Text Indexing vs. External Search Databases

Keeping in mind the fact that MongoDB full-text search is not a complete replacement for traditional search engine databases used with MongoDB, using the native MongoDB functionality is recommended for the following reasons:

    As per a recent talk at MongoDB, the current scope of text search works perfectly fine for a majority of applications (around 80%) that are built using MongoDB today.
    Building the search capabilities of your application within the same application database reduces the architectural complexity of the application.
    MongoDB text search works in real time, without any lags or batch updates. The moment you insert or update a document, the text index entries are updated.
    Text search being integrated into the db kernel functionalities of MongoDB, it is totally consistent and works well even with sharding and replication.
    It integrates perfectly with your existing Mongo features such as filters, aggregation, updates, etc.    

Text Indexes: Drawbacks

Full-text search being a relatively new feature in MongoDB, there are certain functionalities which it currently lacks. I would divide them into three categories. Let’s have a look.
Functionalities Missing From Text Search

    Text Indexes currently do not have the capability to support pluggable interfaces like pluggable stemmers, stop words, etc.
    They do not currently support features like searching based on synonyms, similar words, etc.
    They do not store term positions, i.e. the number of words by which the two keywords are separated.
    You cannot specify the sort order for a sort expression from a text index.

Restrictions in Existing Functionalities

    A compound text index cannot include any other type of index, like multi-key indexes or geo-spatial indexes. Additionally, if your compound text index includes any index keys before the text index key, all the queries must specify the equality operators for the preceding keys.
    There are some query-specific limitations. For example, a query can specify only a single $text expression, you can’t use $text with $nor, you can’t use the hint() command with $text, using $text with $or needs all the clauses in your $or expression to be indexed, etc.

Advertisement
Performance Downsides

    Text indexes create an overhead while inserting new documents. This in turn hits the insertion throughput.
    Some queries like phrase searches can be relatively slow.

Wrapping Up 

Full-text search has always been one of the most demanded features of MongoDB. In this article, we started with an introduction to what full-text search is, before moving on to the basics of creating text indexes. 

We then explored compound indexing, wildcard indexing, phrase searches and negation searches. Further, we explored some important concepts like analyzing text indexes, weighted search, and logically partitioning your indexes. We can expect some major updates to this functionality in the upcoming releases of MongoDB. 

I recommend that you give text-search a try and share your thoughts. If you have already implemented it in your application, kindly share your experience here. Finally, feel free to post your questions, thoughts and suggestions on this article in the comment section.  
