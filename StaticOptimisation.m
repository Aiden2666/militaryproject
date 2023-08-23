% Author: Ross Miller
% Date:   April 24, 2015
% Adapted by Hannah Rice, 26/9/2017
%
% This program reads in lower limb inverse dynamics data for walking and
% performs static optimization to calculate the forces in 20 muscles that 
% reproduce those moments while minimizing a cost function.  The
% input joint angles and moments are from Miller et al. (2014, MSSE).
%
% The example here is a very simple version of static optimization:
%  - The lower limb model is 2D (sagittal plane only)
%  - The muscle moment arms are constant (not affected by joint angles)
%  - No muscle activation or contractile dynamics are modeled
%
% The default cost function is the sum of cubed muscle stresses.  This
% cost can be customized by the user in the function "StaticOptCF.m".


global a p

%% Model parameters
Nmus = 25;   % Number of muscles in the model
STEN = 61.0; % Specific tension (N/cm^2)
Cecc = 1.5;  % Eccentric plateau force factor

% Abbreviations for muscle names (used in plotting)
MusNames = [{'ILI'},{'PSO'},{'GMAX'},{'GMED'},{'ADDM'},{'BFL'},{'SEM'}, ...
            {'SET'},{'RF'},{'SAR'},{'VASI'},{'VASL'},{'VASM'},{'BFS'},{'GASL'}, ...
            {'GASM'},{'TA'},{'SOL'},{'TP'},{'EDL'},{'FDL'},{'PRB'},{'PRL'},{'EHL'},{'FHL'}];

% Muscle PCSA [cm^2] (Arnold et al., 2010)
PCSA(1)  = 10.2; % Iliacus
PCSA(2)  =  7.9; % Psoas
PCSA(3)  = 30.4; % Gluteus Maximus
PCSA(4)  = 36.1; % Gluteus Medius
PCSA(5)  = 21.3; % Adductor Magnus
PCSA(6)  = 11.6; % Biceps Femoris (LH)
PCSA(7)  = 19.1; % Semimembranosus
PCSA(8)  =  4.9; % Semitendinosus
PCSA(9)  = 13.9; % Rectus Femoris
PCSA(10) = 1.9;  % Sartorius
PCSA(11) = 16.9; % Vastus Intermedius
PCSA(12) = 37.0; % Vastus Lateralis
PCSA(13) = 23.7; % Vastus Medialis
PCSA(14) =  5.2; % Biceps Femoris (SH)
PCSA(15) =  9.9; % Gastrocnemius (LH)
PCSA(16) = 21.4; % Gastrocnemius (MH)
PCSA(17) = 11.0; % Tibialis Anterior
PCSA(18) = 58.8; % Soleus
PCSA(19) = 14.8; % Tibialis Posterior
PCSA(20) =  5.7; % Extensor Digitorum Longus
PCSA(21) =  4.5; % Flexor Digitorum Longus
PCSA(22) =  5.0; % Peroneus Brevis
PCSA(23) =  10.7;% Peroneus Longus
PCSA(24) =   2.7;% Extensor Hallucis Longus
PCSA(25) =   7.2;% Flexor Hallucis Longus

% Maximum isometric forces (N)
Fo = PCSA*STEN;

% Hip moment arms [m] %derived from Hamner, Seth, Delp (2010)
Rm(1,1)  =  0.0404; % Iliacus @ Hip
Rm(1,2)  =  0.0397; % Psoas @ Hip
Rm(1,3)  = -0.0532; % Gluteus Maximus @ Hip
Rm(1,4)  = -0.0211; % Gluteus Medius @ Hip
Rm(1,5)  = -0.0228; % Adductor Magnus @ Hip
Rm(1,6)  = -0.0585; % Biceps Femoris (LH) @ Hip
Rm(1,7)  = -0.0590; % Semitendinosus @ Hip
Rm(1,8)  = -0.0507; % Semimembranosus @ Hip
Rm(1,9)  =  0.0444; % Rectus Femoris @ Hip
Rm(1,10) =  0.0515; % Sartorius @ Hip 
Rm(1,11) =  0; % Vastus Intermedius @ Hip
Rm(1,12) =  0; % Vastus Lateralis @ Hip
Rm(1,13) =  0; % Vastus Medialis @ Hip
Rm(1,14) =  0; % Biceps Femoris (SH) @ Hip
Rm(1,15) =  0; % Gastrocnemius (LH) @ Hip
Rm(1,16) =  0; % Gastrocnemius (MH) @ Hip
Rm(1,17) =  0; % Tibialis Anterior @ Hip
Rm(1,18) =  0; % Soleus @ Hip
Rm(1,19) =  0; % Tibialis Posterior @ Hip
Rm(1,20) =  0; % Extendor Digitorum Longus @ Hip
Rm(1,21) =  0; % Flexor Digitorum Longus @ Hip
Rm(1,22) =  0; % Peroneus Brevis
Rm(1,23) =  0; % Peroneus Longus
Rm(1,24) =  0; % Extensor Hallucis Longus @ Hip
Rm(1,25) =  0; % Flexor Hallucis Longus @ Hip

