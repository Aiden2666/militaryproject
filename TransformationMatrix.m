%%Create segment vectors and local coordinate systems
% All right side
%% Create foot vectors
Y_foot = (MidMT_stat - CALC_stat);
ML_foot = (MT1_stat-MT5_stat);

Z_foot=cross(Y_foot,ML_foot);
X_foot=cross(Y_foot, Z_foot);


%% Create shank vectors
Z_shank = (MidKnee_stat - MidAnkle_stat);
ML_shank = (LatMal_stat - MedMal_stat);

Y_shank=cross(Z_shank, ML_shank);
X_shank=cross(Y_shank,Z_shank);


%% Create thigh vectors
Z_thigh = (HIP_stat - MidKnee_stat);
ML_thigh = (LatKnee_stat - MedKnee_stat);

Y_thigh = cross(Z_thigh, ML_thigh);
X_thigh = cross(Y_thigh, Z_thigh);


Y_foot_unit=Y_foot'/norm(Y_foot);
X_foot_unit=X_foot'/norm(X_foot);
Z_foot_unit=Z_foot'/norm(Z_foot);

Y_shank_unit=Y_shank'/norm(Y_shank);
X_shank_unit=X_shank'/norm(X_shank);
Z_shank_unit=Z_shank'/norm(Z_shank);

Y_thigh_unit=Y_thigh'/norm(Y_thigh);
X_thigh_unit=X_thigh'/norm(X_thigh);
Z_thigh_unit=Z_thigh'/norm(Z_thigh);

Foot_rot=[X_foot_unit,Y_foot_unit,Z_foot_unit];
Shank_rot=[X_shank_unit,Y_shank_unit,Z_shank_unit];
Thigh_rot=[X_thigh_unit,Y_thigh_unit,Z_thigh_unit];
