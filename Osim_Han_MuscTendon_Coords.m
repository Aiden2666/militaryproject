% Code to present the coordinates of muscle points (origins, insertions, and
% via points) relative to a segment origin
% These values are derived from OpenSim Model Hamner 2010 FullBodyModel
% Notes:  Rajagopal full body model 
% Rajagopal, Apoorva, et al. "Full-Body Musculoskeletal Model for Muscle-Driven Simulation of Human Gait." IEEE Transactions on Biomedical Engineering 63.10 (2016): 2068-2079. (2016)


% Model has the following antrhopometrics:
% Height = 75.337 kg

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

%% Input GRF data to output.mat

% Fm 필드명 가져오기
fields = fieldnames(Fm);

% calcn_r_ 문구가 포함된 필드만 선택
calcn_r_fields = fields(contains(fields, 'calcn_r_'));

% Output.GRF 구조체 초기화
Output.GRF = struct();

% calcn_r_ 문구가 포함된 필드를 Output.GRF로 옮기기
for i = 1:length(calcn_r_fields)
    field_name = calcn_r_fields{i};
    Output.GRF.(field_name) = Fm.(field_name);
end

% Output.GRF의 모든 필드를 정규화
fields = fieldnames(Output.GRF);
for i = 1:length(fields)
    field_name = fields{i};
    Output.GRF.(field_name) = normalize_data(Output.GRF.(field_name));
end



%% Muscle forces input

F.(muscles{1})= Fm.gaslat_r;
F.(muscles{2})= Fm.gasmed_r;
F.(muscles{3})= Fm.tibant_r;
F.(muscles{4})= Fm.soleus_r;
F.(muscles{5})= Fm.tibpost_r;
F.(muscles{6})= Fm.edl_r;
F.(muscles{7})= Fm.fdl_r;
F.(muscles{8})= Fm.fhl_r;
F.(muscles{9})= Fm.perbrev_r;
F.(muscles{10})= Fm.perlong_r;
F.(muscles{11})= Fm.ehl_r;


%% Gastrocnemius Lateral (GL)
% Longest section of muscle from is P2 to P3 (have therefore named these P1 and P2 ...
% and original P1 is named P1a as it is needed for moment arm distance)
% Gatroc_lat_P1 ref frame = femur;

% % % GL_P1a_Osim = [-0.022 -0.3946 0.0272];
% % % P1a.GL = axis_reorder(GL_P1a_Osim);

%condition point
% Gatroc_lat_P2 ref frame = femur; (called P1)
GL_P1_Osim = [-0.0030000000000000001 -0.38140000000000002 0.027699999999999999];
P1.GL = axis_reorder(GL_P1_Osim);
% if knee flexion angle between -0.785398 and 0.174533 radians
% convert to degrees if going to use conditions
% Gastroc_lat_P3 ref frame = calc; (called P2)
GL_P2_Osim = [0.0044000000000000003 0.031 -0.0053];
P2.GL = axis_reorder(GL_P2_Osim);

%% Gastrocnemius Medial (GM)
% Longest section of muscle is from P2 to P3
% Gatroc_med_P1 ref frame = femur;

% % % GM_P1a_Osim = [-0.019 -0.3929 -0.0235];
% % % P1a.GM = axis_reorder(GM_P1a_Osim);

% condition point
% Gatroc_med_P2 ref frame = femur;
GM_P1_Osim = [0.0080000000000000002 -0.37880000000000003 -0.020799999999999999];
P1.GM = axis_reorder(GM_P1_Osim);
% if knee flexion angle between -0.785398 and 0.174533 radians
% convert to degrees if going to use conditions
% Gastroc_med_P3 ref frame = calc;
GM_P2_Osim = [0.0044000000000000003 0.031 -0.0053];
P2.GM = axis_reorder(GM_P2_Osim);

