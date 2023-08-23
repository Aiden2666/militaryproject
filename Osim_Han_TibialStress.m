clear all
close all
clc

addpath( genpath([pwd]));

AnalyzeDir = uigetdir({}, 'Select Output folder');
cd (AnalyzeDir);


%% Select participant and condition and input descriptives

[static_file, static_path] = uigetfile({'*_static.txt'}, 'Import Static.txt'); 
[trials_file0, trials_path] = uigetfile({'*_run_*.txt'},'MultiSelect','ON','Import all dynamic trials.txt'); 

if iscell(trials_file0) ~= 1
    trials_file = {fullfile(trials_path, trials_file0)};
else
    trials_file = fullfile(trials_path, trials_file0);
end

prompt={'Body mass in kg: ',...
        'Body height in m:',...
        'Sex (1 = male; 2 = female)'};
dlg_title = 'Characteristics';
num_lines = 1;

%%% Marathon project %%%
% def={'69','1.775','1'};%s01
% def={'70.9','1.752','1'};%s02 graph error(20220620) -> succeed with Han_MuscTendon_coords (20220627)
% def={'58.5','1.67','1'};%s03
% def={'59.9','1.618','2'};%s04
% def={'50.8','1.653','1'};%s05
% def={'60.7','1.688','2'};%s06
% def={'60.4','1.637','2'};%s07 graph error(20220620)
% def={'50.2','1.563','2'};%s08 graph error(20220620)
% def={'71.8','1.688','1'};%s09
% def={'55.8','1.615','2'};%s10
% def={'63.5','1.687','1'};%s11
% def={'59.9','1.706','1'};%s12
% def={'58.8','1.596','2'};%s13
% def={'65.0','1.677','2'};%s14 graph error(20220620)

% def={'51.0','1.537','2'};%s15
% def={'66.5','1.699','1'};%s16
% def={'60.2','1.656','2'};%s17
% def={'63.8','1.779','1'};%s18 graph error(20220623)
def={'72.7','1.628','2'};%s19


answer1 = inputdlg(prompt,dlg_title,num_lines,def);
Mass=str2double(answer1{1});
Height=str2double(answer1{2});
sex={'M','F'}; 
s=str2double(answer1{3});

Marker_Freq=120; % Marathon data Marker freq 
%%% FP_rate = 1200 

% Muscle forces input (from Opensim API)
load('Total_muscularforce_osim.mat');



for ii = 1:length(trials_file)
    
    
[Path Tname1  Tname2] = fileparts(trials_file(1,ii));
trials = [Tname1 Tname2];
[empty,Stat] = fileparts(static_file);
Data=importdata(trials);

%% muscle force input (if)

% 파일명에서 정보 추출
tokens = regexp(trials, 'S(\d+)_run_(\w+)_(\d)\.txt', 'tokens');
subject_num = str2double(tokens{1}{1});
footstrike_type = tokens{1}{2};
trial_num = str2double(tokens{1}{3});

% Matching 
switch footstrike_type
    case 'fore'
        field_name = sprintf('S%02d', subject_num);
        Fm = ForeFS_data(trial_num).(field_name);
    case 'nat'
        field_name = sprintf('S%02d', subject_num);
        Fm = NatFS_data(trial_num).(field_name);
    case 'rear'
        field_name = sprintf('S%02d', subject_num);
        Fm = RearFS_data(trial_num).(field_name);
    otherwise
        error('Unknown footstrike type');
end


       
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
    run Han_ObtainVariables
    run Han_ObtainStatic
    run TransformationMatrix
    run COM
    run JRF
%     run StaticOptimisation
%     run Han_MuscTendon_Coords
    run Osim_Han_MuscTendon_Coords
    run Osim_MuscularForces
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

