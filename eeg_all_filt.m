%% Filtering eeg_all format and removing first 1000 samples

function [eeg_all] = eeg_all_filt(unfilt_eeg_all,min,max)

for ss = 1:size(unfilt_eeg_all,2) % for each stimulus
    for ee = 1:height(unfilt_eeg_all) % for each subject
        if ~isempty(unfilt_eeg_all{ee,ss})
            ourEEG = unfilt_eeg_all{ee,ss}; % one particular trial
            bandpassFilterRange = [min,max]; % Hz
            addpath ('C:\Users\rache\Documents\MATLAB\MMM_REU_2022\');
            
            % Filtering - LPF (low-pass filter)
            if bandpassFilterRange(2) > 0
                hd = getLPFilt(128,bandpassFilterRange(2));
                % Filtering each trial/run with a for loop
                ourEEG2 = filtfilthd(hd,ourEEG);
            end
            
            % Filtering - HPF (high-pass filter)
            if bandpassFilterRange(1) > 0
                hd = getHPFilt(128,bandpassFilterRange(1));
                % Filtering each trial/run with a for loop
                ourEEG3 = filtfilthd(hd,ourEEG2);
                % Filtering external channels -- removed
            end
            eeg_all{ee,ss} = ourEEG3(1001:end,:);
        end
    end
end