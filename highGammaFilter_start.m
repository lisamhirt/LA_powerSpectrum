%% Get out only screen 70 

allLFP2 = allLFP; 
% copy variables from other script 
gainLossTrials = gainLOSS_trials;
gambleTrials = gamble_trials; 
% allPrePost2 = allPrePost;

outInx = cellfun(@(x) x == 70, allLFP2(:,1)); % Rows where 70 is located

allLFP2(~outInx,:) = []; % this has all of the screen 70s 

% behLFP = allLFP2(:,2); % this has all ephys for screen 70
behLFP = allLFP2(:,3); % this has all ephys for screen 70

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

%% Bandpass - try to get rid of edge effects and use the pre post already there 

gambleGain_gamma = double.empty; 

for bi = 1: height(gambleLFP_outcomeGain)

    tempLFP = mean(gambleLFP_outcomeGain{bi});
    % tempSamplePre = mean(gambleLFP_outcomeGain_pre{bi});
    % tempSamplePost = mean(gambleLFP_outcomeGain_post{bi});
    % tempSamples = tempLFP(250:270); % pull out samples in the middle of the ephys 
    % tempLFP_samples = [tempSamplePre tempLFP tempSamplePost]; % Stick the samples in front and behind the LFP to pad it to get rid of the edge effect 

    bpLFP = bandpass(tempLFP,[60 200],500); 
    [yupper, ~] = envelope(bpLFP);
    yupper((end-250):end) = []; % remove the last random samples from tempSamplePost 
    yupper(1:250) = []; % remove the first 21 samples from tempSamples 
    gambleGain_gamma{bi} = yupper; % save yupper 
end 

gambleLoss_gamma = double.empty;

for ai = 1:height(gambleLFP_outcomeLoss)

    tempLFP = mean(gambleLFP_outcomeLoss{ai});
    % tempSamplePre = mean(gambleLFP_outcomeLoss_pre{ai});
    % tempSamplePost = mean(gambleLFP_outcomeLoss_post{ai});
    % tempSamples = tempLFP(250:270); % pull out samples in the middle of the ephys 
    % tempLFP_samples = [tempSamplePre tempLFP tempSamplePost]; % Stick the samples in front and behind the LFP to pad it to get rid of the edge effect 

    bpLFP = bandpass(tempLFP,[60 200],500);
    [yupper, ~] = envelope(bpLFP);
    yupper((end-250):end) = []; % remove the last 21 random samples from tempSamples
    yupper(1:250) = []; % remove the first 21 samples from tempSamples 
    gambleLoss_gamma{ai} = yupper;

end 



%% Bandpass - try to get rid of edge effects 

% gambleGain_gamma = double.empty; 
% 
% for bi = 1: height(gambleLFP_outcomeGain)
% 
%     tempLFP = mean(gambleLFP_outcomeGain{bi});
%     tempSamplePre = mean(gambleLFP_outcomeGain_pre{bi});
%     tempSamplePost = mean(gambleLFP_outcomeGain_post{bi});
%     % tempSamples = tempLFP(250:270); % pull out samples in the middle of the ephys 
%     tempLFP_samples = [tempSamplePre tempLFP tempSamplePost]; % Stick the samples in front and behind the LFP to pad it to get rid of the edge effect 
% 
%     bpLFP = bandpass(tempLFP_samples,[60 200],500); 
%     [yupper, ~] = envelope(bpLFP);
%     yupper((end-(length(tempSamplePost)-1)):end) = []; % remove the last random samples from tempSamplePost 
%     yupper(1:length(tempSamplePre)) = []; % remove the first 21 samples from tempSamples 
%     gambleGain_gamma{bi} = yupper; % save yupper 
% end 
% 
% gambleLoss_gamma = double.empty;
% 
% for ai = 1:height(gambleLFP_outcomeLoss)
% 
%     tempLFP = mean(gambleLFP_outcomeLoss{ai});
%     tempSamplePre = mean(gambleLFP_outcomeLoss_pre{ai});
%     tempSamplePost = mean(gambleLFP_outcomeLoss_post{ai});
%     % tempSamples = tempLFP(250:270); % pull out samples in the middle of the ephys 
%     tempLFP_samples = [tempSamplePre tempLFP tempSamplePost]; % Stick the samples in front and behind the LFP to pad it to get rid of the edge effect 
% 
%     bpLFP = bandpass(tempLFP_samples,[60 200],500);
%     [yupper, ~] = envelope(bpLFP);
%     yupper((end-(length(tempSamplePost)-1)):end) = []; % remove the last 21 random samples from tempSamples
%     yupper(1:length(tempSamplePre)) = []; % remove the first 21 samples from tempSamples 
%     gambleLoss_gamma{ai} = yupper;
% 
% end 
% 
%% Bandpass - still has edge effects. Try to fix above 

