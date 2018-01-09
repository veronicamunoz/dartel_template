clear all;
clc
% Path = '/media/veronica/DATAPART1/Documents/MATLAB/';
% Path2 = '/media/veronica/DATAPART1/Donnees/PatientsPark/';
Path = 'D:/Documents/MATLAB/';
Path2 = 'D:/Donnees/ControlsPark/';
cd(Path2)
addpath([Path 'spm12/']);% Ajoute les fonctions et sous fonctions dans le Path

Subjects_dir= dir([ Path2 '*']);
Subjects_dir = Subjects_dir(arrayfun(@(x) ~strcmp(x.name(1),'.'),Subjects_dir));% pour supprimer les . et .. du rÃ©sultat du dir

%% Segmentation pour récuperer le champ de transformation inverse (iy)
for i = 1 : size(Subjects_dir,1)
    folder_path=fullfile(Path2, Subjects_dir(i,1).name);
    if (Subjects_dir(i,1).isdir==1) && (exist(fullfile(folder_path,'Anat'), 'dir')~=0) 
        clear matlabbatch
        spm_jobman('initcfg');

        matlabbatch{1}.spm.spatial.preproc.channel.vols = {[fullfile(folder_path,'Anat', 'Anat.nii') ',1']};
        matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
        matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
        matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'D:\Documents\MATLAB\spm12\tpm\TPM.nii,1'};
        matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
        matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'D:\Documents\MATLAB\spm12\tpm\TPM.nii,2'};
        matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
        matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'D:\Documents\MATLAB\spm12\tpm\TPM.nii,3'};
        matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
        matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'D:\Documents\MATLAB\spm12\tpm\TPM.nii,4'};
        matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
        matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'D:\Documents\MATLAB\spm12\tpm\TPM.nii,5'};
        matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
        matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'D:\Documents\MATLAB\spm12\tpm\TPM.nii,6'};
        matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
        matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
        matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
        matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
        matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
        matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
        matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
        matlabbatch{1}.spm.spatial.preproc.warp.write = [1 1];
        
       spm('defaults', 'FMRI');
       spm_jobman('run', matlabbatch);
       clear matlabbatch
            
    end
end

%% Normalisation de du template Collins et de son atlas avec iy 
for i = 1 : size(Subjects_dir,1)
    folder_path=fullfile(Path2, Subjects_dir(i,1).name);
    if (Subjects_dir(i,1).isdir==1) && (exist(fullfile(folder_path,'Anat'), 'dir')~=0) 
        clear matlabbatch
        spm_jobman('initcfg');
        
        matlabbatch{1}.spm.spatial.normalise.write.subj.def = {fullfile(folder_path,'Anat', 'iy_Anat.nii')};
        matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {[fullfile(folder_path,'MNI_Collins.nii') ',1']};
        matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                                  78 76 85];
        matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [1 1 1];
        matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
        matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'T1_';
        
        matlabbatch{2}.spm.spatial.normalise.write.subj.def = {fullfile(folder_path,'Anat', 'iy_Anat.nii')};
        matlabbatch{2}.spm.spatial.normalise.write.subj.resample = {[fullfile(folder_path,'MNI_Collins_atlas.nii') ',1']};
        matlabbatch{2}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                                  78 76 85];
        matlabbatch{2}.spm.spatial.normalise.write.woptions.vox = [1 1 1];
        matlabbatch{2}.spm.spatial.normalise.write.woptions.interp = 0;
        matlabbatch{2}.spm.spatial.normalise.write.woptions.prefix = 'T1_';
             
       spm('defaults', 'FMRI');
       spm_jobman('run', matlabbatch);
       clear matlabbatch
            
    end
end

%% Recoupage de la séquence original vers le template Collins dans l'espace patient
for i = 1 : size(Subjects_dir,1)
        folder_path=fullfile(Path2, Subjects_dir(i,1).name);
    if (Subjects_dir(i,1).isdir==1) && (exist(fullfile(folder_path,'Anat'), 'dir')~=0) 
        if exist(fullfile(folder_path,'T1_Collins_atlas.nii'), 'file') == 0
            movefile(fullfile(folder_path,'T1_MNI_Collins.nii'), fullfile(folder_path,'T1_Collins.nii'));
            movefile(fullfile(folder_path,'T1_MNI_Collins_atlas.nii'), fullfile(folder_path,'T1_Collins_atlas.nii'));
        end
        
        clear matlabbatch
        spm_jobman('initcfg');
        
        matlabbatch{1}.spm.spatial.coreg.write.ref = {[fullfile(folder_path, 'T1_Collins.nii'), ',1']};
        matlabbatch{1}.spm.spatial.coreg.write.source = {[fullfile(folder_path, 'Anat', 'Anat.nii') ',1']};
        matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
        matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
        matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';

       spm('defaults', 'FMRI');
       spm_jobman('run', matlabbatch);
       clear matlabbatch
            
    end
end