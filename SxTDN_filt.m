%% Filtering SxTDN format and removing first 1000 samples

function [SxTDN] = SxTDN_filt(unfilt_SxTDN,min,max)

for ss = 1:length(unfilt_SxTDN) % for each stimulus
    for ee = 1:size(unfilt_SxTDN{1,ss},3) % for each subject
        if ~isempty(unfilt_SxTDN{1,ss}(:,:,ee))
            ourEEG = unfilt_SxTDN{1,ss}(:,:,ee); % one particular trial
            bandpassFilterRange = [min,max]; % Hz
            addpath ('C:\Users\rache\Documents\MATLAB\MMM_REU_2022\');
            
            % Filtering - LPF (low-pass filter)
            if bandpassFilterRange(2) > 0
                hd = getLPFilt(128,bandpassFilterRange(2));
                % Filtering each trial/run with a for loop
                ourEEG2 = filtfilthd(hd,ourEEG);
                % Filtering external channels -- removed
            end
            
            % Filtering - HPF (high-pass filter)
            if bandpassFilterRange(1) > 0
                hd = getHPFilt(128,bandpassFilterRange(1));
                % Filtering each trial/run with a for loop
                ourEEG3 = filtfilthd(hd,ourEEG2);
                % Filtering external channels -- removed
            end
            SxTDN{1,ss}(:,:,ee) = ourEEG3(1001:end,:);
        end
    end
end