% gambleGain_gamma = double.empty; 
% 
% for bi = 1: height(gambleLFP_outcomeGain)
% 
%     tempLFP = mean(gambleLFP_outcomeGain{bi});
%     tempSamples = tempLFP(250:270); % pull out samples in the middle of the ephys 
%     tempLFP_samples = [tempSamples tempLFP tempSamples]; % Stick the samples in front and behind the LFP to pad it to get rid of the edge effect 
% 
%     bpLFP = bandpass(tempLFP_samples,[60 200],500); 
%     [yupper, ~] = envelope(bpLFP);
%     yupper((end-(length(tempSamples)-1)):end) = []; % remove the last 21 random samples from tempSamples
%     yupper(1:21) = []; % remove the first 21 samples from tempSamples 
%     gambleGain_gamma{bi} = yupper; % save yupper 
% end 
% 
% gambleLoss_gamma = double.empty;
% 
% for ai = 1:height(gambleLFP_outcomeLoss)
% 
%     tempLFP = mean(gambleLFP_outcomeLoss{ai});
%     tempSamples = tempLFP(250:270); % pull out samples in the middle of the ephys 
%     tempLFP_samples = [tempSamples tempLFP tempSamples]; % Stick the samples in front and behind the LFP to pad it to get rid of the edge effect 
% 
%     bpLFP = bandpass(tempLFP_samples,[60 200],500);
%     [yupper, ~] = envelope(bpLFP);
%     yupper((end-(length(tempSamples)-1)):end) = []; % remove the last 21 random samples from tempSamples
%     yupper(1:21) = []; % remove the first 21 samples from tempSamples 
%     gambleLoss_gamma{ai} = yupper;
% 
% end 

%% Bandpass - notes - dont use 

% gambleGain_gamma = double.empty; 
% 
% for bi = 1: height(gambleLFP_outcomeGain)
% 
%     tempLFP = mean(gambleLFP_outcomeGain{bi});
%     % find 20 samples in the middle (250-270) and stick them on the front
%     % and back of bpLFP. Then when i get yupper i chop the back off before
%     % saving to get rid of edge effect 
%     bpLFP = bandpass(tempLFP,[60 250],500); % put 200 instead of 250 
%     [yupper, ~] = envelope(bpLFP);
%     gambleGain_gamma{bi} = yupper;
% end 
% 
% gambleLoss_gamma = double.empty;
% 
% for ai = 1:height(gambleLFP_outcomeLoss)
%     tempLFP = mean(gambleLFP_outcomeLoss{ai});
%     bpLFP = bandpass(tempLFP,[60 250],500);
%     [yupper, ~] = envelope(bpLFP);
%     gambleLoss_gamma{ai} = yupper;
% 
% end 

%% average ephys 

% Gain 
gambleGain_gamma = gambleGain_gamma';

gambleGain_gamma_avg = double.empty;
tempCellHold = double.empty; 

for ti = 1:height(gambleGain_gamma)
    tempCell = gambleGain_gamma{ti};
    tempCellHold = tempCell(1:497); 
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
    tempCellHold = tempCell(1:497); 
    gambleLoss_gamma_avg = [gambleLoss_gamma_avg; tempCellHold];

    tempCellHold = double.empty;

end 

gambleLoss_gamma_avg2 = mean(gambleLoss_gamma_avg, 1);



%%


plot(gambleLoss_gamma_avg2)
hold on 
plot(gambleGain_gamma_avg2)

%% PrePost bandpass 

allPrePost2 = allPrePost;

outInxPre = cellfun(@(x) x == 70, allPrePost2(:,1)); % Rows where 70 is located

allPrePost2(~outInxPre,:) = []; % this has all of the screen 70s 

preLFP = allPrePost2(:,2); % this has all ephys for screen 70
postLFP = allPrePost2(:,3); 

% GAMBLE WIN %

% Pre Gamble Win %
%%% pull out the voltages for when they gambled
gambleLFP_pre = preLFP(gainLoss_gambled); % only voltages that they gambled on

