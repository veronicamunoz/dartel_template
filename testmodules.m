
clear matlabbatch
spm_jobman('initcfg');

matlabbatch{1}.spm.spatial.preproc.channel(1).vols = {'/home/veronica/Donnees/PatientsPark/rSignaPark2_image.nii,1'};
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'/home/veronica/Documents/MATLAB/spm12/tpm/TPM.nii,1'};
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'/home/veronica/Documents/MATLAB/spm12/tpm/TPM.nii,2'};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'/home/veronica/Documents/MATLAB/spm12/tpm/TPM.nii,3'};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'/home/veronica/Documents/MATLAB/spm12/tpm/TPM.nii,4'};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'/home/veronica/Documents/MATLAB/spm12/tpm/TPM.nii,5'};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'/home/veronica/Documents/MATLAB/spm12/tpm/TPM.nii,6'};
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

clear matlabbatch
spm_jobman('initcfg');
matlabbatch{1}.spm.util.defs.comp{1}.def = {'/home/veronica/Donnees/mni_PD25/y_PD25-fusion-template-1mm.nii'};
matlabbatch{1}.spm.util.defs.comp{2}.def = {'/home/veronica/Donnees/PatientsPark/iy_rSignaPark2_image.nii'};
matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {'/home/veronica/Donnees/mni_PD25/PD25-subcortical-complete.nii'};
matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savesrc = 1;
matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 0;
matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = 'rdef3SP2';
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);
clear matlabbatch

%     clear matlabbatch
%     spm_jobman('initcfg');
%     matlabbatch{1}.spm.spatial.coreg.write.ref = {'/home/veronica/Donnees/mni_PD25/PD25-fusion-template-1mm.nii'};
%     matlabbatch{1}.spm.spatial.coreg.write.source = {'/home/veronica/Donnees/PatientsPark/def3SP2PD25-subcortical-complete.nii'};
%     matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
%     matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
%     matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
%     matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';
%     spm('defaults', 'FMRI');
%     spm_jobman('run',matlabbatch);
%     clear matlabbatch
