clear all;
clc

Sub_val=struct('name', {}, 'RN_d',{},'RN_g',{}, 'SN_d', {}, 'SN_g', {}, 'STN_d', {}, 'STN_g', {}, 'cau_d', {}, 'cau_g', {}, 'Putamen_d', {}, 'Putamen_g', {}, 'GPe_d', {}, 'GPe_g', {}, 'GPi_d', {}, 'GPi_g', {}, 'Th_d', {}, 'Th_g', {}, 'CS_d', {}, 'CS_g', {});
Path2 = '/home/veronica/Donnees/ControlsPark/Last/';
Subj_dir= dir([ Path2 '*']);
Subj_dir = Subj_dir(arrayfun(@(x) ~strcmp(x.name(1),'.'),Subj_dir));


for i = 1 : size(Subj_dir,1)
    if Subj_dir(i,1).isdir==1
    disp(['Extracting data from ' Subj_dir(i,1).name]); 
    Atlas=niftiread(fullfile(Path2, Subj_dir(i,1).name, 'def3PD25-subcortical-complete.nii'));
    Seg=categorical(Atlas,[0:20],{'Other','RN_l','RN_r','SN_l','SN_r', 'STN_l','STN_r', 'Cau_l','Cau_r','Putamen_l', 'Putamen_r','GPe_l','GPe_r','GPi_l','GPi_r','Th_l','Th_r','CS_l','CS_r','CI_l','CI_r'});
    Seg(Seg=='1')='RN_g';
    
%     if exist(fullfile(Path2, Subj_dir(i,1).name, 'FGATIR', 'rc3d_FGATIR.nii'), 'file') ~= 0  
%         Orig=niftiread(fullfile(Path2, Subj_dir(i,1).name, 'Anat', 'rAnat.nii'));
% 
%         % imtool(Seg_MNI(:,:,62),'DisplayRange',[]);
%         %%Segmentation du Red Nucleus
%         s.RN_d=Orig;
%         s.RN_d(Atlas~=2)=0;
%         s.RN_g=Orig;
%         s.RN_g(Atlas~=1)=0;
%         %%Segmentation de la Substantia Nigra
%         s.SN_d=Orig;
%         s.SN_d(Atlas~=4)=0;
%         s.SN_g=Orig;
%         s.SN_g(Atlas~=3)=0;
%         %%Segmentation du Subthalamic Nucleus
%         s.STN_d=Orig;
%         s.STN_d(Atlas~=6)=0;
%         s.STN_g=Orig;
%         s.STN_g(Atlas~=5)=0;
%         %%Segmentation des caudates
%         s.cau_d=Orig;
%         s.cau_d(Atlas~=8)=0;
%         s.cau_g=Orig;
%         s.cau_g(Atlas~=7)=0;
%         %%Segmentation du putamen
%         s.Putamen_d=Orig;
%         s.Putamen_d(Atlas~=10)=0;
%         s.Putamen_g=Orig;
%         s.Putamen_g(Atlas~=9)=0;
%         %%Segmentation du Globus Pallidus externa et interna
%         s.GPe_d=Orig;
%         s.GPe_d(Atlas~=12)=0;
%         s.GPe_g=Orig;
%         s.GPe_g(Atlas~=11)=0;
%         s.GPi_d=Orig;
%         s.GPi_d(Atlas~=14)=0;
%         s.GPi_g=Orig;
%         s.GPi_g(Atlas~=13)=0;
%         %%Segmentation du Thalamus
%         s.Th_d=Orig;
%         s.Th_d(Atlas~=16)=0;
%         s.Th_g=Orig;
%         s.Th_g(Atlas~=15)=0;
% 
%         %%Segmentation du Colliculus Sup�rieur
%         s.CS_d=Orig;
%         s.CS_d(Atlas~=18)=0;
%         s.CS_g=Orig;
%         s.CS_g(Atlas~=17)=0;
%         %cau_d(find(cau_d))
% 
%     %     val(end+1)=s;
%     %     A.name=Subjects_dir(i,1).name;
%     %     A.val=val;
%     %     Sub_anat(end+1)=A;
%         s.name=Subj_dir(i,1).name;
%         Sub_val(end+1)=s;
%         disp('Done');
    end
    end
end