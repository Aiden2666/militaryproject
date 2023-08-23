g=[0,0,-9.81]; %gravity vector
%%Anthropometric Parameters from Shan & Bohn 2003. (German Males and Females)
%Note that segment COM are distance from the proximal to the distal

%% Foot
%Male
COM_foot_percent.(sex{1})=0.451;
Mass_coeff_foot.(sex{1})=[-2.25 0.001 0.0182 0.74];
Length_coeff_foot.(sex{1})=[3.80 0.013 0.119 0.64];

%Female
COM_foot_percent.(sex{2})=0.461;
Mass_coeff_foot.(sex{2})=[-1.27 0.0045 0.0104 0.78];
Length_coeff_foot.(sex{2})=[7.39 0.0311 0.0867 0.65];

%% Shank
%Male
COM_shank_percent.(sex{1})=0.464;
Mass_coeff_shank.(sex{1})=[-3.53 0.0306 0.0268 0.81];
Length_coeff_shank.(sex{1})=[-16.0 0.0218 0.321 0.88];

%Female
COM_shank_percent.(sex{2})=0.463;
Mass_coeff_shank.(sex{2})=[-0.563 0.0191 0.0141 0.56];
Length_coeff_shank.(sex{2})=[-7.21 -0.0618 0.308 0.88];

%% Thigh
%Male
COM_thigh_percent.(sex{1})=0.322;
Mass_coeff_thigh.(sex{1})=[1.18 0.182 -0.0259 0.90];
Length_coeff_thigh.(sex{1})=[4.26 -0.0183 0.240 0.55];

%Female
COM_thigh_percent.(sex{2})=0.303;
Mass_coeff_thigh.(sex{2})=[-10.9 0.213 0.0380 0.94];
Length_coeff_thigh.(sex{2})=[-26.8 -0.0725 0.436 0.76];

%% Calculate participant anthropometric measures using above coefficients
%Foot
%Male
Mass_foot.(sex{1})=(Mass_coeff_foot.(sex{1})(1) + Mass_coeff_foot.(sex{1})(2)*Mass + Mass_coeff_foot.(sex{1})(3)*(Height*100));
Length_foot.(sex{1})=(Length_coeff_foot.(sex{1})(1) + Length_coeff_foot.(sex{1})(2)*Mass + Length_coeff_foot.(sex{1})(3)*(Height*100))*10^-2;
%Female
Mass_foot.(sex{2})=(Mass_coeff_foot.(sex{2})(1) + Mass_coeff_foot.(sex{2})(2)*Mass + Mass_coeff_foot.(sex{2})(3)*(Height*100));
Length_foot.(sex{2})=(Length_coeff_foot.(sex{2})(1) + Length_coeff_foot.(sex{2})(2)*Mass + Length_coeff_foot.(sex{2})(3)*(Height*100))*10^-2;
%note this has been converted into metres%
Weight_foot=Mass_foot.(sex{s})*g;
COM_footlength=[0;0;COM_foot_percent.(sex{s})*Length_foot.(sex{s})];

%Shank
%Male
Mass_shank.(sex{1})=(Mass_coeff_shank.(sex{1})(1) + Mass_coeff_shank.(sex{1})(2)*Mass + Mass_coeff_shank.(sex{1})(3)*(Height*100));
Length_shank.(sex{1})=(Length_coeff_shank.(sex{1})(1) + Length_coeff_shank.(sex{1})(2)*Mass + Length_coeff_shank.(sex{1})(3)*(Height*100))*10^-2;
%note this has been converted into metres%
Mass_shank.(sex{2})=(Mass_coeff_shank.(sex{2})(1) + Mass_coeff_shank.(sex{2})(2)*Mass + Mass_coeff_shank.(sex{2})(3)*(Height*100));
Length_shank.(sex{2})=(Length_coeff_shank.(sex{2})(1) + Length_coeff_shank.(sex{2})(2)*Mass + Length_coeff_shank.(sex{2})(3)*(Height*100))*10^-2;
%note this has been converted into metres%
Weight_shank=Mass_shank.(sex{s})*g;
COM_shanklength=[0;0;COM_shank_percent.(sex{s})*Length_shank.(sex{s})];

Length_thigh.(sex{1})=(Length_coeff_thigh.(sex{1})(1) + Length_coeff_thigh.(sex{1})(2)*Mass + Length_coeff_thigh.(sex{1})(3)*(Height*100))*10^-2;
Length_thigh.(sex{2})=(Length_coeff_thigh.(sex{2})(1) + Length_coeff_thigh.(sex{2})(2)*Mass + Length_coeff_thigh.(sex{2})(3)*(Height*100))*10^-2;

% Determine length from the ankle to the tibia CS of interest
Shank_length_ankle_CS=CSA_loc*Length_shank.(sex{s});

%Segment COMs are defined in local coordinate system%
%Rotate into GCS

 for i=1:101
     % COM_footlength is a translation in LCS, and this needs to be rotated
     % into GCS so it can be added to the segment origin which is in GCS
    COM_foot_rot=Foot_rot*COM_footlength;
    COM_foot(i,:)=CALC(i,:)+COM_foot_rot';

    COM_shank_rot=Shank_rot*COM_shanklength;
    COM_shank(i,:)=MidKnee(i,:)-COM_shank_rot';
 end
 
% COM_foot_sq=squeeze(COM_foot_1);
% COM_shank_sq=squeeze(COM_shank_1);
% COM_foot=COM_foot_sq';
% COM_shank=COM_shank_sq';
 

for ii=1:length(COM_foot)-2
    %Use finite difference method for velocity
    COM_foot_vel(ii,:)=(COM_foot(ii+2,:)-COM_foot(ii,:))/(2*(1/Marker_Freq));
    COM_shank_vel(ii,:)=(COM_shank(ii+2,:)-COM_shank(ii,:))/(2*(1/Marker_Freq));
end


COM_foot_acc=nan(101,3);
COM_shank_acc=nan(101,3);
for iii=3:length(COM_foot_vel)
    %Use finite difference method for velocity
    COM_foot_acc(iii,:)=(COM_foot_vel(iii,:)-COM_foot_vel(iii-2,:))/(2*(1/Marker_Freq));
    COM_shank_acc(iii,:)=(COM_shank_vel(iii,:)-COM_shank_vel(iii-2,:))/(2*(1/Marker_Freq));
end


%% Pad the array to maintain 101 points

COM_foot_acc(1,:)= COM_foot_acc(3,:); COM_foot_acc(2,:) = COM_foot_acc(3,:);
COM_foot_acc(100,:)= COM_foot_acc(99,:); COM_foot_acc(101,:) = COM_foot_acc(99,:);

COM_shank_acc(1,:)= COM_shank_acc(3,:); COM_shank_acc(2,:) = COM_shank_acc(3,:);
COM_shank_acc(100,:)= COM_shank_acc(99,:); COM_shank_acc(101,:) = COM_shank_acc(99,:);

% COM_foot_acc=movmean(COM_foot_acc,9);
% COM_shank_acc=movmean(COM_shank_acc,9);
