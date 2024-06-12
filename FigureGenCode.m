% Used CLASE018
%% Get out only screen 70 

allLFP2 = allLFP; 
% copy variables from other script 
gainLossTrials = gainLOSS_trials;
gambleTrials = gamble_trials; 
% allPrePost2 = allPrePost;

outInx = cellfun(@(x) x == 70, allLFP2(:,1)); % Rows where 70 is located

allLFP2(~outInx,:) = []; % this has all of the screen 70s 

% behLFP = allLFP2(:,2); % this has all ephys for screen 70
% behLFP = allLFP2(:,3); % this has all ephys for screen 70 - see if i want second or third column 
behLFP = allLFP2(:,2);

LFPbehavBA2 = behLFP;

%% Figure out what trial to do for gamble gain  - do row 57
tempLFPTest = mean(LFPbehavBA2{124});
tempLFPTest_edge = flip(tempLFPTest);
tempTestTrial = [tempLFPTest_edge tempLFPTest tempLFPTest_edge];
bpTestLFP =  bandpass(tempTestTrial,[60 200],500);
[yupper, ~] = envelope(bpTestLFP);
yupper((end-(length(tempLFPTest_edge)-1)):end) = []; % remove the last 21 random samples from tempSamples
yupper(1:length(tempLFPTest_edge)) = []; % remove the first 21 samples from tempSamples
lostTestyupper = yupper; % save yupper

gainTestOutcome124 = smoothdata(lostTestyupper,2, "gaussian", 10);

plot(gainTestOutcome124)

figure;
plot(gainTestOutcome57, 'r') % do this one 
hold on 
plot(gainTestOutcome64, 'b')
hold on 
plot(gainTestOutcome124, 'm')



%%

%%% find what trials they gambled on, then if they won or loss
gainLoss_gambled = find(all(gainLossTrials & gambleTrials, 2)); % gives me the rows that they gambled on a gain loss trial

% see if they won (gained) on their gamble. 1 means yes they gained 0 means no
gainLoss_gamble_outcomeGain= outcomeGain(gainLoss_gambled);

% see if they loss on their gamble
gainLoss_gamble_outcomeLoss = outcomeLoss(gainLoss_gambled);

%%% pull out the voltages for when they gambled
gambleLFP = LFPbehavBA2(gainLoss_gambled); % only voltages that they gambled on

% get the voltages for the trials that they gambled on and won
gambleLFP_outcomeGain = gambleLFP(gainLoss_gamble_outcomeGain);
%% Look at voltages that they lost on 

% see if they loss on their gamble (copied from above) 
gainLoss_gamble_outcomeLoss = outcomeLoss(gainLoss_gambled);

% get the voltages for the trials that they gambled on and lost 
gambleLFP_outcomeLoss = gambleLFP(gainLoss_gamble_outcomeLoss);

%% Pull out money values 
% Pull out the rows for the money that they gambled on 
moneyOut_gambled = moneyTrial(gainLoss_gambled); 

% Pull out the money values for when they won the gamble 
moneyGamble_gain = moneyOut_gambled(gainLoss_gamble_outcomeGain);

% Pull out the money values for when they loss the gamble 
moneyGamble_loss = moneyOut_gambled(gainLoss_gamble_outcomeLoss);

%% OUTCOME EPOCH

% Get out only first row of money lost ephys 
lostTrialLFP = mean(gambleLFP_outcomeLoss{1,1});


% spectrum for lost trial 
pspectrum(lostTrialLFP,"spectrogram")
title('Lost Gamble')


% get out the 4th row for money gain 
winTrialLFP = mean(gambleLFP_outcomeGain{9,1}); % bc i am doing the first 12 dollar gamble gain 
pspectrum(winTrialLFP, "spectrogram") % spectrum for gain trial 
title('Gain Gamble')



% filter for gamma 
% lost trial 

lostTrialLFP_edge = flip(lostTrialLFP);
tempLostTrial = [lostTrialLFP_edge lostTrialLFP lostTrialLFP_edge];
bpLFP =  bandpass(tempLostTrial,[50 150],500);
[yupper, ~] = envelope(bpLFP);
yupper((end-(length(lostTrialLFP_edge)-1)):end) = []; % remove the last 21 random samples from tempSamples
yupper(1:length(lostTrialLFP_edge)) = []; % remove the first 21 samples from tempSamples
lostFLPyupper = yupper; % save yupper

lostGambleOutcome = smoothdata(lostFLPyupper,2, "gaussian", 10);

