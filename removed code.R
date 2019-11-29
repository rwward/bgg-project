#This model doesn't predict very well and has virtually all rows dropped due to NAs.
#Also includes some variables that shouldn't be used for prediction, such as 
#the number of people who own the game, have rated it, and have commented on it.
#Need a smaller model.
# big.bgg <- lm(stats.average ~ topic + details.maxplayers + details.maxplaytime + details.minage 
#    + details.minplaytime + details.age + details.playingtime + stats.averageweight
#    + stats.numcomments + stats.owned + stats.usersrated + polls.language_dependence
#    + polls.suggested_numplayers.1 + polls.suggested_numplayers.2 + polls.suggested_numplayers.3
#    + polls.suggested_numplayers.4 + polls.suggested_numplayers.5 + polls.suggested_numplayers.6
#    + polls.suggested_numplayers.7 + polls.suggested_numplayers.8 + polls.suggested_numplayers.9
#    + polls.suggested_numplayers.10 + polls.suggested_numplayers.Over, data = train)
# 
# #summary(big.bgg)
# 
# #summary(bgg.topics$polls.suggested_playerage)
# 
# rmse.bgg(big.bgg) #1.047704
# 
# #Using the simplified numplayers info produces much better results - although not better than dropping them
# big.bgg.simple <- lm(stats.average ~ topic + details.maxplayers + details.maxplaytime + details.minage 
#    + details.minplaytime + details.age + details.playingtime + stats.averageweight
#    + stats.numcomments + stats.owned + stats.usersrated + polls.language_dependence
#    + polls.suggested_numplayers_simple.1 + polls.suggested_numplayers_simple.2 + polls.suggested_numplayers_simple.3
#    + polls.suggested_numplayers_simple.4 + polls.suggested_numplayers_simple.5 + polls.suggested_numplayers_simple.6
#    + polls.suggested_numplayers_simple.7 + polls.suggested_numplayers_simple.8 + polls.suggested_numplayers_simple.9
#    + polls.suggested_numplayers_simple.10 + polls.suggested_numplayers_simple.Over, data = train)
# 
# #summary(big.bgg.simple) #back down to 10k missing
# rmse.bgg(big.bgg.simple) #0.7476771
# 
# #Still 12000 out of 20000 rows lost to missingness, but much better predictions. 
# lm.nonumplay <- lm(stats.average ~ topic + details.maxplayers + details.maxplaytime + details.minage 
#    + details.minplaytime + details.age + details.playingtime + stats.averageweight
#    + stats.numcomments + stats.owned + stats.usersrated + polls.language_dependence 
#    + polls.suggested_playerage, data = train)
# 
# #summary(lm.nonumplay)
# 
# rmse.bgg(lm.nonumplay) #0.7176241




#Bigger bart

bart_big <- bartMachine(X = as.data.frame(X_step_big), y = Y_step_big, mem_cache_for_speed = FALSE)

pred_bm_big <- predict(bart_big, new_data = as.data.frame(X_star_lasso_big))

sqrt(mean((Y_test_lasso_big - pred_bm_big) ^ 2, na.rm = T)) #0.6852956



This attempt to use caret to tune the random forest "how many variables to try" parameter took so long to run, even with a single run of 10-fold CV, that I have

```{r caret experiment}
# require(caret)
# require(randomForest)
# 
# ctrl <- trainControl(method = "cv")
# rf_random <- train(step_smaller_formula, data=train, method="rf", metric="RMSE", trControl=ctrl, na.action = "na.omit")
# 

```

#Takes too long to run.

# m_flam_cv <- flamCV(x = X_pre_nonum, y = Y_pre_nonum, n.fold = 5, n.lambda = 25)
# 
# pred_flam_cv <- predict(m_flam_cv$flam.out, new.x = X_star_lasso_small, 
#                         lambda = m_flam_cv$lambda.cv, alpha = m_flam_cv$alpha)
# 
# mse_flam_cv <- mean((col_test$Outstate - pred_flam_cv) ^ 2)

#GAM with slightly reduced model from step on best ols model

# library(mgcv)
# detach("package:mgcv")