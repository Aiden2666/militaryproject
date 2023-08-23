
%% Read in data from text files
% Force data

Force = Data.data(:,2:4);

% Coordinate data 
MT1 = Data.data(:,5:7);
MT5 = Data.data(:,8:10);
CALC = Data.data(:,11:13);
MMAL = Data.data(:,14:16);
LMAL = Data.data(:,17:19);
MFEM = Data.data(:,20:22);
LFEM = Data.data(:,23:25);
HIP = Data.data(:,26:28);

% MidKnee = Data.data(:,29:31);
% MidAnkle = Data.data(:,32:34);

% Moments data
% Ensure that: 
% Flexion-extension moments in col 2; frontal in 1;
% Positive Flex-ext moment in both knee and ankle
M_AN_x = -Data.data(:,36);
M_AN_y = -Data.data(:,35);
M_AN_z = -Data.data(:,37);
M_KN_x = Data.data(:,39);
M_KN_y = Data.data(:,38);
M_KN_z = Data.data(:,40);

M_HIP = Data.data(:,41:43)*-1; % 41:X, 42:Y, 43:Z

M_AN=[M_AN_x,M_AN_y,M_AN_z];
M_KN=[M_KN_x,M_KN_y,M_KN_z];

MidMT = (MT1+MT5)./2;
MidAnkle = (LMAL + MMAL)./2;
MidKnee = (LFEM + MFEM)./2;

