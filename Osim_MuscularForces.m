%% MUSCULAR FORCES
% Calculate shear and compressive forces for each muscle, by resolving through the bone-muscle angle
% Explanation
    % Calculate sagittal plane angle between muscle line of action and the
    % tibia long axis
    %Angle between 2 3D vectors, R&S:
    % use theta = acos(R.S/(modR*modS)) where . refers to dot product

    
%% Calculate angle between muscle and tibia vectors

for m=1:length(muscles)
%     F.(muscles{m})=Fm(:,m+14);
    
    Vector.(muscles{m})= (Origin.(muscles{m})) - (Insertion.(muscles{m}));
    %Create 2D vectors to determine angle between them in the sagittal plane
    Vector_2D.(muscles{m})=Vector.(muscles{m})(:,2:3);
    Shank_Transformed=(MidKnee - MidAnkle)*Shank_rot;
    Vector_2D.shank = Shank_Transformed(:,2:3);

    for i=1:length(Vector.(muscles{m}))
        dotProd.(muscles{m})(i)=dot(Vector_2D.shank(i,:),Vector_2D.(muscles{m})(i,:));
        Norm_shank(i,:)=norm(Vector_2D.shank(i,:));
        Norm_musc.(muscles{m})(i,:)=norm(Vector_2D.(muscles{m})(i,:));
        Bone_muscle_angle.(muscles{m})(i,:)=acosd(dotProd.(muscles{m})(i)./(Norm_shank(i,:).*Norm_musc.(muscles{m})(i,:)));
    end

    F_comp_AP.(muscles{m})=F.(muscles{m}).*cosd(Bone_muscle_angle.(muscles{m}));
    F_sh_AP.(muscles{m})=F.(muscles{m}).*sind(Bone_muscle_angle.(muscles{m}));
    
    if P1.(muscles{m})(2)<0.001 %to allow for PL which is a plantar flexor
        F_sh_AP.(muscles{m})= - F_sh_AP.(muscles{m}); 
    end
        
    Output.Force.Muscular.(muscles{m})(:,t)=F.(muscles{m});
    Output.MuscBend.BoneMuscAngle.(muscles{m})(:)=Bone_muscle_angle.(muscles{m});
    Output.MuscForceResolved.Comp.(muscles{m})(:,t)=F_comp_AP.(muscles{m});
    Output.MuscForceResolved.Shear.(muscles{m})(:,t)=F_sh_AP.(muscles{m});

end

%% SUM OF ALL COMPRESSIVE MUSCLE FORCES 
F_musc_axial=0; F_musc_shear=0;

for m=1:length(muscles)
    F_musc_axial=F_comp_AP.(muscles{m})+F_musc_axial;
    F_musc_shear=F_sh_AP.(muscles{m})+F_musc_shear;   
end

Output.MuscForceResolved.Sum.axial(:,t)=F_musc_axial;
Output.MuscForceResolved.Sum.shear(:,t)=F_musc_shear;
