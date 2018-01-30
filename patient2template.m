clear all;
close all;

Anat_path = '/home/veronica/Donnees/PatientsPark/';
Subj_dir = dir([Anat_path '*']);
Subj_dir = Subj_dir(arrayfun(@(x) ~strcmp(x.name(1),'.'),Subj_dir));


for i = 1 : size(Subj_dir,1)
    disp(Subj_dir(i,1).name);
    dartelFlow=fullfile(Anat_path, Subj_dir(i,1).name, 'Anat', 'u_rc1Anat_SignaPark2.nii');
    
    if (Subj_dir(i,1).isdir==1 && exist(dartelFlow, 'file') ~= 0)
%         clear matlabbatch
%         spm_jobman('initcfg');
%         matlabbatch{1}.spm.util.defs.comp{1}.dartel.flowfield = {dartelFlow};
%         matlabbatch{1}.spm.util.defs.comp{1}.dartel.times = [1 0];
%         matlabbatch{1}.spm.util.defs.comp{1}.dartel.K = 6;
%         matlabbatch{1}.spm.util.defs.comp{1}.dartel.template = {'/home/veronica/Donnees/PatientsPark/AA-03/Anat/SignaPark2_6.nii'};
%         matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {fullfile(Anat_path, Subj_dir(i,1).name, 'Anat', 'Anat.nii')};
%         matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savesrc = 1;
%         matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 7;
%         matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
%         matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
%         matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = 'SP2_';
%         spm('defaults', 'FMRI');
%         spm_jobman('run', matlabbatch);
%         clear matlabbatch
        
          rc1(i)=fullfile(Anat_path, Subj_dir(i,1).name, 'Anat', 'SP2_Anat.nii');
    end
    
    
end

% clear matlabbatch
% spm_jobman('initcfg');
% matlabbatch{1}.spm.util.imcalc.input = {
%                                         '/home/veronica/Donnees/PatientsPark/VC-15/Anat/SP2_Anat.nii,1'
%                                         '/home/veronica/Donnees/PatientsPark/PT-05/Anat/SP2_Anat.nii,1'
%                                         '/home/veronica/Donnees/PatientsPark/PA-17/Anat/SP2_Anat.nii,1'
%                                         };
% matlabbatch{1}.spm.util.imcalc.output = 'output';
% matlabbatch{1}.spm.util.imcalc.outdir = {'/home/veronica/Donnees/PatientsPark'};
% matlabbatch{1}.spm.util.imcalc.expression = '(i1+i2+i3+i4...)';
% matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
% matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
% matlabbatch{1}.spm.util.imcalc.options.mask = 0;
% matlabbatch{1}.spm.util.imcalc.options.interp = -4;
% matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
% spm('defaults', 'FMRI');
% spm_jobman('run', matlabbatch);
% clear matlabbatch