% get the voltages for the trials that they gambled on and won
gambleLFP_outcomeGain_pre = gambleLFP_pre(gainLoss_gamble_outcomeGain);

% Post Gamble Win 
%%% pull out the voltages for when they gambled
gambleLFP_post = postLFP(gainLoss_gambled); % only voltages that they gambled on

% get the voltages for the trials that they gambled on and won
gambleLFP_outcomeGain_post = gambleLFP_post(gainLoss_gamble_outcomeGain);


% GAMBLE LOST %
% Pre gamble Lost % 
% get the voltages for the trials that they gambled on and lost
gambleLFP_outcomeLoss_pre = gambleLFP_pre(gainLoss_gamble_outcomeLoss);
% Post gamble lost % 
gambleLFP_outcomeLoss_post = gambleLFP_post(gainLoss_gamble_outcomeLoss);

%% Bandpass - pre post 

gambleGain_pre = double.empty; 

for bi = 1: height(gambleLFP_outcomeGain_pre)

    tempLFP = mean(gambleLFP_outcomeGain_pre{bi});
    % tempSamples = tempLFP(50:175); % pull out samples in the middle of the ephys 
    tempPre = flip(tempLFP);
    tempLFP_samples = [tempPre tempLFP tempPre]; % Stick the samples in front and behind the LFP to pad it to get rid of the edge effect 

    bpLFP = bandpass(tempLFP_samples,[60 200],500); 
    [yupper, ~] = envelope(bpLFP);
    yupper((end-(length(tempLFP)-1)):end) = []; % remove the last 21 random samples from tempSamples
    yupper(1:length(tempPre)) = []; % remove the first 21 samples from tempSamples 
    gambleGain_pre{bi} = yupper; % save yupper 
end 

gambleGain_post = double.empty; 

for bi = 1: height(gambleLFP_outcomeGain_post)

    tempLFP = mean(gambleLFP_outcomeGain_post{bi});
    % tempSamples = tempLFP(50:175); % pull out samples in the middle of the ephys 
    tempPre = flip(tempLFP);
    tempLFP_samples = [tempPre tempLFP tempPre]; % Stick the samples in front and behind the LFP to pad it to get rid of the edge effect 

    bpLFP = bandpass(tempLFP_samples,[60 200],500); 
    [yupper, ~] = envelope(bpLFP);
    yupper((end-(length(tempLFP)-1)):end) = []; % remove the last  random samples from tempSamples
    yupper(1:length(tempPre)) = []; % remove thesamples from tempSamples 
    gambleGain_post{bi} = yupper; % save yupper 
end 

gambleGain_PrePost = [gambleGain_pre' gambleGain_post'];

% Gamble loss 
gambleLoss_pre = double.empty;

for ai = 1:height(gambleLFP_outcomeLoss_pre)

    tempLFP = mean(gambleLFP_outcomeLoss_pre{ai});
    % tempSamples = tempLFP(50:175); % pull out samples in the middle of the ephys 
    tempPre = flip(tempLFP);
    tempLFP_samples = [tempPre tempLFP tempPre]; % Stick the samples in front and behind the LFP to pad it to get rid of the edge effect 

    bpLFP = bandpass(tempLFP_samples,[60 200],500);
    [yupper, ~] = envelope(bpLFP);
    yupper((end-(length(tempPre)-1)):end) = []; % remove the last 21 random samples from tempSamples
    yupper(1:length(tempPre)) = []; % remove the first 21 samples from tempSamples 
    gambleLoss_pre{ai} = yupper;

end 

gambleLoss_post = double.empty;

for ai = 1:height(gambleLFP_outcomeLoss_post)

    tempLFP = mean(gambleLFP_outcomeLoss_post{ai});
    % tempSamples = tempLFP(50:175); % pull out samples in the middle of the ephys 
    tempPre = flip(tempLFP);
    tempLFP_samples = [tempPre tempLFP tempPre]; % Stick the samples in front and behind the LFP to pad it to get rid of the edge effect 

    bpLFP = bandpass(tempLFP_samples,[60 200],500);
    [yupper, ~] = envelope(bpLFP);
    yupper((end-(length(tempPre)-1)):end) = []; % remove the last 21 random samples from tempSamples
    yupper(1:length(tempPre)) = []; % remove the first 21 samples from tempSamples 
    gambleLoss_post{ai} = yupper;

end 

gambleLoss_PrePost = [gambleLoss_pre' gambleLoss_post'];
