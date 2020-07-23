# KDDCup2015
R code snippets for analysis for KDD Cup 2015. 

Analytic competitions, such those hosted by Kaggle, provide opportunities to test and compare different algorithms for building predictive models.  In 2015, I participated in the <a href="http://kddcup2015.com/information.html" a> 2015 KDD Cup </a>  with <a href="https://www.linkedin.com/in/jianjun-xie-a34a073" a> a colleague </a> at CoreLogic.

The KDD Cup is a competition associated with the annual Knowledge Discovery and Data Mining conference.  The topic of the 2015 KDD Cup was predicting dropouts in Massive Open Online Courses (MOOC).  Dropout rates in MOOCs are very high, and <a href="http://wrap.warwick.ac.uk/65543/" a>numerous research papers </a>  have investigated <a href="http://www.editlib.org/p/147656/" a>reasons for this behavior</a>.  

Data were provided from XuetangX, a Chinese MOOC learning platform.  The outcome metric was course dropout during the next 10 days.  Information was provided about the course and student activity over time.  Student information included a record over time of participation in various aspects of the course (discussion forum, quiz etc).  A student ID was provided and could be used to link records for a given student across courses.  This could be used to calculate metrics such as student-level completion rates across courses as model inputs.

The analytic team at CoreLogic had previously used the Kaggle <a href="https://www.kaggle.com/c/bike-sharing-demand" a> bike sharing demand competition </a> as a team-building exercise.   In that exercise, I had taken the approach of segmenting the data (by casual vs registered bike user, workday vs non workday, and season) and then estimating a negative binomial regression for each segment (<a href="https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/glm.nb.html" a>using the glm.nb function</a> in R).  My colleague used a generalized boosted regression in his approach.  Blending our models to predict bike demand provided superior results than either of the individual approaches.

Given our favorable results in the bike sharing contest, we decided to take a similar approach in the KDD Cup 2015 contest.  My colleague once again used GBM to estimate his models.  My approach was to segment the data, and use logistic regression to estimate the dropout probability.  I segmented the data by course, which removed any course-level effects in the estimation process (i.e. there was no course level variation within a regression dataset).  An additional important factor was the amount of times a student logged on to the course site.  A significant number of students logged on to the course only one time.  These students exhibited a significantly higher dropout rate than students who logged on to the course multiple times.  It was also possible to generate additional explanatory variables (features) for students with multiple logons (e.g. time between log ons, number of log ons by type of log on). For this reason, I also segmented the data by multiple vs single log on.

I used the <a href="https://cran.r-project.org/web/packages/glmnet/index.html" a> glmnet package in R </a> to estimate a logistic regression with a penalty function.  The glmnet function can be used to estimate Lasso regression, ridge regression, as well as a combination of the two.  My intention in using glmnet was to use Lasso, or a function of Lasso, for variable reduction.

I've uploaded the R code for estimating glmnet <a href="https://github.com/SomeThingsConsidered/KDDCup2015/blob/master/glmnet_KDDCup2015.R" a> here. </a>  I did some pre-procesing of the data using SAS, so the R code highlights the use of glmnet, rather than being complete code that reads in the raw data and creates features.

There are several points to highlight from the code: 


- I selected area under the curve (AUC) to evaluate the model performance. glmnet allows you to choose from several different evaluation metrics.  The competition used AUC as the evaluation metric, so I was able to select the same metric to evaluate my models as was used to judge the competition results.

- I used K folds cross validation to evaluate the model performance.  K folds cross validation divides the data into K datasets, estimates the model on K-1 data, validates on the Kth data, repeats for each grouping, and takes the average of the validation results. The package uses the cross validation results to select the best parameter for the penalty term in the function.
 
- I used a combination of lasso and ridge regression (alpha of 0.5).  I had also tried alpha =1 (lasso) and alpha =0 (ridge), but 0.5 provided the best CV results.  My understanding is that the <a href="https://cran.r-project.org/web/packages/c060/c060.pdf" a> c060 package </a> can perform alpha tunig, but I did not have time to investigate. 

- K folds cross validation results can vary across draws of the data, especially for small datasets.  For this reason, the process was repeated 50 times, and the median result was selected. 

Overall, this approach resulted in AUC metrics that were 0.01 - 0.02 below my colleague's approach of using GBM.  Given the AUC differences, combining the model approaches did not improve results relative to using GBM alone.  My guess is that glmnet did not perform as well as GBM because non-linearities and variable interactions need to be specified as model input variables, rather than allowing the algorithm to find nonlinearities and/or interactions.

Overall, the competition was a fun and useful exercise. I'm interested in learning more about using Lasso in the presence of collinearity of the features (explantory variables).  When I tried using all of the features as inputs to the glmnet equation, the results were worse than when I selected a subset, removing highly correlated variables. If Lasso can be used as a method of variable selection, it would be interesting to learn how much preprocessing of the data is required.  



