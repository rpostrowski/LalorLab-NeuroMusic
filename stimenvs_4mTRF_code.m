%% Copy and paste from cut_stim_env into a structure with the same dimensions as eeg_all (STEP 2)

% Create new structure to put organized data into
new_stimenvs_4mTRF = [];

% for each column (stimulus)
for cc = 10:46

    % for each row (subject)
    for rr = 1:13

        % Get correct envelope for stimulus (cc) (COPY)
        cell = cut_stim_env{1,cc};

        % Put stimulus envelope in same spot in structure created at
        % outset as where there is EEG for that subject listening to that
        % stimulus (PASTE)
        new_stimenvs_4mTRF{rr,cc} = cell; %#ok<SAGROW> 
    end
end

%% Condensing eeg_all and/or new_stimenvs_4mTRF horizontally to do a TRF for each subject
% We did NOT conduct our final analysis by subject, but it is possible to
% do if one wanted. 

% Create new structure to put organized data into; name according to which
% data you are organizing at the time
stimdata_perstim = [];

% for each row (subject)
for rr = 1:13

    % counter
    n = 0;

    % for each column (stimulus)
    for cc = 10:46

        % If there is nothing in the cell, add to the counter
        if isempty(new_stimenvs_4mTRF{rr,cc})
            n = n+1;
        end

        % If there is something in the cell, take that data and insert it
        % into the next available empty cell horizontally.
        % Condensing from right to left, which will misalign whether or not
        % a subject actually listened to that stimulus or not; manually reversible
        if ~isempty(new_stimenvs_4mTRF{rr,cc})
            stimdata_perstim{rr,cc-n} = new_stimenvs_4mTRF{rr,cc}; %#ok<SAGROW> 
        end
    end
end


%% Condensing eeg_all and/or new_stimenvs_4mTRF vertically to do a TRF for each stimulus
% This IS what we conducted for our project in an effort to keep as many
% variables the same between TRF and ISC

% Create new structre to put organized data into; name according to which
% data you are organizing at the time
subjdata_perstim = [];

% for each column (stimulus)
for cc = 10:46

    % counter
    n = 0;

    % for each row (subject)
    for rr = 1:13

        % If there is nothing in the cell, add to the counter
        if isempty(eeg_all{rr,cc})
            n = n+1;
        end

        % If there is something in the cell, take that data and insert it
        % into the next available empty cell vertically.
        % Condensing from bottom to top, which will misalign whether or not
        % a subject actually listened to that stimulus or not; manually
        % reversible.
        if ~isempty(eeg_all{rr,cc})
            subjdata_perstim{rr-n,cc} = eeg_all{rr,cc}; %#ok<SAGROW> 
        end
    end
end
