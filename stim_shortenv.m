%% Trimming and reorganizing stimulus envelopes by stimcode (STEP 1)

cut_stim_env = {}; 
% comment line 3 out after first run because want everything in the same
% structure.

% for each stimulus in a given category (10)
for ii = 1:(height(stimset_genre))
    % stimset_genre = which stimset (rock, classical, vocals, or speech)

    % Find one stimulus' cell of data
    step1 = stimset_genre(ii); 

    % Extract the data itself from said cell
    step2 = step1{:,:};

    % Transpose the data to get number of samples to be rows not columns 
    step3 = transpose(step2);

    % Trim the data to remove the first 1000 samples (artifact) and
    % any after 18000; go to 19000 because removing 1000 from the front
    step4 = step3(1001:19000,1);
    % If performing analysis within a stimulus column, actually wouldn't
    % need to truncate to 18000; could just shorten everything (stimulus
    % samples and EEG data to that stimulus' length once the artifact has
    % been removed. FUTURE WORK?!

    % Inserts the trimmed data into a new structure created at the outset
    cut_stim_env{1,(x9+ii)} = step4; %#ok<SAGROW> 
    % x9 = which number ending in 9 + 1 will get you the first stimcode of 
    % the stimset you're working with; stimcodes start at 10

end

clear ii step1 step2 step3 step4;