plot(lostGambleOutcome)
title('Lost Gamble')

% win trail 

winTrialLFP_edge = flip(winTrialLFP);
tempWinTrial = [winTrialLFP_edge winTrialLFP winTrialLFP_edge];
bpLFPWin =  bandpass(tempWinTrial,[50 150],500);
[yupperW, ~] = envelope(bpLFPWin);
yupperW((end-(length(winTrialLFP_edge)-1)):end) = []; % remove the last 21 random samples from tempSamples
yupperW(1:length(winTrialLFP_edge)) = []; % remove the first 21 samples from tempSamples
winFLPyupper = yupperW; % save yupper

winGambleOutcome = smoothdata(winFLPyupper,2, "gaussian", 10);

plot(winGambleOutcome)
title('Gain Gamble')

%plot win and loss on same graph 
plot(lostGambleOutcome, 'r')
hold on 
plot(winGambleOutcome, 'g')


%% OPTION EPOCH 
allLFPOption = allLFP;
outInxOption = cellfun(@(x) x == 60, allLFPOption(:,1)); % Rows where 60 is located

allLFPOption(~outInxOption,:) = []; % this has all of the screen 70s 

% behLFP = allLFP2(:,2); % this has all ephys for screen 70
behLFPOption = allLFPOption(:,2); % this has all ephys for screen 60

% LFPbehavBA2 = behLFPOption;

% Pull out lost trial option 
lostTrialOp = mean(behLFPOption{5});

% Pull out gain trial option 
gainTrialOp = mean(behLFPOption{57});

% Spectrograms option 
pspectrum(lostTrialOp, "spectrogram") % spectrum for lost trial 
title('Lost Gamble')
pspectrum(gainTrialOp, "spectrogram") % spectrum for gain trial 
title('Gain Gamble')

% filter for gamma 
% lost trial 

lostTrialLFP_edgeOp = flip(lostTrialOp);
tempLostTrialOp = [lostTrialLFP_edgeOp lostTrialOp lostTrialLFP_edgeOp];
bpLFPLostOp =  bandpass(tempLostTrialOp,[50 150],500);
[yupperLostOp, ~] = envelope(bpLFPLostOp);
yupperLostOp((end-(length(lostTrialLFP_edgeOp)-1)):end) = []; % remove the last 21 random samples from tempSamples
yupperLostOp(1:length(lostTrialLFP_edgeOp)) = []; % remove the first 21 samples from tempSamples
lostOpFLPyupper = yupperLostOp; % save yupper

lostOp = smoothdata(lostOpFLPyupper,2, "gaussian", 10);

plot(lostOp)
title('Lost Gamble')

% win trail 

winTrialLFP_edgeOp = flip(gainTrialOp);
tempWinTrialOp = [winTrialLFP_edgeOp gainTrialOp winTrialLFP_edgeOp];
bpLFPWinOp =  bandpass(tempWinTrialOp,[50 150],500);
[yupperWOp, ~] = envelope(bpLFPWinOp);
yupperWOp((end-(length(winTrialLFP_edgeOp)-1)):end) = []; % remove the last 21 random samples from tempSamples
yupperWOp(1:length(winTrialLFP_edgeOp)) = []; % remove the first 21 samples from tempSamples
winOpFLPyupper = yupperWOp; % save yupper

winOp = smoothdata(winOpFLPyupper,2, "gaussian", 10);

plot(winOpFLPyupper)
title('Gain Gamble')

% plot both win and loss 
plot(lostOp, 'r')
hold on 
plot(winOp, 'g')

%% DECISION SCREEN 

allLFPDecision = allLFP;
outInxDecision = cellfun(@(x) x == 64, allLFPDecision(:,1)); % Rows where 60 is located

allLFPDecision(~outInxDecision,:) = []; % this has all of the screen 70s 

% behLFP = allLFP2(:,2); % this has all ephys for screen 70
behLFPDecision = allLFPDecision(:,2); % this has all ephys for screen 60

% LFPbehavBA2 = behLFPOption;

% Pull out lost trial dec 
lostTrialDe = mean(behLFPDecision{5});

% Pull out gain trial dec 
gainTrialDe = mean(behLFPDecision{57});

% Spectrograms decision 
pspectrum(lostTrialDe, "spectrogram") % spectrum for lost trial 
title('Lost Gamble')
pspectrum(gainTrialDe, "spectrogram") % spectrum for gain trial 
title('Gain Gamble')

% filter for gamma 
% lost trial 

