import sklearn
from sklearn import preprocessing
from sklearn import metrics
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn import svm


import pandas as pd

Dataframe = pd.read_csv('/Users/zareerz/Downloads/loan_train.csv')


# STEP ONE: PREPROCESSING
# First lets clean the data and preprocess the data

Dataframe.dropna(axis=0, inplace=True)


# Here is the X
X = Dataframe[['Principal', 'terms', 'effective_date', 'due_date', 'age', 'education', 'Gender']]

# Here is the Y
Y = Dataframe[['loan_status']]

# Lets change up the dates and convert them to specific values for the models.
for i in range(len(X['due_date'])):
    X.loc[i, 'due_date'] = pd.to_datetime(X.loc[i , 'due_date'] , format="%m/%d/%Y").value

for i in range(len(X['effective_date'])):
    X.loc[i, 'effective_date'] = pd.to_datetime(X.loc[i , 'effective_date'] , format="%m/%d/%Y").value



# Sklearn won't able to identify the string data so we will use the labelencode to subsitute the text as dummy values


# Lets  convert the education data.
X = pd.concat([X, pd.get_dummies(Dataframe['education'])], axis = 1)
X.drop(labels=['education', 'Master or Above'], axis=1, inplace=True)

# Lets convert the Gender data where it is only two kinds, male or female.
ls = preprocessing.LabelEncoder()
vals = ls.fit_transform(X.loc[:, 'Gender'])
for i in range(len(X['Gender'])):
    X.loc[i, 'Gender'] = vals[i]


# STEP 2: DETERMINE WHAT MODEL TO USE


# PART 1: KNN
# Lets first try out the KNN classifier

knn = KNeighborsClassifier(n_neighbors= 5)

# STEP THREE: Decide how to split data. We will use train test split
x_train, x_test, y_train, y_test  = train_test_split(X, Y, test_size=0.2, random_state=4)

# STEP FOUR: Train the data.
knn.fit(x_train, y_train.values.ravel())

# STEP FIVE: Predict the test data
predictions = knn.predict(x_test)
print(predictions)



#STEP SIX: Evaluate the model.

# Once again, since we are dealing with categorical values, sklearn won't be able to identify them. We will once again use
# the labelEncoder to convert the non numerical values.

# Converting the predicitions.
ls = preprocessing.LabelEncoder()
predictions = ls.fit_transform(predictions)
print(predictions)

# Converting the  true y values
ls = preprocessing.LabelEncoder()
trues = ls.fit_transform(y_test.loc[:, 'loan_status'])


# Lets see all of the metrics
r_sq = abs(metrics.r2_score(trues, predictions))
print(r_sq)
jac = metrics.jaccard_score(trues, predictions)
print(jac)
f1 = metrics.f1_score(trues, predictions)
print(f1)
ll = metrics.log_loss(trues, predictions)
print(ll)


