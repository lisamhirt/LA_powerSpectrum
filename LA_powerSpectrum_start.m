
% Get out only screen 70
allLFP2 = allLFP;
% allPrePost2 = allPrePost;

outInx = cellfun(@(x) x == 70, allLFP2(:,1)); % Rows where 70 is located

allLFP2(~outInx,:) = []; % this has all of the screen 70s

% LFPbehavBA = allLFP3(:,2); % this now only has the ephys for screen 70 and use for the whole time frame

%%
behLFP = allLFP2(:,2); % this has all ephys for screen 70

% copy variables from other script
gainLossTrials = gainLOSS_trials;
gambleTrials = gamble_trials;

LFPbehavBA2 = behLFP; % copy variable

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

% Average across the electrodes for each outcome gain
% avgGamble_gain = double.empty; % this will hold all of the individual averages for the 3 contacts for each screen
%
% for i = 1:length(gambleLFP_outcomeGain)
%     tempAvg = mean(gambleLFP_outcomeGain{i}, 1);
%     avgGamble_gain(i, 1:numel(tempAvg)) = tempAvg;
% end % for


%%

LFPspec = [];
% LFPdata = [];

for ei = 1:height(gambleLFP_outcomeGain)
    % Get out temp ephys
    tempLFP = gambleLFP_outcomeGain{ei}'; % first column. Need to change orientation to put into pspectrum
    tempLFPc = mean(tempLFP,2); % average the rows across the two columns to put one column into pspectrum

    [deltaDataLFP,thetaDataLFP,alphaDataLFP,betaDataLFP,betaLDataLFP,betaHDataLFP,gammaDataLFP,gammaLDataLFP,gammaHDataLFP] = getPowerSpectrum(tempLFPc);

    LFPspec{ei, 1} = deltaDataLFP;
    LFPspec{ei, 2} = thetaDataLFP;
    LFPspec{ei, 3} = alphaDataLFP;
    LFPspec{ei, 4} = betaDataLFP;
    LFPspec{ei, 5} = betaLDataLFP;
    LFPspec{ei, 6} = betaHDataLFP;
    LFPspec{ei, 7} = gammaDataLFP;
    LFPspec{ei, 8} = gammaLDataLFP;
    LFPspec{ei, 9} = gammaHDataLFP;

end % ei




% [tempfxx, temppxx] = pspectrum(tempLFPc, 250, 'FrequencyLimits', [0.5 50]);
% 
% temppxx2 = pow2db(temppxx);
% 

% Save
% Rows are contacts
% Columns are: 1: frequency (fxx) 2: pow2db power unbroken up by bands
% 3: Delta, 4: Theta, 5: Alpha, 6: Beta, 7: Low Beta, 8: High Beta, 9:
% gamma, 10: Low gamma, 11: High Gamma
% LFPspec{ci, 1} = fxx;
% LFPspec{ci, 2} = pxx2;
% LFPspec{ci, 1} = deltaData;
% LFPspec{ci, 2} = thetaData;
% LFPspec{ci, 3} = alphaData;
% LFPspec{ci, 4} = betaData;
% LFPspec{ci, 5} = betaLData;
% LFPspec{ci, 6} = betaHData;
% LFPspec{ci, 7} = gammaData;
% LFPspec{ci, 8} = gammaLData;
% LFPspec{ci, 9} = gammaHData;

function [deltaData,thetaData,alphaData,betaData,betaLData,betaHData,gammaData,gammaLData,gammaHData] = getPowerSpectrum(tempLFPc)

[tempfxx, temppxx] = pspectrum(tempLFPc, 500, 'FrequencyLimits', [0.5 100]);
temppxx2 = pow2db(temppxx);

% Get frequency ranges and power spectrums
detlaFinx = find(tempfxx>=0.05 & tempfxx<=4);
deltaPxx = temppxx2(detlaFinx);

thetaFinx = find(tempfxx>=4 & tempfxx<=8);
thetaPxx = temppxx2(thetaFinx);

alphaFinx = find(tempfxx>=8 & tempfxx<=13);
alphaPxx = temppxx2(alphaFinx);

betaFinx = find(tempfxx>=13 & tempfxx<=30);
betaPxx = temppxx2(betaFinx);

betaLFinx = find(tempfxx>=13 & tempfxx<=21);
betaLPxx = temppxx2(betaLFinx);

betaHFinx = find(tempfxx>=21 & tempfxx<=30);
betaHPxx = temppxx2(betaHFinx);

gammaFinx = find(tempfxx>=30 & tempfxx(end));
gammaPxx = temppxx2(gammaFinx);

gammaLFinx = find(tempfxx>=30 & tempfxx<=50);
gammaLPxx = temppxx2(gammaLFinx);

gammaHFinx = find(tempfxx>=50 & tempfxx(end));
gammaHPxx = temppxx2(gammaHFinx);

% Get mean, stadard dev., min, max for each power

