clear all;
clc
Path = '/home/veronica/Documents/MATLAB/';
Path2 = '/home/veronica/Donnees/PatientsPark/';
% Path = 'D:/Documents/MATLAB/';
% Path2 = 'D:/Donnees/PatientsPark/';
cd(Path2)
addpath([Path 'spm12/']);% Ajoute les fonctions et sous fonctions dans le Path

Subjects_dir= dir([ Path2 '*']);
Subjects_dir = Subjects_dir(arrayfun(@(x) ~strcmp(x.name(1),'.'),Subjects_dir));% pour supprimer les . et .. du résultat du dir
liste_anat={};
liste_fgatir={};

%% Segmentation pour recuperer le champ de transformation inverse (iy)
for i = 1 : size(Subjects_dir,1)
    folder_path=fullfile(Path2, Subjects_dir(i,1).name);
    if (Subjects_dir(i,1).isdir==1) && (exist(fullfile(folder_path,'Anat'), 'dir')~=0) && (exist(fullfile(folder_path,'FGATIR'), 'dir')~=0)
        liste_anat{end+1}=[folder_path '\Anat\Anat.nii,1'];
        liste_fgatir{end+1}=[folder_path '\FGATIR\rc3d_FGATIR.nii,1'];
    end
end

liste_anat=liste_anat';
liste_fgatir=liste_fgatir';

clear matlabbatch
spm_jobman('initcfg');

matlabbatch{1}.spm.spatial.preproc.channel(1).vols = liste_anat;
matlabbatch{1}.spm.spatial.preproc.channel(1).biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel(1).biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel(1).write = [0 0];
matlabbatch{1}.spm.spatial.preproc.channel(2).vols = liste_fgatir;
matlabbatch{1}.spm.spatial.preproc.channel(2).biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel(2).biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel(2).write = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'/home/veronica/Documents/MATLAB/spm12/tpm/TPM.nii,1'};
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 1];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 1];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'/home/veronica/Documents/MATLAB/spm12/tpm/TPM.nii,2'};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 1];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 1];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'/home/veronica/Documents/MATLAB/spm12/tpm/TPM.nii,3'};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 1];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 1];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'/home/veronica/Documents/MATLAB/spm12/tpm/TPM.nii,4'};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 1];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 1];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'/home/veronica/Documents/MATLAB/spm12/tpm/TPM.nii,5'};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 1];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 1];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'/home/veronica/Documents/MATLAB/spm12/tpm/TPM.nii,6'};
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [1 1];
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 1];
matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write = [1 1];
matlabbatch{2}.spm.tools.dartel.warp.images{1}(1) = cfg_dep('Segment: rc1 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{1}, '.','rc', '()',{':'}));
matlabbatch{2}.spm.tools.dartel.warp.images{2}(1) = cfg_dep('Segment: rc2 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{2}, '.','rc', '()',{':'}));
matlabbatch{2}.spm.tools.dartel.warp.images{3}(1) = cfg_dep('Segment: rc3 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{3}, '.','rc', '()',{':'}));
matlabbatch{2}.spm.tools.dartel.warp.settings.template = 'SignaPark2';
matlabbatch{2}.spm.tools.dartel.warp.settings.rform = 0;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).rparam = [4 2 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).K = 0;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).slam = 16;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).rparam = [2 1 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).K = 0;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).slam = 8;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).rparam = [1 0.5 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).K = 1;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).slam = 4;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).rparam = [0.5 0.25 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).K = 2;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).slam = 2;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).rparam = [0.25 0.125 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).K = 4;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).slam = 1;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).rparam = [0.25 0.125 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).K = 6;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).slam = 0.5;
matlabbatch{2}.spm.tools.dartel.warp.settings.optim.lmreg = 0.01;
matlabbatch{2}.spm.tools.dartel.warp.settings.optim.cyc = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.optim.its = 3;



spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);
clear matlabbatch

