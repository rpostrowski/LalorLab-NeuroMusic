datafolder = '/Users/rache/Documents/MATLAB/MMM_REU_2022/Raw_spliced_eeg-selected/'; % pathway shortcut variable
subjs = {'AB','AF','CB','CQ', 'DH','EB','HC','JH','JS','KR','MB','MT','SOS'};

nsubj = length(subjs);
ourIdx = [1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 14, 20, 22, 26, 28, 31, 33, 35, 37, 10, 11, 16, 17, 18, 19, 24, 25, 30, 39, 13, 15, 21, 23, 27, 29, 32, 34, 36, 38, 40, 41, 42, 43, 44, 45, 46, 47];

%% Extract stimuli

stimFolder = '/Users/rache/Documents/MATLAB/MMM_REU_2022/Stimuli/'; % pathway shortcut variable

stimDirectory = dir([stimFolder '*.wav']); % makes list of all files ending with .wav;

nstim = length(stimDirectory);

for ii = 1:nstim
    wavfile = stimDirectory(ii).name;
    % loops through all NeuroMusic stimuli; as ii changes so does the title
    % of the .wav file being read
    [y,fs] = audioread([stimFolder wavfile]);
    % y = matrix of audio samples x audio channels
    % fs = sampling rate
    resampledStimuli{ii}=resample(y,128,fs); %#ok<SAGROW>
end

clear y fs wavfile ii; % clear clutter

resampledStimuli = [cell(1,9) resampledStimuli]; % adds 9 empty cols to left side

stimuli = resampledStimuli(ourIdx); % reordered (and already resampled Stimuli)

stimuli(48:55) = stimuli(47); % setting extra columns to tone pip



%% Extract EEG for Reformatting to SubjxStims -- also downsample and truncate
eeg_all = cell(nsubj,47); % just makes cell of nsubj rows x estimated nstimcode columns

for ss = 1:nsubj
    cursubj = subjs{ss};
    eeg_s = cell(0);
    stimI = [];
    
    subj_d = dir([datafolder cursubj '*.mat']);
    
    for ii = (1:length(subj_d))
        load(subj_d(ii).name);
        eeg_s = [eeg_s; eeg]; %#ok<AGROW> % appending or vertical concatenation
        stimI = [stimI; stim]; %#ok<AGROW>
        % these are what will be preprocessed and then sorted into eeg_all
    end
    
    % clear ii subj_d;
    
    for ee = (1:length(eeg_s))
        ourEEG = eeg_s{ee}(:,:);
        
        % Downsampling EEG and external channels
        ourEEG2 = resample(ourEEG,128,512); % all EEGs originally at 512 Hz
        
        eeg_s{ee} = ourEEG2;
    end
    
    % truncate EEG to match stimuli (line stuff up)
    for ii = (1:length(stimI))
        step1 = stimI(ii);
        if (step1 == 85)
            step1 = 47;
        end
        step2 = stimuli(step1);
        step3 = step2{1,1};
        step4 = height(step3);
        
        eeg_s{ii} = eeg_s{ii}(1:step4,:);
    end
    
    tonePipPlace = 47; % more cohesive arrangment; moving stimcode of tonepip
    % (85) up in the matrix eeg_all
    
    for jj = (1:length(stimI)) % within same subject, for each index in length(stimI)
        if stimI(jj) == 85
            eeg_all(ss,tonePipPlace) = eeg_s(jj); % puts tonepip into column 47
            tonePipPlace = tonePipPlace + 1; % if more than one tonepip, put
            % in next column over
        else
            eeg_all(ss,stimI(jj)) = eeg_s(jj); % add eeg data for subject for
            % specific stimulus in the correct stimulus column
            
        end
    end
end

clear eeg eFs stim ourEEG ourEEG1 ourEEG2 ourEEG3 ourEEG4 bandpassFilterRange;
clear ii jj tonePipPlace resamp_stim reordResampStim hd ee step1 step2 step3 step4;
clear eeg_s ss ourIdx stimDirectory stimI subj_d subjs cursubj datafolder nstim nsubj resampledStimuli stimFolder;


%% Getting eeg_all into (Sx)TDN format

[SxTDN] = eeg_all_2_SxTDN(eeg_all);


%% Filtering SxTDN format

[SxTDN] = SxTDN_filt(unfilt_SxTDN,min,max);
for ss = 10:46
    stimuli{1,ss} = stimuliCopy{1,ss}(1001:end,:);
end

% min / max ==> frequency range
% cuts out first 1000 samples

%% Filtering eeg_all format

% alternatively, we could use this...
[eeg_all] = eeg_all_filt(eeg_all,0.3,30);
for ss = 10:46
    stimuli{1,ss} = stimuli{1,ss}(1001:end,:);
end
% works the same as SxTDN
% both cut out first 1000 samples


%% Truncating EEG and stimuli

for cc = 10:46
    for rr = 1:13
        if ~isempty(eeg_all{rr,cc})
            eeg_all{rr,cc} = eeg_all{rr,cc}(1:18000,:);
        end
    end
end

eeg_all{:,:} = eeg_all{:,:}(1:18000,:);

SxTDN{1,:} = SxTDN{1,:}(1:18000,:);

stimuli{1,:} = stimuli{1,:}(1,18000,:);


%% Other

% Next step is to put big_matrix into "isceeg_run_record.m" which relies on
% "isceeg_ours.m" to function properly