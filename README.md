Digit Recognizer
===============

This project participates in kaggle competition. 

In the meanwhile, this project is also my SSC358 project.
 

This project would contain:

* DataSet: MINIST digit image data
* One proposal, due at ***April 4th***
* One final project report, due at ***May 2nd***
* Codebase for all involved algorithm 
See detailed information at ***http://www.kaggle.com/c/digit-recognizer***.

Introduction
---------------
Classify handwritten digits using the famous MNIST data

This competition is the first in a series of tutorial competitions designed to introduce people to Machine Learning.

The goal in this competition is to take an image of a handwritten single digit, and determine what that digit is.  As the competition progresses, we will release tutorials which explain different machine learning algorithms and help you to get started.


The data for this competition were taken from the MNIST dataset. The MNIST ("Modified National Institute of Standards and Technology") dataset is a classic within the Machine Learning community that has been extensively studied.  More detail about the dataset, including Machine Learning algorithms that have been tried on it and their levels of success, can be found at http://yann.lecun.com/exdb/mnist/index.html.


Progress #1 issued at March 29
---------------
We work out initial version of **Principle Component Analysis**(PCA), and submit it with KNN classification model. In this submission, we acquire an prediction accuracy of **0.96886** and ranked at **148** at that date.

We also tried Random Forest method based on PCA 100 pricipal components and achieve **0.95457** accuracy.

Progress #2 issued at April 14
---------------
C-SVM with preprocessed data by **Principle Component Analysis** (100
principal components). The prediction accuracy achieved is **0.91043**.

NU-SVM with the same configuration achieves accuracy **0.89743**.


Progress #2 issued at April 16
---------------
C-SVM with normalization preprocessing achieves **0.93571**.
NU-SVM with the same preprocessing achieves ****.
