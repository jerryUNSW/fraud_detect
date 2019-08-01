# Insurance fraud detection

### 3. Material and methods
#### 3.1 Data Description
The log data provided by the insurance company has 2 components, the message and the time stamp. Each piece of data has an activity type, including but not limited to: "Quote Started", "Payment Completed", "Claim Started", "Claim Accepted" and "Claim Denied". In reality a customer's claim could be denied for many reasons, but in this dataset "Claim Denied" are precisely the cases that are identified as frauds.

The data is in the log form and therefore should go through data cleaning, data transformation and data curation processes to be in tabular form, on which we build a classifer of fraudulant activities. Challenges encountered with this data include:

* Not all data are relevant. We split the original data according to the activity type. "Quote Completed", "Claim Started", "Claim Accepted" and "Claim Denied" are the most important ones and are examined individually.

* There are several different delimer seperating fields in each piece of data. For example, the case ID, platform and activity type are separated by "-", whereas the time stamp and the rest of the information is separated by ",".

* Due to confidentiality concerns, the insurance company's clients' information are transfromed and substituted by pseudo names. No meaningful conclusion can be drawn from these names and addresses directly, but the distribution of these data are kept intact. 

* One customer ID could correspond to different payload, in which they submit different information about their households and homes. One customer ID could also submit multiple claims and there is no given link between a "Claim Started" and "Claim Denied" or "Claim Accepted" cases. We will process the data on the assumption that each "Claim Started" case corresponds to the most recent submitted payload from "Quote Completed". The customers with more than one payload and those who submitted more than one claims only constitute a small proportion of all data.

We split the dataset by activity types and label each incoming case. The incoming cases are sorted according to their time stamps. Each incoming case has features attached to it, which are used to predict the label. Other than "platform" (the platform the claimer used), the majority of the features are extracted from the "Quote Completed" data, where the customers submitted Json payload describing their demographic and household information.

We extracted an important feature not in the original data, which is "matched_time_stamp". From our observations, many claims were started right after the customer made the payment, mostly the fraudulent ones. The time stamps are exactly the same. "matched_time_stamp" simply checks if there is a "Payment Completed" activity associated with the same customer ID, at the exact same time a "Claim Started" activity happened. Our analysis validates that all of the frauds have this feature equalling "True", but not the other way around. There are still some cases with matched time stamps but are not labelled as "Fraud".

#### 3.2 Assumptions

1. One customer ID can onl represent one customer in real life. In the dataset, one customer ID could correspond to a lot of activities. One customer ID could even have different Json payloads (with claimer's name, age, gender and other basic information). In reality, most companies would not reuse its customer IDs as this creates unnecessary anomolies and inconsistencies. Therefore, in our analysis, each customer ID is treated as an individual customer.
2. For the majority of the customers, their identities do not change over time.We assume that most normal customers would never start any fraudulent activities, at least not under the same customer ID. We also assume that most frauds would not turn from their wrongdoings and start making legitimate claims, at least not under the same ID. This assumption can be validated through the following analysis:

As shown in the pie chart below, there exist only a few customers whose claims got denied and accepted at different times. These people only make up a small proportion of the population. For the rest of the customers, their claims either always got denied or always got accepted.

// there should be a pie chart here

Based on assumption 2, it is advisable to take a customer's claim history into account. If an existing customer makes a new claim, the claim history tells us a lot about whether the incoming claim is fraud or not. We define an additional feature for each incoming claim case, "number of denials". For each claim case along with a time stamp, this feature shows how many times a customer's claims got denied by that time stamp. For example, if a person got denied 5 times (although this is unlikely in the dataset), the "number of denials" for the 5 incoming cases should be 0,1,2,3,4, indicating how many times the person were denied already.
#### 3.3 Methods

A classification model is appropriate for this dataset since the incoming cases have 2 labels, fraud or normal. Based on the original features and 2 extracted ones, classifiers are built to predicts the label of incoming claims. An approach widely adpoted is to split the data into training, testing and validation sets. The training set is used to build the classifier and the validation set will evaluate the performance of the model. Looking at performance metrics of the classifier on the validation set can help identify the most relevant features and combination of parameters of the classifier. After obtaining the most important features and the optimal combination of parameters, a final model is built on training and validation sets, and evaluated on the test set.

Often the testing set is set aside in advance, and cross validation technique is applied to the rest of the data. The remainder of data is split into K even shares. Each share is used as the validation set in each iteration. However this approach is not appropriate for this dataset and the reason is two-fold

1. Every case is time-stamped. Cross validation means at some point a classifier using data in the future is built to predict labels in the past. There could be some information leak from the future to the past that makes the classifier perform better than it should be. For example, if some feature is dependent on past labels, then the value of such features in the future already include the information about labels in the past, which is precisely the case with a extracted feature in our model, "number of denials".

2. Even if there is no risk of information leak when doing cross validation, we cannot make the assumption that time does not play a part in the pattern in which fraudulent activities occur. No prior knowledge or evidence is available to make such assumption.

### 4. Analyses and Results



useful references
https://www.sciencedirect.com/science/article/pii/S0020025511006773

