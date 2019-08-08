# Recommender system using collaborative filtering

## Introduction
The Internet has enabled the retailers of books, movies, electronics, etc. to disseminate information about their products at a low cost. Nowadays, Customers could easily find themselves lost in the sea of information. Recommendation systems, which automatically takes in an process the user-generated data, can guide users by exposing interesting and unknown items products to them[1]. The BookCrossing dataset contains information about users, books and user's ratings from the BookCrossing online community. 

The goal of this project is to build different recommendation systems using collaborative filtering on BookCrossing data, and evaluate and compare their performances. Since in this dataset, infromation about books is more complete and accesible than that of people, the main focus is on item-based collaborative filtering. 

## Methods

Item-based collaborative filtering is based on the idea that similar items to item A, which is rated by a user B, should also be recommended to this user B. In order to build such a recommendation system, we need to group books that are similar to each other. One important feature of this dataset is that, the interaction between books and users is very sparse. There are many books and users, but only a small proportion of the books are rated and not many users have rating history. For item-based RC, we are more concerned with the books so we only use the books which were rated more than 50 times to build the RC. For the users who have not rated any books, we either recommend random books or the most popular books to them. 

The K-Nearest Neighbor algorithm is naturely a good fit for this task. KNN can calculate the distances between points in the data set. This distance is a proxy for the similarity between items. The smaller the distance, the more similar the two items are. For one book, KNN can find the books that are considered the nearest neighbors, and make recommendations accordingly. 

We can also use correlation coefficient to represent similarity. Since there are only a few features for books to begin with, we consider the users' ratings on the books as additional features. Each user in this case is a feature and his or her rating on a book is the feature's value. We encounter the curse of dimensionality when trying to process this big matrix. There are about 40,000 rows representing books in the matrix, with thousands of columns. It takes a lot of time and computing power to find the correlation coefficient of each book pair. Therefore, we apply a matrix decomposicion technique to this data to lower the number of columns. After we get a much smaller matrix, we can go ahead and calculate the pairwise correlation coefficient of the rows(books). For a given book, we recommend a list of books that strongly correlate to it. 


## Results

## Discussion

## Related Work

## References:
1. Recommendation Systems in Software Engineering



1)
http://www.ituring.com.cn/article/497300


2)
https://blog.csdn.net/weixin_42608414/article/details/87712114

3)
https://github.com/ashwanidv100/Recommendation-System---Book-Crossing-Dataset/blob/master/Books_Recommendation_System.ipynb

4)
https://www.jianshu.com/p/32d7a2d993a8

5)
https://www.cnblogs.com/porco/p/4421511.html


