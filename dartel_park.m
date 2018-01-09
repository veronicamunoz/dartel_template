clear all;
clc
% Path = '/media/veronica/DATAPART1/Documents/MATLAB/';
% Path2 = '/media/veronica/DATAPART1/Donnees/PatientsPark/';
Path = 'D:/Documents/MATLAB/';
Path2 = 'D:/Donnees/ControlsPark/';
cd(Path2)
addpath([Path 'spm12/']);% Ajoute les fonctions et sous fonctions dans le Path

Subjects_dir= dir([ Path2 '*']);
Subjects_dir = Subjects_dir(arrayfun(@(x) ~strcmp(x.name(1),'.'),Subjects_dir));% pour supprimer les . et .. du résultat du dir

for i = 1 : size(Subjects_dir,1)
    if Subjects_dir(i,1).isdir==1
        Seq_Anat=rdir([Path2 Subjects_dir(i,1).name '/Anat/Anat.nii']);
        Seq_Anat = Seq_Anat(arrayfun(@(x) ~strcmp(x.name(1),'.'),Seq_Anat));
        
        clear matlabbatch
        spm_jobman('initcfg');

        matlabbatch{1}.spm.tools.oldseg.data = {[Seq_Anat(1,1).folder '\' Seq_Anat(1,1).name ',1']};
        matlabbatch{1}.spm.tools.oldseg.output.GM = [0 0 1];
        matlabbatch{1}.spm.tools.oldseg.output.WM = [0 0 1];
        matlabbatch{1}.spm.tools.oldseg.output.CSF = [0 0 0];
        matlabbatch{1}.spm.tools.oldseg.output.biascor = 1;
        matlabbatch{1}.spm.tools.oldseg.output.cleanup = 0;
        matlabbatch{1}.spm.tools.oldseg.opts.tpm = {
                                                    'D:\Documents\MATLAB\spm12\toolbox\OldSeg\grey.nii'
                                                    'D:\Documents\MATLAB\spm12\toolbox\OldSeg\white.nii'
                                                    'D:\Documents\MATLAB\spm12\toolbox\OldSeg\csf.nii'
                                                    };
        matlabbatch{1}.spm.tools.oldseg.opts.ngaus = [2
                                                      2
                                                      2
                                                      4];
        matlabbatch{1}.spm.tools.oldseg.opts.regtype = 'mni';
        matlabbatch{1}.spm.tools.oldseg.opts.warpreg = 1;
        matlabbatch{1}.spm.tools.oldseg.opts.warpco = 25;
        matlabbatch{1}.spm.tools.oldseg.opts.biasreg = 0.0001;
        matlabbatch{1}.spm.tools.oldseg.opts.biasfwhm = 60;
        matlabbatch{1}.spm.tools.oldseg.opts.samp = 3;
        matlabbatch{1}.spm.tools.oldseg.opts.msk = {''};
        matlabbatch{2}.spm.tools.dartel.initial.matnames(1) = cfg_dep('Old Segment: Norm Params Subj->MNI', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','snfile', '()',{':'}));
        matlabbatch{2}.spm.tools.dartel.initial.odir = {Seq_Anat(1,1).folder};
        matlabbatch{2}.spm.tools.dartel.initial.bb = [NaN NaN NaN
                                                      NaN NaN NaN];
        matlabbatch{2}.spm.tools.dartel.initial.vox = 1;
        matlabbatch{2}.spm.tools.dartel.initial.image = 0;
        matlabbatch{2}.spm.tools.dartel.initial.GM = 1;
        matlabbatch{2}.spm.tools.dartel.initial.WM = 1;
        matlabbatch{2}.spm.tools.dartel.initial.CSF = 0;
        
       spm('defaults', 'FMRI');
       spm_jobman('run', matlabbatch);
       clear matlabbatch    
    end
end


