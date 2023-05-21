load fisheriris
X = meas(51:end,:);
y = strcmp('versicolor',species(51:end));
% perform LASSO on GLM (in this case logistic regression)
str_distribution='binomial';
str_link_function='logit';
num_fold_cross_validation=10;
%[B preds] = generic_lasso_glm_predict(X,y,'binomial','logit',10)

%%%%%%%%%%%%%%%%%%%%%%
%function [B preds] = generic_lasso_glm_predict(X,y,str_distribution,str_link_function,num_fold_cross_validation)

%str_distribution must be 'binomial' for logistic regression
%% call GLM LASSO
disp('Performing LASSO on logistic regression ..')
[B FitInfo] = lassoglm(X,y,str_distribution,'CV',num_fold_cross_validation)
%% plot cross validation results
lassoPlot(B,FitInfo,'PlotType','CV'); saveas(gcf,'lassoplot_1.eps', 'psc2')
lassoPlot(B,FitInfo,'PlotType','Lambda','XScale','log'); saveas(gcf,'lassoplot_2.eps', 'psc2') 
%% perform prediction
% get coefficients for Lambda value with minimum
% deviance plus one standard deviation point
%indx = FitInfo.Index1SE;
indx = FitInfo.IndexMinDeviance
B0 = B(:,indx);
disp('Number of non-zero predictors after LASSO')
nonzero_predictors = sum(B0 ~= 0)
% get constant intercept term
cnst = FitInfo.Intercept(indx);
B1 = [cnst;B0];
% perform predictions using this model
disp('Performing prediction ..')
preds = glmval(B1,X,str_link_function);
%keyboard
% save workspace variables
save(sprintf('lasso_logistic_output_%s.mat',date))
