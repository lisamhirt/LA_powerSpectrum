%% Get out only screen 70 

allLFP2 = allLFP; 
% copy variables from other script 
gainLossTrials = gainLOSS_trials;
gambleTrials = gamble_trials; 
% allPrePost2 = allPrePost;

outInx = cellfun(@(x) x == 70, allLFP2(:,1)); % Rows where 70 is located

allLFP2(~outInx,:) = []; % this has all of the screen 70s 

behLFP = allLFP2(:,2); % this has all ephys for screen 70

LFPbehavBA2 = behLFP;

%%

%%% find what trials they gambled on, then if they won or loss
gainLoss_gambled = find(all(gainLossTrials & gambleTrials, 2)); % gives me the rows that they gambled on a gain loss trial

% see if they won (gained) on their gamble. 1 means yes they gained 0 means no
gainLoss_gamble_outcomeGain= outcomeGain(gainLoss_gambled);

% see if they loss on their gamble
gainLoss_gamble_outcomeLoss = outcomeLoss(gainLoss_gambled);

%%% pull out the voltages for when they gambled
gambleLFP = LFPbehavBA2(gainLoss_gambled); % only voltages that they gambled on
% gambleLFP = LFPbehav2(gainLoss_gambled); % only voltages that they gambled on

% get the voltages for the trials that they gambled on and won
gambleLFP_outcomeGain = gambleLFP(gainLoss_gamble_outcomeGain);

%% Bandpass 
tempLFP = mean(gambleLFP_outcomeGain{1});
bandpass(tempLFP,[60 250],500);


