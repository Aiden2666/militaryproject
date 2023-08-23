clear all
close all
clc

addpath( genpath([pwd]));

AnalyzeDir = uigetdir({}, 'Select Output folder');
cd (AnalyzeDir);


%% Select participant and condition and input descriptives

[static_file0, static_path] = uigetfile({'*_static.txt'}, 'MultiSelect','ON','Import Static.txt'); 
[trials_file0, trials_path] = uigetfile({'*walking.txt'},'MultiSelect','ON','Import all dynamic trials.txt'); 

if iscell(trials_file0) ~= 1
    trials_file = {fullfile(trials_path, trials_file0)};
else
    trials_file = fullfile(trials_path, trials_file0);
end

if iscell(static_file0) ~= 1
    static_file = {fullfile(trials_path, static_file0)};
else
    static_file = fullfile(trials_path, static_file0);
end


prompt={'Body mass in kg: ',...
        'Body height in m:',...
        'Sex (1 = male; 2 = female)'};
dlg_title = 'Characteristics';
num_lines = 1;

%%% military project %%%
def={'75','1.74','1'};%s01
% def={'82','1.73','1'};%s02 
% def={'70','1.77','1'};%s03
% def={'85','1.80','1'};%s04
% def={'65','1.66','1'};%s05
% def={'66','1.73','1'};%s06
% def={'78','1.84','1'};%s07 
% def={'90','1.75','1'};%s08 
% def={'77','1.80','1'};%s09
% def={'79','1.835','1'};%s10


answer1 = inputdlg(prompt,dlg_title,num_lines,def);
Mass=str2double(answer1{1});
Height=str2double(answer1{2});
sex={'M','F'}; 
s=str2double(answer1{3});

Marker_Freq=120; % Marker freq 
%%% FP_rate = 1200 

% "edited" 폴더 생성
editedDir = fullfile(AnalyzeDir, 'edited');
if ~exist(editedDir, 'dir')
    mkdir(editedDir);
end

% Static 파일 처리
for ii = 1:length(static_file)
    if iscell(static_file)
        [Path, Sname1, Sname2] = fileparts(static_file{ii});
    else
        [Path, Sname1, Sname2] = fileparts(static_file);
    end
    statics = [Sname1 Sname2];
    Data = importdata(statics);
    
    % 파일명에서 무게 정보 추출
    weightInfo = regexp(statics, '(\d+)kg', 'tokens');
    if isempty(weightInfo)
        error('Cannot extract weight information from the filename.');
    else
        weight = weightInfo{1}{1};
    end
    
    % Static 데이터 처리 및 저장
    barefoot_data = Data.data(:, 2:37);
    trainer_data = Data.data(:, 38:73);
    boot_data = Data.data(:, 74:109);
    
    dlmwrite(fullfile(editedDir, ['S01_' weight 'kg_barefoot_static.txt']), barefoot_data, 'delimiter', '\t');
    dlmwrite(fullfile(editedDir, ['S01_' weight 'kg_trainer_static.txt']), trainer_data, 'delimiter', '\t');
    dlmwrite(fullfile(editedDir, ['S01_' weight 'kg_boot_static.txt']), boot_data, 'delimiter', '\t');
end

% Walking 파일 처리
for ii = 1:length(trials_file)
    if iscell(trials_file)
        [Path, Tname1, Tname2] = fileparts(trials_file{ii});
    else
        [Path, Tname1, Tname2] = fileparts(trials_file);
    end
    trials = [Tname1 Tname2];
    Data = importdata(trials);
    
    % 파일명에서 무게 정보 추출
    weightInfo = regexp(trials, '(\d+)kg', 'tokens');
    if isempty(weightInfo)
        error('Cannot extract weight information from the filename.');
    else
        weight = weightInfo{1}{1};
    end
    
    % Walking 데이터 처리 및 저장
    for shoeIdx = 1:3
        switch shoeIdx
            case 1
                shoeType = 'barefoot';
                startCol = 2;
            case 2
                shoeType = 'trainer';
                startCol = 146;
            case 3
                shoeType = 'boot';
                startCol = 290;
        end
        
        for trialNum = 1:3
            colRange = startCol + (trialNum-1)*48 : startCol + trialNum*48 - 1;
            trial_data = Data.data(:, colRange);
            
            dlmwrite(fullfile(editedDir, ['S01_' weight 'kg_' shoeType '_walking_' num2str(trialNum) '.txt']), trial_data, 'delimiter', '\t');
        end
    end
end

clear static_file0 static_path trials_file0 trials_path

[static_file0, static_path] = uigetfile({'*_static.txt'}, 'MultiSelect','ON','Import Static.txt'); 
[trials_file0, trials_path] = uigetfile({'*walking.txt'},'MultiSelect','ON','Import all dynamic trials.txt'); 

if iscell(trials_file0) ~= 1
    trials_file = {fullfile(trials_path, trials_file0)};
else
    trials_file = fullfile(trials_path, trials_file0);
end

if iscell(static_file0) ~= 1
    static_file = {fullfile(trials_path, static_file0)};
else
    static_file = fullfile(trials_path, static_file0);
end


for ii = 1:length(trials_file)
    
    
[Path Tname1  Tname2] = fileparts(trials_file(1,ii));
trials = [Tname1 Tname2];
[empty,Stat] = fileparts(static_file);
Data=importdata(trials);


%% Ellipse Geometry
%Diametersfrom Meardon and Derrick, (2014)
%66.667% of distance from proximal tibia (narrowest point: 67% from prox to distal)
OuterML=23.22/2000; OuterAP=29.32/2000;
InnerML=10.08/2000; InnerAP=9.76/2000;
CSA=((pi*((OuterML*OuterAP)-(InnerML*InnerAP))));
CSA_loc=1-0.6667; %Tibia Cross Section of interest is 66.66% of the length from proximal to distal tibia

% addpath('C:\Users\hannahr\OneDrive - nih.no\NIH\Research\Stress Model Code\Stress Model - Distal Tibia Updated May 2022')
% addpath('C:\Users\hannahr\OneDrive - nih.no\NIH\Research\Matlab Codes')


for t=1
    run Military_Han_ObtainVariables
    run Military_Han_ObtainStatic
    run TransformationMatrix
    run COM
    run JRF
    run StaticOptimisation
%     run MuscTendon_Coords
    run Han_MuscTendon_Coords
    run MuscularForces
    run MuscularBending
    run BendingMoment
    run StressCalculate
end
 

% Plot figures
figure('units', 'normalized', 'position', [0.25 0.55 0.35 0.3]) 
hold on
for t=1
    plot(Output.Stress.Anterior(:,t),'r','LineWidth',2);
    plot(Output.Stress.Posterior(:,t),'b','LineWidth',2);
end
xlim([1,101]); xlabel('Time (% stance)');
ylabel ('Normal Stress (MPa)');
title(Tname1);
legend('Anterior','Posterior','Location','northeast');
set(gca,'FontSize',14);


figure('units', 'normalized', 'position', [0.25 0.55 0.35 0.3]) 
hold on
for t=1
    plot(Output.Moments.Resultant(:,t),'k','LineWidth',2);
    plot(Output.Moments.JRF(:,t),':k');
    plot(Output.Moments.Muscular(:,t),'--k');
end
xlim([1,101]); xlabel('Time (% stance)');
ylabel ('Bending Moments (MBe)');
title(Tname1);
legend('Resultant','JRF','Muscular','Location','southwest');
set(gca,'FontSize',14);

Filename=[Tname1 '_Output.mat'];
save([Filename],'Output');

end

