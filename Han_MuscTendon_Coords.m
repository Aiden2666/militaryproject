% Code to present the coordinates of muscle points (origins, insertions, and
% via points) relative to a segment origin
% These values are derived from OpenSim Model Hamner 2010 FullBodyModel
% Notes:  3D, 23 DOF gait model 
% Lower extremity joint defintions based on Delp et al. (1990).  
% Low back joint and anthropometry based on Anderson and Pandy (1999, 2001)
% Planar knee model of Yamaguchi and Zajac (1989).  
% Seth removed the patella to avoid kinematic constraints; insertions of the quadriceps are handled with moving points in the tibia frame. 
% Hamner added arms adapted from Holzbaur et al., 2005.

% Model has the following antrhopometrics:
% Height = 1.8m; 75.16 kg

% Determine segment origins:
% Pelvis: The pelvic reference frame is fixed at the midpoint of the line connecting the two anterior superior iliac spines
% Femur: The femoral frame is fixed at the center of the femoral head
% Tibia: The tibial frame is located at the midpoint of the line between the medial and lateral femoral epicondyles
% Patella: The patellar frame is located at the most distal point of the patella
% Talus: The talar frame is located at the midpoint of the line between the apices of the medical and lateral malleoli
% Calcaneus: The calcaneal frame is located at the most interior, lateral point on the posterior surface of the calcaneus
% Toe: The toe frame is located at the base of the second metatarsal
%%
% Muscle origins, via points and insertions (right side only):
% Coordinates are in metres
ShankProx = MidKnee;
ShankDist = MidAnkle;
FootProx  = CALC;
ThighProx = HIP;


muscles={'GL','GM','TA','Sol','TP','EDL','FDL','FHL','PB','PL','EHL'};

% Muscle points are presented in OpenSim in the order [AP, axial, ML];
% Convert to my setup which is [ML, AP, axial] using axis_reorder.m

% Foot segment in Osim in order [axial AP ML]

% Using the most proximal insertion on to the foot and distal origin on the
% femur - not necessarily origin and insertion

%% Gastrocnemius Lateral (GL)
% Longest section of muscle from is P2 to P3 (have therefore named these P1 and P2 ...
% and original P1 is named P1a as it is needed for moment arm distance)
% Gatroc_lat_P1 ref frame = femur;
GL_P1a_Osim = [-0.022 -0.3946 0.0272];
P1a.GL = axis_reorder(GL_P1a_Osim);
%condition point
% Gatroc_lat_P2 ref frame = femur; (called P1)
GL_P1_Osim = [-0.03 -0.4018 0.0274];
P1.GL = axis_reorder(GL_P1_Osim);
% if knee flexion angle between -0.785398 and 0.174533 radians
% convert to degrees if going to use conditions
% Gastroc_lat_P3 ref frame = calc; (called P2)
GL_P2_Osim = [0 0.031 -0.0053];
P2.GL = axis_reorder(GL_P2_Osim);

%% Gastrocnemius Medial (GM)
% Longest section of muscle is from P2 to P3
% Gatroc_med_P1 ref frame = femur;
GM_P1a_Osim = [-0.019 -0.3929 -0.0235];
P1a.GM = axis_reorder(GM_P1a_Osim);
% condition point
% Gatroc_med_P2 ref frame = femur;
GM_P1_Osim = [-0.03 -0.4022 -0.0258];
P1.GM = axis_reorder(GM_P1_Osim);
% if knee flexion angle between -0.785398 and 0.174533 radians
% convert to degrees if going to use conditions
% Gastroc_med_P3 ref frame = calc;
GM_P2_Osim = [0 0.031 -0.0053];
P2.GM = axis_reorder(GM_P2_Osim);

