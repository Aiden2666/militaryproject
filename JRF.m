%% JOINT REACTION FORCES
%Use equation for sum of forces
%sumForces_seg=mass_seg*accel_seg

%% ANKLE JOINT REACTION FORCE
%F_ank + F_grf - m_foot*gravity = m_foot*accel_foot
%F_ank = m_foot(accel_foot + gravity) - F_grf

for i=1:length(COM_foot_acc)
F_ank(1,:,i) = Mass_foot.(sex{s})*(COM_foot_acc(i,:) + g)- (Force(i,:));
end
F_a=squeeze(F_ank);

for i=1:101
    F_ank_rot(:,i)=Shank_rot(:,:)*-F_a(:,i);% Equal and opposite 
%Calculated at proximal foot and equal and opposite is at distal shank
end
F_ANK_rot=F_ank_rot';

JRF_comp_AP=F_ANK_rot(:,3)*0;
Output.Moments.JRF_comp(:,t)=JRF_comp_AP;

JRF_sh_AP=F_ANK_rot(:,2).*Shank_length_ankle_CS;
Output.Moments.JRF_sh(:,t)=JRF_sh_AP;


