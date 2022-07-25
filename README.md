# LalorLab-NeuroMusic
MMM REU Summer 2022

creating_eeg_all → creates directory of stimuli, creates eeg_all from Nate's blocked trials, downsamples both to 128Hz

eeg_all_2_SxTDN → takes eeg_all and reformats as SxTDN

eeg_all_filt → takes in unfiltered eeg_all, minimum, maximum for filter range

SxTDN_filt → takes in unfiltered SxTDN, minimum, maximum for filter range

isc_per_subject.m → Parra’s shortened CorrCA code - not original ISC that we used

matched_ISC → our pipeline feeding data through Parra’s shortened CorrCA code
