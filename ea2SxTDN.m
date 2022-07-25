%% Getting eeg_all into (Sx)TDN format

function [SxTDN] = eeg_all_2_SxTDN(eeg_all)

SxTDN = {};

for cc = 1:46
    firstcell = true;
    for rr = (1:height(eeg_all))
        
        if ~isempty(eeg_all{rr,cc})
            if firstcell == true
                SxTDN{1,cc} = eeg_all{rr,cc}; %#ok<SAGROW>
                firstcell = false;
            else
                SxTDN{1,cc} = cat(3,SxTDN{1,cc},eeg_all{rr,cc}); %#ok<SAGROW>
            end
        end
    end
end