lostTrialLFP_edgeDe = flip(lostTrialDe);
tempLostTrialDe = [lostTrialLFP_edgeDe lostTrialDe lostTrialLFP_edgeDe];
bpLFPLostDe =  bandpass(tempLostTrialDe,[50 150],500);
[yupperLostDe, ~] = envelope(bpLFPLostDe);
yupperLostDe((end-(length(lostTrialLFP_edgeDe)-1)):end) = []; % remove the last 21 random samples from tempSamples
yupperLostDe(1:length(lostTrialLFP_edgeDe)) = []; % remove the first 21 samples from tempSamples
lostDeFLPyupper = yupperLostDe; % save yupper

lostDe = smoothdata(lostDeFLPyupper,2, "gaussian", 10);

plot(lostDe)
title('Lost Gamble')

% win trail 

winTrialLFP_edgeDe = flip(gainTrialDe);
tempWinTrialDe = [winTrialLFP_edgeDe gainTrialDe winTrialLFP_edgeDe];
bpLFPWinDe =  bandpass(tempWinTrialDe,[50 150],500);
[yupperWDe, ~] = envelope(bpLFPWinDe);
yupperWDe((end-(length(winTrialLFP_edgeDe)-1)):end) = []; % remove the last 21 random samples from tempSamples
yupperWDe(1:length(winTrialLFP_edgeDe)) = []; % remove the first 21 samples from tempSamples
winDeFLPyupper = yupperWDe; % save yupper

winDe = smoothdata(winDeFLPyupper,2, "gaussian", 10);

plot(winDe)
title('Gain Gamble')

plot(lostDe, 'r')
hold on 
plot(winDe, 'g')
xlim([0 940])


%% Post Decision SCREEN to the 

allLFPPostDec = allLFP;
outInxPostDec= cellfun(@(x) x == 62, allLFPPostDec(:,1)); % Rows where 60 is located

allLFPPostDec(~outInxPostDec,:) = []; % this has all of the screen 70s 

% behLFP = allLFP2(:,2); % this has all ephys for screen 70
behLFPPostDec = allLFPPostDec(:,2); % this has all ephys for screen 60

% LFPbehavBA2 = behLFPOption;

% Pull out lost trial post dec 
lostTrialPostDe = mean(behLFPPostDec{5});

% Pull out gain trial post dec 
gainTrialPostDe = mean(behLFPPostDec{57});

% Spectrograms post dec 
pspectrum(lostTrialPostDe, "spectrogram") % spectrum for lost trial 
title('Lost Gamble')
pspectrum(gainTrialPostDe, "spectrogram") % spectrum for gain trial 
title('Gain Gamble')

% filter for gamma 
% lost trial 

lostTrialLFP_edgePostDe = flip(lostTrialPostDe);
tempLostTrialPostDe = [lostTrialLFP_edgePostDe lostTrialPostDe lostTrialLFP_edgePostDe];
bpLFPLostPostDe =  bandpass(tempLostTrialPostDe,[50 150],500);
[yupperLostPostDe, ~] = envelope(bpLFPLostPostDe);
yupperLostPostDe((end-(length(lostTrialLFP_edgePostDe)-1)):end) = []; % remove the last 21 random samples from tempSamples
yupperLostPostDe(1:length(lostTrialLFP_edgePostDe)) = []; % remove the first 21 samples from tempSamples
lostPostDeFLPyupper = yupperLostPostDe; % save yupper

lostPostDe = smoothdata(lostPostDeFLPyupper,2, "gaussian", 10);

plot(lostPostDe)
title('Lost Gamble')

% win trail 

winTrialLFP_edgePostDe = flip(gainTrialPostDe);
tempWinTrialPostDe = [winTrialLFP_edgePostDe gainTrialPostDe winTrialLFP_edgePostDe];
bpLFPWinPostDe =  bandpass(tempWinTrialPostDe,[50 150],500);
[yupperWPostDe, ~] = envelope(bpLFPWinPostDe);
yupperWPostDe((end-(length(winTrialLFP_edgePostDe)-1)):end) = []; % remove the last 21 random samples from tempSamples
yupperWPostDe(1:length(winTrialLFP_edgePostDe)) = []; % remove the first 21 samples from tempSamples
winPostDeFLPyupper = yupperWPostDe; % save yupper

winPostDe = smoothdata(winPostDeFLPyupper,2, "gaussian", 10);

plot(winPostDe)
title('Gain Gamble')


plot(lostPostDe, 'r')
hold on 
plot(winPostDe, 'g')
xlim([0 506])