freqBands = [{'delta' 'theta' 'alpha' 'beta' 'betaL' 'betaH' 'gamma' 'gammaL' 'gammaH'}];

for fi = 1:length(freqBands)
    switch freqBands{fi}
        case 'delta'
            deltaData.deltaStats.mean = mean(deltaPxx);
            deltaData.deltaStats.maxAmp = max(deltaPxx);
            deltaData.deltaStats.minAmp = min(deltaPxx);
            deltaData.deltaStats.stDev = std(deltaPxx);

            maxFreqLoc = find(ismember(deltaPxx, max(deltaPxx)));
            deltaData.deltaStats.maxFreq = detlaFinx(maxFreqLoc);
            deltaData.powerVal = deltaPxx;

        case 'theta'
            thetaData.thetaStats.mean = mean(thetaPxx);
            thetaData.thetaStats.maxAmp = max(thetaPxx);
            thetaData.thetaStats.minAmp = min(thetaPxx);
            thetaData.thetaStats.stDev = std(thetaPxx);

            maxFreqLoc = find(ismember(thetaPxx, max(thetaPxx)));
            thetaData.thetaStats.maxFreq = thetaFinx(maxFreqLoc);
            thetaData.powerVal = thetaPxx;

        case 'alpha'
            alphaData.alphaStats.mean = mean(alphaPxx);
            alphaData.alphaStats.maxAmp = max(alphaPxx);
            alphaData.alphaStats.minAmp = min(alphaPxx);
            alphaData.alphaStats.stDev = std(alphaPxx);

            maxFreqLoc = find(ismember(alphaPxx, max(alphaPxx)));
            alphaData.alphaStats.maxFreq = alphaFinx(maxFreqLoc);
            alphaData.powerVal = alphaPxx;

        case 'beta'
            betaData.betaStats.mean = mean(betaPxx);
            betaData.betaStats.maxAmp = max(betaPxx);
            betaData.betaStats.minAmp = min(betaPxx);
            betaData.betaStats.stDev = std(betaPxx);

            maxFreqLoc = find(ismember(betaPxx, max(betaPxx)));
            betaData.betaStats.maxFreq = betaFinx(maxFreqLoc);
            betaData.powerVal = betaPxx;

        case 'betaL'
            betaLData.betaLStats.mean = mean(betaLPxx);
            betaLData.betaLStats.maxAmp = max(betaLPxx);
            betaLData.betaLStats.minAmp = min(betaLPxx);
            betaLData.betaLStats.stDev = std(betaLPxx);

            maxFreqLoc = find(ismember(betaLPxx, max(betaLPxx)));
            betaLData.betaLStats.maxFreq = betaLFinx(maxFreqLoc);
            betaLData.powerVal = betaLPxx;

        case 'betaH'
            betaHData.betaHStats.mean = mean(betaHPxx);
            betaHData.betaHStats.maxAmp = max(betaHPxx);
            betaHData.betaHStats.minAmp = min(betaHPxx);
            betaHData.betaHStats.stDev = std(betaHPxx);

            maxFreqLoc = find(ismember(betaHPxx, max(betaHPxx)));
            betaHData.betaHStats.maxFreq = betaHFinx(maxFreqLoc);
            betaHData.powerVal = betaHPxx;

        case 'gamma'
            gammaData.gammaStats.mean = mean(gammaPxx);
            gammaData.gammaStats.maxAmp = max(gammaPxx);
            gammaData.gammaStats.minAmp = min(gammaPxx);
            gammaData.gammaStats.stDev = std(gammaPxx);

            maxFreqLoc = find(ismember(gammaPxx, max(gammaPxx)));
            gammaData.gammaStats.maxFreq = gammaFinx(maxFreqLoc);
            gammaData.powerVal = gammaPxx;

        case 'gammaL'
            gammaLData.gammaLStats.mean = mean(gammaLPxx);
            gammaLData.gammaLStats.maxAmp = max(gammaPxx);
            gammaLData.gammaLStats.minAmp = min(gammaPxx);
            gammaLData.gammaLStats.stDev = std(gammaLPxx);

            maxFreqLoc = find(ismember(gammaLPxx, max(gammaLPxx)));
            gammaLData.gammaLStats.maxFreq = gammaLFinx(maxFreqLoc);
            gammaLData.powerVal = gammaLPxx;

        case 'gammaH'
            gammaHData.gammaHStats.mean = mean(gammaHPxx);
            gammaHData.gammaHStats.maxAmp = max(gammaHPxx);
            gammaHData.gammaHStats.minAmp = min(gammaHPxx);
            gammaHData.gammaHStats.stDev = std(gammaHPxx);

            maxFreqLoc = find(ismember(gammaHPxx, max(gammaHPxx)));
            gammaHData.gammaHStats.maxFreq = gammaHFinx(maxFreqLoc);
            gammaHData.powerVal = gammaHPxx;
        otherwise
            continue

    end % switch

end % getPowerSpectrum / fi

end % getPowerSpec fxn

