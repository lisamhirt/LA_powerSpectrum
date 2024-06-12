% Z score values and then subtract them 

% Gamble GAIN % 
gambleGain_gamma = gambleGain_gamma';

% Create empty vectors 
preGambleGainZ = double.empty;
GambleGainZ = double.empty;
postGambleGainZ = double.empty; 

for gi = 1:length(gambleGain_gamma)
    
    tempEpoch = gambleGain_gamma{gi}; % temp ephys of interest 
    tempPost = gambleGain_PrePost{gi,2}; % Temp post 

    % Get pre / baseline data  
    tempBLpre = gambleGain_PrePost{gi,1};
    meanBLpre = mean(tempBLpre);
    stdBLpre = std(tempBLpre);

    % Zscore base line 

    for bi = 1:length(tempBLpre)
        tempZscoreBL = (tempBLpre(bi) - meanBLpre)/stdBLpre;
        preGambleGainZ(gi, bi) = tempZscoreBL;
    end % for / bi  
        
    % Zscore temp epoch  
    for ji = 1:length(tempEpoch)
        tempZscore = (tempEpoch(ji) - meanBLpre)/stdBLpre;
        GambleGainZ(gi,ji) = tempZscore;
    end % for ji 

    % Z score post 
     for pi = 1:length(tempPost)
         tempZscorePost = (tempPost(pi) - meanBLpre)/stdBLpre; 
         postGambleGainZ(gi, pi) = tempZscorePost;
     end % pi for 

end % for gi 

% Gamble LOSS % 

% Variables 
gambleLoss_gamma = gambleLoss_gamma';
% gambleLoss_PrePost 

% Create empty vectors 
preGambleLossZ = double.empty;
GambleLossZ = double.empty;
postGambleLossZ = double.empty; 


for gi = 1:length(gambleLoss_gamma)
    
    tempEpoch = gambleLoss_gamma{gi}; % temp ephys of interest 
    tempPost = gambleLoss_PrePost{gi,2}; % Temp post 

    % Get pre / baseline data  
    tempBLpre = gambleLoss_PrePost{gi,1};
    meanBLpre = mean(tempBLpre);
    stdBLpre = std(tempBLpre);

    % Zscore base line 

    for bi = 1:length(tempBLpre)
        tempZscoreBL = (tempBLpre(bi) - meanBLpre)/stdBLpre;
        preGambleLossZ(gi, bi) = tempZscoreBL;
    end % for / bi  
        
    % Zscore temp epoch  
    for ji = 1:length(tempEpoch)
        tempZscore = (tempEpoch(ji) - meanBLpre)/stdBLpre;
        GambleLossZ(gi,ji) = tempZscore;
    end % for ji 

    % Z score post 
     for pi = 1:length(tempPost)
         tempZscorePost = (tempPost(pi) - meanBLpre)/stdBLpre; 
         postGambleLossZ(gi, pi) = tempZscorePost;
     end % pi for 

end % for gi 


%% Plot 

% Gain %
% Mean gain trials 
preGambleGainAvg = mean(preGambleGainZ);
GambleGainAvg = mean(GambleGainZ);
postGambleGainAvg = mean(postGambleGainZ); 

% create x spacing for graph 
x = linspace(-0.5, 0, length(preGambleGainAvg));
x2 = linspace(0,1, length(GambleGainAvg));
x3 = linspace(1,1.5, length(postGambleGainAvg));

figure;
plot(x, preGambleGainAvg)
hold on 
plot(x2, GambleGainAvg)
hold on 
plot(x3, postGambleGainAvg)

% Loss 
preGambleLossAvg = mean(preGambleLossZ);
GambleLossAvg = mean(GambleLossZ);
postGambleLossAvg = mean(postGambleLossZ); 

xL = linspace(-0.5, 0, length(preGambleLossAvg));
x2L = linspace(0,1, length(GambleLossAvg));
x3L = linspace(1,1.5, length(postGambleLossAvg));

figure;
plot(xL, preGambleLossAvg)
hold on
plot(x2L, GambleLossAvg)
hold on 
plot(x3L, postGambleLossAvg)

%% 
% Test to smooth data 
GambleGainAvg2 = GambleGainAvg; 