%% Tibialis Anterior (TA)
% Longest section of muscle is from P1 to P2 (therefore don't need P3)
% Tib_Ant_P1 ref frame = tibia
TA_P1_Osim = [0.0179 -0.1624 0.0115];
P1.TA = axis_reorder(TA_P1_Osim);
% Tib_Ant_P2 ref frame = Calc
TA_P2_Osim = [0.1166 0.0178 -0.0305];
P2.TA = axis_reorder_foot(TA_P2_Osim);

%% Soleus (Sol)
% Only 2 points
% Sol_P1 ref frame = tibia
Sol_P1_Osim = [-0.0024 -0.1533 0.0071];
P1.Sol = axis_reorder(Sol_P1_Osim);
% Sol_P2 ref frame = calc
Sol_P2_Osim = [0.0000 0.031 -0.0053];
P2.Sol = axis_reorder_foot(Sol_P2_Osim);

%% Tibialis Posterior (TP)
% Longest section of muscle is from P1 to P2
% Tib_Post_P1 ref frame = tibia
TP_P1_Osim = [-0.0094 -0.1384 0.0019];
P1.TP = axis_reorder(TP_P1_Osim);
% Tib_Post_P1 ref frame = Calc
TP_P2_Osim = [0.0772 0.0159 -0.0281];
P2.TP = axis_reorder_foot(TP_P2_Osim);

%% Extensor Digitorum Longus (EDL)
% Longest section of muscle is from P1 to P2
% EDL_P1 ref frame = tibia
EDL_P1_Osim = [0.0032 -0.1381 0.0276];
P1.EDL = axis_reorder(EDL_P1_Osim);

%EDL_P2 ref frame = Calc
EDL_P2_Osim = [0.1616  0.0055 0.0130];
P2.EDL = axis_reorder_foot(EDL_P2_Osim);


%% Flexor Digitorum Longus (FDL)
% Longest section of muscle is from P1 to P2
% FDL_P1 ref frame = tibia
FDL_P1_Osim = [-0.0083 -0.2046 -0.0018];
P1.FDL = axis_reorder(FDL_P1_Osim);

%EDL_P2 ref frame = Calc
FDL_P2_Osim = [0.1658 -0.0081  0.0116];
P2.FDL = axis_reorder_foot(FDL_P2_Osim);

%% Flexor Hallucis Longus (FHL)
% Longest section of muscle is from P1 to P2
% FHL_P1_ref frame = tibia
FHL_P1_Osim = [-0.0079 -0.2334 0.0244];
P1.FHL = axis_reorder(FHL_P1_Osim);

% FHL_P2 ref frame = Calc
FHL_P2_Osim = [0.1726 -0.0053 -0.0269];
P2.FHL = axis_reorder_foot(FHL_P2_Osim);

%% Peroneus Brevis (PB)
% Longest section of muscle is from P1 to P2
% PB_P1 ref frame = tibia
PB_P1_Osim = [-0.0070 -0.2646 0.0325];
P1.PB = axis_reorder(PB_P1_Osim);

% PB_P2 ref frame = Calc
PB_P2_Osim = [0.0677 0.0219  0.0343];
P2.PB = axis_reorder_foot(PB_P2_Osim);

%% Peroneus Longus (PL)
% Longest section of muscle is from P1 to P2
% PL_P1 ref frame = tibia
PL_P1_Osim = [0.0005 -0.1568 0.0362];
P1.PL = axis_reorder(PL_P1_Osim);

% PL_P2 ref frame = Calc
PL_P2_Osim = [0.1203 0.0085 -0.0184];
P2.PL = axis_reorder_foot(PL_P2_Osim);

%% Extensor Hallucis Longus (EHL)
% Longest section of muscle is from P1 to P2
% EHL_P1 ref frame = tibia
EHL_P1_Osim = [0.0012 -0.1767 0.0228];
P1.EHL = axis_reorder(EHL_P1_Osim);

% EHL_P2 ref frame = Calc
EHL_P2_Osim = [0.1734 0.0139 -0.0280];
P2.EHL = axis_reorder_foot(EHL_P2_Osim);

% Use rotation matrices to determine the location of the muscle points
% locally. Then consider their position in the global frame so that 2D
% vectors can be determined
        
%Example explanation of code below:
%  Orig.GL(:,:,i)= ThighProx(i,:) + (P2.GL*Thigh_rot);
        % We are concerned with P2.GL as this is the most proximal of points creating the longest section of muscle
        % We therefore use ThighProx and Thigh_rot as the reference frame for this muscle point is the femur


 
 for i=1:101;
    Orig.GL(:,:,i)= (ThighProx(i,:) + P1.GL);
    Orig.GM(:,:,i)= (ThighProx(i,:) + P1.GM);
    Orig.TA(:,:,i)= (ShankProx(i,:) + P1.TA);
    Orig.Sol(:,:,i)= (ShankProx(i,:) + P1.Sol);
    Orig.TP(:,:,i)= (ShankProx(i,:) + P1.TP);
    Orig.EDL(:,:,i)= (ShankProx(i,:) + P1.EDL);
    Orig.FDL(:,:,i)= (ShankProx(i,:) + P1.FDL);
    Orig.FHL(:,:,i)= (ShankProx(i,:) + P1.FHL);
    Orig.PB(:,:,i) = (ShankProx(i,:) + P1.PB);
    Orig.PL(:,:,i) = (ShankProx(i,:) + P1.PL);
    Orig.EHL(:,:,i)= (ShankProx(i,:)+ P1.EHL);
end

%Reshape into 101 x 3 matrices

for m=1:length(muscles)
    Or.(muscles{m}) = squeeze(Orig.(muscles{m}));
    Origin_GCS.(muscles{m}) = Or.(muscles{m})';
end


for i=1:101;
    Inser.GL(:,:,i)= (FootProx(i,:) + P2.GL);
    Inser.GM(:,:,i)= (FootProx(i,:) + P2.GM);
    Inser.TA(:,:,i)= (FootProx(i,:)+ P2.TA);
    Inser.Sol(:,:,i)= (FootProx(i,:) + P2.Sol);
    Inser.TP(:,:,i)= (FootProx(i,:) + P2.TP);
    Inser.EDL(:,:,i)= (FootProx(i,:) + P2.EDL);
    Inser.FDL(:,:,i)= (FootProx(i,:) + P2.FDL);
    Inser.FHL(:,:,i)= (FootProx(i,:) + P2.FHL);
    Inser.PB(:,:,i)= (FootProx(i,:) + P2.PB);
    Inser.PL(:,:,i)= (FootProx(i,:) + P2.PL);
    Inser.EHL(:,:,i)= (FootProx(i,:) + P2.EHL);
end

%Reshape into 101 x 3 matrices
for m=1:length(muscles)
        Ins.(muscles{m}) = squeeze(Inser.(muscles{m}));
        Insertion_GCS.(muscles{m}) = Ins.(muscles{m})';

%% Rotate into shank coordinate system
        Origin.(muscles{m}) = Origin_GCS.(muscles{m})*Shank_rot;
        Insertion.(muscles{m}) = Insertion_GCS.(muscles{m})*Shank_rot;
end

