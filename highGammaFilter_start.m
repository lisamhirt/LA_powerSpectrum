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

% get the voltages for the trials that they gambled on and won
gambleLFP_outcomeGain = gambleLFP(gainLoss_gamble_outcomeGain);



%% Look at voltages that they lost on 

% see if they loss on their gamble (copied from above) 
gainLoss_gamble_outcomeLoss = outcomeLoss(gainLoss_gambled);

% get the voltages for the trials that they gambled on and lost 
gambleLFP_outcomeLoss = gambleLFP(gainLoss_gamble_outcomeLoss);




%% Bandpass 

gambleGain_gamma = double.empty; 

for bi = 1: height(gambleLFP_outcomeGain)

    tempLFP = mean(gambleLFP_outcomeGain{bi});
    % find 20 samples in the middle (250-270) and stick them on the front
    % and back of bpLFP. Then when i get yupper i chop the back off before
    % saving to get rid of edge effect 
    bpLFP = bandpass(tempLFP,[60 250],500); % put 200 instead of 250 
    [yupper, ~] = envelope(bpLFP);
    gambleGain_gamma{bi} = yupper;
end 

gambleLoss_gamma = double.empty;

for ai = 1:height(gambleLFP_outcomeLoss)
    tempLFP = mean(gambleLFP_outcomeLoss{ai});
    bpLFP = bandpass(tempLFP,[60 250],500);
    [yupper, ~] = envelope(bpLFP);
    gambleLoss_gamma{ai} = yupper;

end 

%% average ephys 

% Gain 
gambleGain_gamma = gambleGain_gamma';

gambleGain_gamma_avg = double.empty;
tempCellHold = double.empty; 

for ti = 1:height(gambleGain_gamma)
    tempCell = gambleGain_gamma{ti};
    tempCellHold = tempCell(1:498); 
    gambleGain_gamma_avg = [gambleGain_gamma_avg; tempCellHold];

    tempCellHold = double.empty;

end 

gambleGain_gamma_avg2 = mean(gambleGain_gamma_avg, 1);

% Loss 

gambleLoss_gamma = gambleLoss_gamma';

gambleLoss_gamma_avg = double.empty;
tempCellHold = double.empty; 

for ti = 1:height(gambleLoss_gamma)
    tempCell = gambleLoss_gamma{ti};
    tempCellHold = tempCell(1:499); 
    gambleLoss_gamma_avg = [gambleLoss_gamma_avg; tempCellHold];

    tempCellHold = double.empty;

end 

gambleLoss_gamma_avg2 = mean(gambleLoss_gamma_avg, 1);



%%


plot(gambleLoss_gamma_avg2)
hold on 
plot(gambleGain_gamma_avg2)