gambleGainSTest = smoothdata(GambleGainAvg2, "gaussian", 10);

plot(gambleGainSTest)

%% Smooth data 

% Smooth gain trials 
preGambleGainS = smoothdata(preGambleGainZ,2, "gaussian", 10);
GambleGainS = smoothdata(GambleGainZ,2, "gaussian", 10);
postGambleGainS = smoothdata(postGambleGainZ,2, "gaussian", 10); 

% Smooth loss trials 
preGambleLossS = smoothdata(preGambleLossZ, 2, "gaussian", 10);
GambleLossS = smoothdata(GambleLossZ, 2, "gaussian", 10);
postGambleLossS = smoothdata(postGambleLossZ, 2, "gaussian", 10);

%% Plot each individual trial 

% Gain %

% create x spacing for graph 
xGpre = linspace(-0.5, 0, length(preGambleGainS));
xG = linspace(0,1, length(GambleGainS));
xGpost = linspace(1,1.5, length(postGambleGainS));

InvidGain = tiledlayout(6,6);
title(InvidGain,'Individual Gain Trials')
for i = 1:height(GambleGainS)
    nexttile;
    plot(xGpre,preGambleGainS(i,:))
    hold on 
    plot(xG,GambleGainS(i,:), 'k')
    hold on 
    plot(xGpost, postGambleGainS(i,:), 'm')

end 

% Loss % 

% create x spacing for graph 
xLpre = linspace(-0.5, 0, length(preGambleLossS));
xL = linspace(0,1, length(GambleLossS));
xLpost = linspace(1,1.5, length(postGambleLossS));

InvidLoss = tiledlayout(6,7);
title(InvidLoss,'Individual Loss Trials')
for ii = 1:height(GambleLossS)
    nexttile;
    plot(xLpre,preGambleLossS(ii,:))
    hold on 
    plot(xL,GambleLossS(ii,:), 'k')
    hold on 
    plot(xLpost, postGambleLossS(ii,:), 'm')

end 


%% Plot average and standard deviation for each trial 

% Gain %
% Mean individual gain trials 
preGambleGainAvgInd = mean(preGambleGainZ, 2);
GambleGainAvgInd = mean(GambleGainZ,2);
postGambleGainAvgInd = mean(postGambleGainZ,2); 

% Standard dev individual gain trials - this is weird 
% preGambleGainStdInd = std(preGambleGainZ,0, 2);
% GambleGainStdInd = std(GambleGainZ,0,2);
% postGambleGainStdInd = std(postGambleGainZ,0,2); 

InvidGainMean = tiledlayout(6,6);
title(InvidGainMean,'Individual Gain Trials')
for i = 1:height(GambleGainS)
    nexttile;
    plot(xGpre,preGambleGainS(i,:))
    hold on 
    plot(xGpre, repelem(preGambleGainAvgInd(i), length(xGpre)), 'r');
    hold on 
    plot(xG,GambleGainS(i,:), 'k')
    hold on 
    plot(xG, repelem(GambleGainAvgInd(i), length(xG)), 'r')
    hold on 
    plot(xGpost, postGambleGainS(i,:), 'm')
    hold on 
    plot(xGpost, repelem(postGambleGainAvgInd(i), length(xGpost)), 'r')

end 

% Loss % 
% Mean individual Loss trials 
preGambleLossAvgInd = mean(preGambleLossZ, 2);
GambleLossAvgInd = mean(GambleLossZ,2);
postGambleLossAvgInd = mean(postGambleLossZ,2); 

InvidLoss = tiledlayout(6,7);
title(InvidLoss,'Individual Loss Trials')
for ii = 1:height(GambleLossS)
    nexttile;
    plot(xLpre,preGambleLossS(ii,:))
    hold on 
    plot(xLpre, repelem(preGambleLossAvgInd(ii), length(xLpre)), 'r');
    hold on 
    plot(xL,GambleLossS(ii,:), 'k')
    hold on 
    plot(xL, repelem(GambleLossAvgInd(ii), length(xL)), 'r');
    hold on 
    plot(xLpost, postGambleLossS(ii,:), 'm')
    hold on 
    plot(xLpost, repelem(postGambleLossAvgInd(ii), length(xLpost)), 'r')
end 