% Knee moment arms [m] %derived from Hamner, Seth, Delp (2010)
Rm(2,1)  =  0; % Iliacus @ Knee
Rm(2,2)  =  0; % Psoas @ Knee
Rm(2,3)  =  0; % Gluteus Maximus @ Knee
Rm(2,4)  =  0; % Gluteus Medius @ Knee
Rm(2,5)  =  0; % Adductor Magnus @ Knee
Rm(2,6)  = -0.0335; % Biceps Femoris (LH) @ Knee
Rm(2,7)  = -0.0441; % Semimembranosus @ Knee
Rm(2,8)  = -0.0376; % Semimembranocus @ Knee
Rm(2,9)  =  0.0490; % Rectus Femoris @ Knee
Rm(2,10) = -0.0069; % Sartorius @ Knee 
Rm(2,11) =  0.0448; % Vastus Intermedius @ Knee
Rm(2,12) =  0.0448; % Vastus Lateralis @ Knee
Rm(2,13) =  0.0442; % Vastus Medialis @ Knee
Rm(2,14) = -0.0300; % Biceps Femoris (SH) @ Knee
Rm(2,15) = -0.0220; % Gastrocnemius (LH) @ Knee
Rm(2,16) = -0.0218; % Gastrocnemius (MH) @ Knee
Rm(2,17) =  0; % Tibialis Anterior @ Knee
Rm(2,18) =  0; % Soleus @ Knee
Rm(2,19) =  0; % Tibialis Posterior @ Knee
Rm(2,20) =  0; % Extendor Digitorum Longus @ Knee
Rm(2,21) =  0; % Flexor Digitorum Longus @ Knee
Rm(2,22) =  0; % Peroneus Brevis
Rm(2,23) =  0; % Peroneus Longus
Rm(2,24) =  0; % Extensor Hallucis Longus @ Knee
Rm(2,25) =  0; % Flexor Hallucis Longus @ Knee

% Ankle moment arms [m] %derived from Hamner, Seth, Delp (2010)
Rm(3,1)  =  0; % Iliacus @ Ankle
Rm(3,2)  =  0; % Psoas @ Ankle
Rm(3,3)  =  0; % Gluteus Maximus @ Ankle
Rm(3,4)  =  0; % Gluteus Medius @ Ankle
Rm(3,5)  =  0; % Adductor Magnus @ Ankle
Rm(3,6)  =  0; % Biceps Femoris (LH) @ Ankle
Rm(3,7)  =  0; % Semimembranosus @ Ankle
Rm(3,8)  =  0; % Semimembranocus @ Ankle
Rm(3,9)  =  0; % Rectus Femoris @ Ankle
Rm(3,10) =  0; % Sartorius @ Ankle
Rm(3,11) =  0; % Vastus Intermedius @ Ankle
Rm(3,12) =  0; % Vastus Lateralis @ Ankle
Rm(3,13) =  0; % Vastus Medialis @ Ankle
Rm(3,14) =  0; % Biceps Femoris (SH) @ Ankle
Rm(3,15) = -0.0477; % Gastrocnemius (LH) @ Ankle
Rm(3,16) = -0.0467; % Gastrocnemius (MH) @ Ankle
Rm(3,17) =  0.0408; % Tibialis Anterior @ Ankle
Rm(3,18) = -0.0463; % Soleus @ Ankle
Rm(3,19) = -0.0119; % Tibialis Posterior @ Ankle
Rm(3,20) =  0.0378; % Extendor Digitorum Longus @ Ankle
Rm(3,21) = -0.0114; % Flexor Digitorum Longus @ Ankle
Rm(3,22) =  -0.0051; % Peroneus Brevis 
Rm(3,23) =  -0.0093; % Peroneus Longus 
Rm(3,24) =  0.0394; % Extensor Hallucis Longus @ Ankle %derived from Hamner, Seth, Delp (2010)
Rm(3,25) = -0.0166; % Flexor Hallucis Longus @ Ankle %derived from Hamner, Seth, Delp (2010)

%% Optimization
% Define muscle-specific weights and mathematical order for cost function 
a = 1./PCSA;
p = 3;

% Pre-allocate
Fm(1:101,1:Nmus) = 0;
J(1:101) = 0;

% Set up and run fmincon
for i = 1:101
    % Equality constraint: inverse dynamics joint moments
    Aeq = Rm;
    
    beq(1,1) = -M_HIP(i,2); %Inverse dynamics data
    beq(2,1) = M_KN(i,2); %Inverse dynamics data
    beq(3,1) = -M_AN(i,2); %Inverse dynamics data
   
    % Inequality constraints: none
    A = [];
    b = [];
    
    % Nonlinear constraints: none
    nonlcon = [];
    
    % Bounds on muscle forces
    LB(1:Nmus) = 0;
    UB(1:Nmus) = Cecc*PCSA*STEN;
    
    % fmincon options
    options = optimset('Algorithm','interior-point');
    
    % Initial guess
    if (i == 1)
        Fm0 = LB;
    else
        Fm0 = Fm(i-1,:);
    end
    
    % Run fmincon
    [Fm(i,:),J(i)] = fmincon(@StaticOptCF,Fm0,A,b,Aeq,beq,LB,UB,nonlcon,options);
end

%% Post Processing

% Plot muscle forces
% figure()
% plot(Fm); xlim([1 101]); xlabel('Time (% stance)'); ylabel('Force (N)');