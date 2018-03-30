clear all;
close all;

Anat_path = '/home/veronica/Donnees/PatientsPark/';
Perf_path = '/home/veronica/Donnees/PerfusionPark/';
Diff_path = '/home/veronica/Donnees/DTIPark/Park/';
% Perf_path = '/home/veronica/Donnees/PerfusionControls/';
% Diff_path = '/home/veronica/Donnees/DTIPark/Control/';
% Anat_path = '/home/veronica/Donnees/ControlsPark/Last/';
Subj_dir = dir([Diff_path '*']);
Subj_dir = Subj_dir(arrayfun(@(x) ~strcmp(x.name(1),'.'),Subj_dir));
Data = []; Info = []; ROI = [];

%Ecrire le titre pour bien commencer
t2={'Group', 'Patient', 'VOI', 'Coord_X', 'Coord_Y', 'Coord_Z', 'CBF', 'FA', 'MD'};
commaHeader = [t2;repmat({','},1,numel(t2))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas

%write header to file
fid = fopen('/home/veronica/Donnees/Patients_3_onlysub2.csv','w'); 
fprintf(fid,'%s\n',textHeader)
fclose(fid)

for i = [7 13 14]%1 : 3 %1:size(Subj_dir,1)  %[7 13 14]%
    perf=fullfile(Perf_path, Subj_dir(i,1).name ,'pcasl', 'r2c3d_CBF.nii');
    FA=fullfile(Diff_path, Subj_dir(i,1).name, 'DTI', 'r2c3d_FA.nii');
    MD=fullfile(Diff_path, Subj_dir(i,1).name, 'DTI', 'r2c3d_MD.nii');
    SEG=fullfile(Anat_path, Subj_dir(i,1).name, 'def3PD25-subcortical-complete.nii');
    if (Subj_dir(i,1).isdir==1) && (exist(perf, 'file')~=0) && (exist(FA,'file')~=0) && (exist(MD,'file')~=0)
    %if (Subj_dir(i,1).isdir==1) && (exist(FA,'file')~=0) && (exist(MD,'file')~=0)
        disp(['Extracting data from ' Subj_dir(i,1).name]); 
        %t1=niftiread(anat);
        cbf=niftiread(perf);
        fa=niftiread(FA);
        md=niftiread(MD);
        seg=niftiread(SEG);
        
        %imtool(t1(:,:,2),'DisplayRange',[]); 
        sizeX=size(fa,1); sizeY=size(fa,2); sizeZ=size(fa,3); %taille des dimensions
        arrX = 1:1:sizeX; arrY = 1:1:sizeY; arrZ = 1:1:sizeZ; %tous les index

        % Construction des trois vecteurs de postion avec toutes les
        % combinaisons possibles pour avoir tous les pixels
        PosX = arrX';              
        PosX = repmat(PosX,sizeY*sizeZ,1); 

        PosY = ones(sizeX,1)*arrY; 
        PosY = PosY(:);                        
        PosY = repmat(PosY,sizeZ,1);              

        PosZ = ones(sizeX*sizeY,1)*arrZ;        
        PosZ = PosZ(:);                         

        % Images en vecteur
        %t1vect = t1(:); cbfvect = cbf(:); 
        favect = fa(:); mdvect = md(:); cbfvect = cbf(:); 
        
        % ROIs en vecteur
        %rois = categorical(seg, 0:20, {'Other','RN_l','RN_r','SN_l','SN_r', 'STN_l','STN_r', 'Cau_l','Cau_r','Putamen_l', 'Putamen_r','GPe_l','GPe_r','GPi_l','GPi_r','Th_l','Th_r','CS_l','CS_r','CI_l','CI_r'});
        %rois = categorical(seg, 0:20, {'Other','RN','RN','SN','SN', 'STN','STN', 'Cau','Cau','Putamen', 'Putamen','GPe','GPe','GPi','GPi','Th','Th','CS','CS','CI','CI'});
        rois = categorical(seg, 0:20, {'Other','Brain','Brain','Brain','Brain', 'Brain','Brain', 'Brain','Brain','Brain', 'Brain','Brain','Brain','Brain','Brain','Brain','Brain','Brain','Brain','Brain','Brain'});
        rois = rois(:);
        
        % Construction du tableur de coordonnées et valeurs correspondantes
        data = [ PosX PosY PosZ cbfvect favect mdvect ];
        
        % Suppression de lignes contenant NaN ou des cases vides
        rois(any(isnan(data), 2)) = [];
        data(any(isnan(data), 2), :) = [];
        rois(any(data==0,2)) = [];
        data(any(data==0,2),:) = [];
        
        data(find(rois=='Other'),:) = [];
        rois(find(rois=='Other')) = [];
        
        data2 = data;
        bordmin = zeros(length(data2),1);
        while ~all(isnan(data2(:,3)))
            mintemp = (data2(:,3)==min(data2(:,3)));
            bordmin = bordmin + mintemp;
            mintemp = logical(mintemp);
            data2(mintemp,3) = NaN;
            xymin = [data2(mintemp,1), data2(mintemp,2)];
            for y=1:size(xymin,1)
                xy = (data2(:,1)==xymin(y,1) & data2(:,2)==xymin(y,2));
                data2(xy,3) = NaN;
            end
        end
        data(logical(bordmin),:)=[];
        rois(logical(bordmin),:)=[];
        
        data2 = data;
        bordmax = zeros(length(data2),1);
        while ~all(isnan(data2(:,3)))
            maxtemp = (data2(:,3)==min(data2(:,3)));
            bordmax = bordmax + maxtemp;
            maxtemp = logical(maxtemp);
            data2(maxtemp,3) = NaN;
            xymax = [data2(maxtemp,1), data2(maxtemp,2)];
            for y=1:size(xymax,1)
                xy = (data2(:,1)==xymax(y,1) & data2(:,2)==xymax(y,2));
                data2(xy,3) = NaN;
            end
        end
        data(logical(bordmax),:)=[];
        rois(logical(bordmax),:)=[];

        % Group, patient name and VOI information table
        info = ["Patient" Subj_dir(i,1).name];
        info = repmat(info,size(data,1),1);
        
        ROI = vertcat(ROI,rois);
        Data = vertcat(Data,data); 
        Info = vertcat(Info,info); 
    end  
end
ROI=string(ROI);

T = [Info ROI Data];
T = T';
fid = fopen('/home/veronica/Donnees/Patients_3_onlysub2.csv','a'); 
fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s\n', T(:,:));
fclose(fid);