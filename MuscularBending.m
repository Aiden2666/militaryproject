%% BENDING MOMENTS DUE TO MUSCULAR FORCES

% Angle between two vectors does not give an indication of the direction
% (positive or negative)

for m=1:length(muscles)
%     if P1.(muscles{m})(2)>0.01 %to allow for PL which is a plantar flexor
%         MuscBending_sh_AP.(muscles{m})=(-F_sh_AP.(muscles{m}))*Shank_length_ankle_CS;      
%     else 
        MuscBending_sh_AP.(muscles{m})=(F_sh_AP.(muscles{m}))*Shank_length_ankle_CS;            
%     end
    MuscBending_comp_AP.(muscles{m})=(F_comp_AP.(muscles{m}))*0;
end 
            
MuscBending_sh_AP_all=0; MuscBending_comp_AP_all=0;

for m=1:length(muscles)
    MuscBending_sh_AP_all=MuscBending_sh_AP.(muscles{m})+MuscBending_sh_AP_all;
    MuscBending_comp_AP_all=MuscBending_comp_AP.(muscles{m})+MuscBending_comp_AP_all;
end 

Output.MuscBend.Sum.Shear(:,t)=MuscBending_sh_AP_all;
Output.MuscBend.Sum.Comp(:,t)=MuscBending_comp_AP_all;