%% Tibialis Anterior (TA)
% Longest section of muscle is from P1 to P2 (therefore don't need P3)
% Tib_Ant_P1 ref frame = tibia
TA_P1_Osim = [0.0154 -0.13120000000000001 0.016199999999999999];
P1.TA = axis_reorder(TA_P1_Osim);
% Tib_Ant_P2 ref frame = Calc
TA_P2_Osim = [0.1166 0.0178 -0.030499999999999999];
P2.TA = axis_reorder_foot(TA_P2_Osim);

%% Soleus (Sol)
% Only 2 points
% Sol_P1 ref frame = tibia
Sol_P1_Osim = [-0.0076 -0.091600000000000001 0.0097999999999999997];
P1.Sol = axis_reorder(Sol_P1_Osim);
% Sol_P2 ref frame = calc
Sol_P2_Osim = [0.0044000000000000003 0.031 -0.0053];
P2.Sol = axis_reorder_foot(Sol_P2_Osim);

%% Tibialis Posterior (TP)
% Longest section of muscle is from P1 to P2
% Tib_Post_P1 ref frame = tibia
TP_P1_Osim = [-0.0041000000000000003 -0.13039999999999999 0.0103];
P1.TP = axis_reorder(TP_P1_Osim);
% Tib_Post_P1 ref frame = Calc
TP_P2_Osim = [0.077200000000000005 0.015900000000000001 -0.0281];
P2.TP = axis_reorder_foot(TP_P2_Osim);

%% Extensor Digitorum Longus (EDL)
% Longest section of muscle is from P1 to P2
% EDL_P1 ref frame = tibia
EDL_P1_Osim = [-0.016 -0.1157 0.020500000000000001];
P1.EDL = axis_reorder(EDL_P1_Osim);

%EDL_P2 ref frame = Calc
EDL_P2_Osim = [0.044299999999999999 -0.00040000000000000002 0.025000000000000001];
P2.EDL = axis_reorder_foot(EDL_P2_Osim);


%% Flexor Digitorum Longus (FDL)
% Longest section of muscle is from P1 to P2
% FDL_P1 ref frame = tibia
FDL_P1_Osim = [-0.0023 -0.1832 -0.0018];
P1.FDL = axis_reorder(FDL_P1_Osim);

%EDL_P2 ref frame = Calc
FDL_P2_Osim = [0.0441 -0.0060000000000000001 0.024199999999999999];
P2.FDL = axis_reorder_foot(FDL_P2_Osim);

%% Flexor Hallucis Longus (FHL)
% Longest section of muscle is from P1 to P2
% FHL_P1_ref frame = tibia
FHL_P1_Osim = [-0.031 -0.21629999999999999 0.02];
P1.FHL = axis_reorder(FHL_P1_Osim);

% FHL_P2 ref frame = Calc
FHL_P2_Osim = [0.0562 -0.010200000000000001 -0.018100000000000002];
P2.FHL = axis_reorder_foot(FHL_P2_Osim);

%% Peroneus Brevis (PB)
% Longest section of muscle is from P1 to P2
% PB_P1 ref frame = tibia
PB_P1_Osim = [-0.024299999999999999 -0.25319999999999998 0.025100000000000001];
P1.PB = axis_reorder(PB_P1_Osim);

% PB_P2 ref frame = Calc
PB_P2_Osim = [0.067699999999999996 0.021899999999999999 0.034299999999999997];
P2.PB = axis_reorder_foot(PB_P2_Osim);

%% Peroneus Longus (PL)
% Longest section of muscle is from P1 to P2
% PL_P1 ref frame = tibia
PL_P1_Osim = [-0.02 -0.13730000000000001 0.028199999999999999];
P1.PL = axis_reorder(PL_P1_Osim);

% PL_P2 ref frame = Calc
PL_P2_Osim = [0.1203 0.0085000000000000006 -0.0184];
P2.PL = axis_reorder_foot(PL_P2_Osim);

%% Extensor Hallucis Longus (EHL)
% Longest section of muscle is from P1 to P2
% EHL_P1 ref frame = tibia
EHL_P1_Osim = [-0.014 -0.155 0.0189];
P1.EHL = axis_reorder(EHL_P1_Osim);

% EHL_P2 ref frame = Calc
EHL_P2_Osim = [0.056300000000000003 0.0033999999999999998 -0.018599999999999998];
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

