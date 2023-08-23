
% a1=10.08/1000; a2=23.22/1000;
% b1=9.76/1000; b2=29.32/1000;
%Outer diameters: 23.22 mm (ML)
%                 29.32 mm (AP)
%Inner diameters: 10.08 mm (ML)
%                 9.76 mm (AP)

%Moment of Inertia of Hollow Ellipse 
Ix=(pi/4)*(((OuterML*(OuterAP^3))-(InnerML*(InnerAP^3)))); %Moment of inertia for bending around the ML axis
Iy=(pi/4)*((((OuterML^3)*OuterAP)-((InnerML^3)*InnerAP))); %Moment of inertia for bending around the AP axis

Output.Geometry.Ix(t)=Ix;
Output.Geometry.Iy(t)=Iy;

%% Calculate axial and shear forces
F_axial_AP=F_ANK_rot(:,3)+F_musc_axial; %(-ve reaction forces) 
F_shear_AP=F_ANK_rot(:,2)+F_musc_shear; 

Output.Force.Reaction=-F_ANK_rot;
Output.Force.Axial(:,t)=F_axial_AP;
Output.Force.Shear(:,t)=F_shear_AP;

%% Calculate axial stress
Stress_axial_AP=-F_axial_AP/CSA;% stress acting downwards
% Forces have been taken as upwards is positive 
Output.Stress.Axial(:,t)=Stress_axial_AP;

%% Calculate bending stress AP direction
Stress_be_AP=MBE_AP.*OuterAP/Ix;

Output.Stress.Bending(:,t)=Stress_be_AP;

%% tensile stress: positive 
%% compressive stress: negative

Stress_posterior=(Stress_axial_AP + Stress_be_AP)/1000000; %MPa
Stress_anterior=(Stress_axial_AP - Stress_be_AP)/1000000; %MPa

Output.Stress.Posterior(:,t)=Stress_posterior;
Output.Stress.Anterior(:,t)=Stress_anterior;

