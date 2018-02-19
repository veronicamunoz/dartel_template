clear all;
close all;


Anat_path = '/home/veronica/Donnees/PatientsPark/';
Perf_path = '/home/veronica/Donnees/PerfusionPark/';
Diff_path = '/home/veronica/Donnees/DTIPark/Park/';

% Anat_path = '/home/veronica/Donnees/ControlsPark/Last/';
% Perf_path = '/home/veronica/Donnees/PerfusionControls/';
% Diff_path = '/home/veronica/Donnees/DTIPark/Control/';
Atlas_path = '/home/veronica/Donnees/mni_PD25/PD25-fusion-template-1mm.nii';
Subj_dir = dir([Anat_path '*']);
Subj_dir = Subj_dir(arrayfun(@(x) ~strcmp(x.name(1),'.'),Subj_dir));

C3Dcommand='/home/veronica/Downloads/Programs/c3d/bin/c3d ';
% C3Dcommand='C:/"Program Files"/Convert3D/bin/c3d.exe ';

for i = 1 : size(Subj_dir,1)
disp(Subj_dir(i,1).name);
%à regarder s'il ne serait pas mieux de tout récaler sur rAnat, or rAnat produit de Coregister:Reslice de Anat sur PD25 fusion template
t1_path=fullfile(Anat_path, Subj_dir(i,1).name, 'Anat', 'Anat.nii');

if (Subj_dir(i,1).isdir==1 && exist(t1_path, 'file') ~= 0)
    
    clear matlabbatch
    spm_jobman('initcfg');
    matlabbatch{1}.spm.spatial.coreg.write.ref = {Atlas_path};
    matlabbatch{1}.spm.spatial.coreg.write.source = {t1_path};
    matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';
    spm('defaults', 'FMRI');
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    t1_path=fullfile(Anat_path, Subj_dir(i,1).name, 'Anat', 'rAnat.nii');
%     disp('---t1 recoupee');
    
    % FGATIR (Resampling + Coregister)
    fgatir_path=fullfile(Anat_path, Subj_dir(i,1).name, 'FGATIR');
    if exist(fullfile(fgatir_path, 'FGATIR.nii'), 'file') ~= 0
%         system([C3Dcommand fullfile(fgatir_path, 'FGATIR.nii') ' -resample-mm 1.0x1.0x1.0mm -o ' fullfile(fgatir_path, 'c3d_FGATIR.nii')]);
        
        clear matlabbatch
        spm_jobman('initcfg');
        matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {t1_path};
        matlabbatch{1}.spm.spatial.coreg.estwrite.source = {fullfile(fgatir_path, 'c3d_FGATIR.nii')};
        matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 0;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r2';
       spm('defaults', 'FMRI');
       spm_jobman('run', matlabbatch);
       clear matlabbatch
       disp('---FGATIR coregistree');
    end
    
    % PERFUSION (Resamplig + Coregister)
    cbf_path=fullfile(Perf_path, Subj_dir(i,1).name, 'pcasl');
    if exist(fullfile(cbf_path, 'cbf_map.nii'), 'file') ~= 0
%         system([C3Dcommand fullfile(cbf_path, 'cbf_map.nii') ' -resample-mm 1.0x1.0x1.0mm -o ' fullfile(cbf_path, 'c3d_CBF.nii')]);
        clear matlabbatch
        spm_jobman('initcfg');
        matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {t1_path};
        matlabbatch{1}.spm.spatial.coreg.estwrite.source = {fullfile(cbf_path, 'c3d_CBF.nii')};
        matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 0;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r2';
       spm('defaults', 'FMRI');
       spm_jobman('run', matlabbatch);
       clear matlabbatch
       disp('---Carte CBF coregistree');
    end
    % DIFFUSION (Resamplig + Coregister)
    dti_path=fullfile(Diff_path, Subj_dir(i,1).name, 'DTI');
    if exist(fullfile(dti_path, 'dti_MD.nii'), 'file') ~= 0
%         system([C3Dcommand fullfile(dti_path, 'dti_MD.nii') ' -resample-mm 1.0x1.0x1.0mm -o ' fullfile(dti_path, 'c3d_MD.nii')]);
                clear matlabbatch
        spm_jobman('initcfg');
        matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {t1_path};
        matlabbatch{1}.spm.spatial.coreg.estwrite.source = {fullfile(dti_path, 'c3d_MD.nii')};
        matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 0;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r2';
       spm('defaults', 'FMRI');
       spm_jobman('run', matlabbatch);
       clear matlabbatch
       disp('---Carte MD coregistree');
    end
    if exist(fullfile(dti_path, 'dti_FA.nii'), 'file') ~= 0
%         system([C3Dcommand fullfile(dti_path, 'dti_FA.nii') ' -resample-mm 1.0x1.0x1.0mm -o ' fullfile(dti_path, 'c3d_FA.nii')]);
        clear matlabbatch
        spm_jobman('initcfg');
        matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {t1_path};
        matlabbatch{1}.spm.spatial.coreg.estwrite.source = {fullfile(dti_path, 'c3d_FA.nii')};
        matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 0;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r2';
       spm('defaults', 'FMRI');
       spm_jobman('run', matlabbatch);
       clear matlabbatch
       disp('---Carte FA coregistree');
    end
end
end