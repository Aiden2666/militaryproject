%% Bending moments due to the reaction force

%% Calculate the bending due to the JRF
MBE_JRF_AP = JRF_comp_AP + JRF_sh_AP;
Output.Moments.JRF(:,t)=MBE_JRF_AP;

%% Bending moments due to muscular forces
MBE_Musc_AP=MuscBending_sh_AP_all+MuscBending_comp_AP_all;
Output.Moments.Muscular(:,t)=MBE_Musc_AP;

%% Resultant bending moments (or knee contact forces)
MBE_AP= MBE_JRF_AP + MBE_Musc_AP;
Output.Moments.Resultant(:,t)=MBE_AP;

%Normalise for comparison with Haris Phuah paper 
MBE_AP_norm=(MBE_AP/(Mass*9.81*Height))*100;
Output.Moment.Resultant_Normalised(:,t)=MBE_AP_norm;