% for i = 1 : size(Subjects_dir,1)
%     folder_path=fullfile(Path2, Subjects_dir(i,1).name);
%     if (Subjects_dir(i,1).isdir==1) && (exist(fullfile(folder_path,'Anat'), 'dir')~=0) 
%         
%         a=4+i;
%         clear matlabbatch
%         spm_jobman('initcfg');
% 
%         matlabbatch{1}.spm.spatial.preproc.channel.vols = {[fullfile(folder_path,'Anat', 'Anat.nii') ',1']};
%         matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
%         matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
%         matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
%         matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'D:\Documents\MATLAB\spm12\tpm\TPM.nii,1'};
%         matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
%         matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
%         matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
%         matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'D:\Documents\MATLAB\spm12\tpm\TPM.nii,2'};
%         matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
%         matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
%         matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
%         matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'D:\Documents\MATLAB\spm12\tpm\TPM.nii,3'};
%         matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
%         matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
%         matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
%         matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'D:\Documents\MATLAB\spm12\tpm\TPM.nii,4'};
%         matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
%         matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
%         matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
%         matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'D:\Documents\MATLAB\spm12\tpm\TPM.nii,5'};
%         matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
%         matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
%         matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
%         matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'D:\Documents\MATLAB\spm12\tpm\TPM.nii,6'};
%         matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
%         matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
%         matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
%         matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
%         matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
%         matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
%         matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
%         matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
%         matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
%         matlabbatch{1}.spm.spatial.preproc.warp.write = [1 1];
%         
%        spm('defaults', 'FMRI');
%        spm_jobman('run', matlabbatch);
%        clear matlabbatch
%             
%     end
% end

%% Normalisation de du template Collins et de son atlas avec iy 
% for i = 1 : size(Subjects_dir,1)
%     folder_path=fullfile(Path2, Subjects_dir(i,1).name);
%     if (Subjects_dir(i,1).isdir==1) && (exist(fullfile(folder_path,'Anat'), 'dir')~=0) 
%         clear matlabbatch
%         spm_jobman('initcfg');
%         
%         matlabbatch{1}.spm.spatial.normalise.write.subj.def = {fullfile(folder_path,'Anat', 'iy_Anat.nii')};
%         matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {[fullfile(folder_path,'MNI_Collins.nii') ',1']};
%         matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
%                                                                   78 76 85];
%         matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [1 1 1];
%         matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
%         matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'T1_';
%         
%         matlabbatch{2}.spm.spatial.normalise.write.subj.def = {fullfile(folder_path,'Anat', 'iy_Anat.nii')};
%         matlabbatch{2}.spm.spatial.normalise.write.subj.resample = {[fullfile(folder_path,'MNI_Collins_atlas.nii') ',1']};
%         matlabbatch{2}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
%                                                                   78 76 85];
%         matlabbatch{2}.spm.spatial.normalise.write.woptions.vox = [1 1 1];
%         matlabbatch{2}.spm.spatial.normalise.write.woptions.interp = 0;
%         matlabbatch{2}.spm.spatial.normalise.write.woptions.prefix = 'T1_';
%              
%        spm('defaults', 'FMRI');
%        spm_jobman('run', matlabbatch);
%        clear matlabbatch
%             
%     end
% end
% 
% %% Recoupage de la s�quence original vers le template Collins dans l'espace patient
% for i = 1 : size(Subjects_dir,1)
%         folder_path=fullfile(Path2, Subjects_dir(i,1).name);
%     if (Subjects_dir(i,1).isdir==1) && (exist(fullfile(folder_path,'Anat'), 'dir')~=0) 
%         if exist(fullfile(folder_path,'T1_Collins_atlas.nii'), 'file') == 0
%             movefile(fullfile(folder_path,'T1_MNI_Collins.nii'), fullfile(folder_path,'T1_Collins.nii'));
%             movefile(fullfile(folder_path,'T1_MNI_Collins_atlas.nii'), fullfile(folder_path,'T1_Collins_atlas.nii'));
%         end
%         
%         clear matlabbatch
%         spm_jobman('initcfg');
%         
%         matlabbatch{1}.spm.spatial.coreg.write.ref = {[fullfile(folder_path, 'T1_Collins.nii'), ',1']};
%         matlabbatch{1}.spm.spatial.coreg.write.source = {[fullfile(folder_path, 'Anat', 'Anat.nii') ',1']};
%         matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
%         matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
%         matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
%         matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';
% 
%        spm('defaults', 'FMRI');
%        spm_jobman('run', matlabbatch);
%        clear matlabbatch
%             
%     end
% end