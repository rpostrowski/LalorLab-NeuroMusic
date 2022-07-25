%% Run mTRFcrossval on each stimulus (STEP 3)
% This can be run one stimulus at a time, or a for loop could be written to
% account for the different number of rows (subjects) that listened to each
% stimulus. 

% Define your stimulus
stim = stimdata_perstim(1:rr,cc);
% rr = last row (subject) who listened to that stimulus
% cc = stimcode of stimulus of interest at a given moment 

% Define your response
resp = subjdata_perstim(1:rr,cc);
% rr = last row (subject) who listened to that stimulus
% cc = stimcode of stimulus of interest at a given moment 

% Run mTRFcrossval
[stats_stim_cc,t_stim_cc] = mTRFcrossval(stim,resp,fs,Dir,tmin,tmax,lambda,varargin); ...
% For our analysis, the values used for each variable are as follow:
% fs = 128
% Dir = -1 (backwards model) 
% tmin = 0 (msec)
% tmax = 300 (msec)
% lambda = 10.^(-4:2:8) --> range of values

lambda_vals = 10.^(-4:2:8);

% Find highest Pearson's correlation (Rmax) that was calculated among
% all calculated with the range of lambda_vals and find out which index (I,
% column) this is at.
[Rmax,I] = max(mean(stats_stim_cc.r));

% Use I to find out which lambda_val optimized the correlation
lambda = lambda_vals(I);

% Don't forget to save!!!
save stim_cc_mTRF.mat stats_stim_cc t_stim_cc Rmax I lambda;