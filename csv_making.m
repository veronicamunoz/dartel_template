clear all;
close all;

% Perf_path = '/home/veronica/Donnees/PerfusionPark/';
% Diff_path = '/home/veronica/Donnees/DTIPark/Park/';
Perf_path = '/home/veronica/Donnees/PerfusionControls/';
Diff_path = '/home/veronica/Donnees/DTIPark/Control/';

Subj_dir = dir([Diff_path '*']);
Subj_dir = Subj_dir(arrayfun(@(x) ~strcmp(x.name(1),'.'),Subj_dir));
Data2 = []; Info2 = [];

%Ecrire le titre pour bien commencer
t2={'Group', 'Patient', 'VOI', 'Coord_X', 'Coord_Y', 'Coord_Z', 'CBF', 'FA', 'MD'};
commaHeader = [t2;repmat({','},1,numel(t2))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas

% %write header to file
fid = fopen('/home/veronica/Donnees/Controls_3.csv','w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);

for i = 1:3 %[7 13 14] %1:size(Subj_dir,1)  %
    perf=fullfile(Perf_path, Subj_dir(i,1).name ,'pcasl', 'r2c3d_CBF.nii');
    FA=fullfile(Diff_path, Subj_dir(i,1).name, 'DTI', 'r2c3d_FA.nii');
    MD=fullfile(Diff_path, Subj_dir(i,1).name, 'DTI', 'r2c3d_MD.nii');
    if (Subj_dir(i,1).isdir==1) && (exist(perf, 'file')~=0) && (exist(FA,'file')~=0) && (exist(MD,'file')~=0)
    %if (Subj_dir(i,1).isdir==1) && (exist(FA,'file')~=0) && (exist(MD,'file')~=0)
        
%         fid = fopen(['/home/veronica/Donnees/Control' Subj_dir(i,1).name '.csv'],'w'); 
%         fprintf(fid,'%s\n',textHeader);
%         fclose(fid);    
    
        disp(['Extracting data from ' Subj_dir(i,1).name]); 
        %t1=niftiread(anat);
        cbf=niftiread(perf);
        fa=niftiread(FA);
        md=niftiread(MD);
        
        %imtool(t1(:,:,2),'DisplayRange',[]); 
        sizeX=size(fa,1); sizeY=size(fa,2); sizeZ=size(fa,3); %taille des dimensions
        arrX = 1:1:sizeX; arrY = 1:1:sizeY; arrZ = 1:1:sizeZ; %tous les index

        % Construction des trois vecteurs de postion avec toutes les
        % combinaisons possibles pour avoir tous les pixels
        PosX = arrX'; %x correspond aux lignes (indice vertical)                 
        PosX = repmat(PosX,sizeY*sizeZ,1); 

        PosY = ones(sizeX,1)*arrY; 
        PosY = PosY(:);                        
        PosY = repmat(PosY,sizeZ,1);              

        PosZ = ones(sizeX*sizeY,1)*arrZ;        
        PosZ = PosZ(:);                         

        % Images en vecteur
        %t1vect = t1(:); cbfvect = cbf(:); 
        favect = fa(:); mdvect = md(:); cbfvect = cbf(:); 

        % Construction du tableur de coordonnées et valeurs correspondantes
        % avec suppression de lignes contenant NaN
        data = [ PosX PosY PosZ cbfvect favect mdvect ];
        %data = [ PosX PosY PosZ favect mdvect ];
        data(any(isnan(data), 2), :) = [];
        zero = any(data==0,2);
        data(zero,:) = [];
        
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

        
        % Group, patient name and VOI information table
        info = ["Control" Subj_dir(i,1).name "Brain"];
        info = repmat(info,size(data,1),1);
        
        Data2 = vertcat(Data2,data); 
        Info2 = vertcat(Info2,info); 
%         T=[info data];
%         T=T';        
%         fid = fopen(['/home/veronica/Donnees/Control' Subj_dir(i,1).name '.csv'],'a'); 
%             fprintf(fid,'%s, %s, %s, %s, %s, %s, %s, %s, %s\n', T(:,:));
%             fclose(fid);

%         figure;
%         subplot(3,2,1)
%         histogram(Data2(:,4), 60, 'Normalization','probability');title("CBF Controls")
%         subplot(3,2,2)
%         histogram(Data2(:,4), 60, 'Normalization','probability', 'FaceColor','r');title("CBF Patients")
%         subplot(3,2,3)
%         histogram(Data2(:,5), 60, 'Normalization','probability');title("FA Controls")
%         subplot(3,2,4)
%         histogram(Data2(:,5), 60, 'Normalization','probability','FaceColor','r');title("FA Patients")
%         subplot(3,2,5)
%         histogram(Data2(:,6), 60, 'Normalization','probability');title("MD Controls")
%         subplot(3,2,6)
%         histogram(Data2(:,6), 60, 'Normalization','probability', 'FaceColor','r');title("MD Patients")
    end
    
    
end

% 
% figure;
% subplot(3,2,1)
% histogram(Data(:,4), 60, 'Normalization','probability');title("CBF Controls")
% subplot(3,2,2)
% histogram(Data2(:,4), 60, 'Normalization','probability', 'FaceColor','r');title("CBF Patients")
% subplot(3,2,3)
% histogram(Data(:,5), 60, 'Normalization','probability');title("FA Controls")
% subplot(3,2,4)
% histogram(Data2(:,5), 60, 'Normalization','probability','FaceColor','r');title("FA Patients")
% subplot(3,2,5)
% histogram(Data(:,6), 60, 'Normalization','probability');title("MD Controls")
% subplot(3,2,6)
% histogram(Data2(:,6), 60, 'Normalization','probability', 'FaceColor','r');title("MD Patients")

%         info=cellstr(info);
%         data=num2cell(data);
%         t=[info data];
% 
%         dlmwrite('/home/veronica/Donnees/PatientsData.csv',t,'-append');        
T=[Info2 Data2];
T=T';        
fid = fopen('/home/veronica/Donnees/Controls_3.csv','a'); 
        fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s\n', T(:,:));
        fclose(fid);


%write data to end of file
% dlmwrite('yourfile.csv',yourdata,'-append');

%csvwrite('/home/veronica/Donnees/PatientsData.csv', Variable 
%         for x = 80 : 100
%             for y = 80 : 100
%                 for z = 20 : 40
%                     val(end+1,:)=[x y z t1(x,y,z) cbf(x,y,z)];
%                     info(end+1,:)=['Patient' Subj_dir(i,1).name 'Brain'];
%                 end
%             end
%         end

%         s1=spm_vol(fullfile(Anat_path, Subj_dir(i,1).name, 'Anat', 'rAnat.nii'));
%         anat=spm_read_vols(s1);
%         s2=spm_vol(fullfile(Perf_path, Subj_dir(i,1).name, 'pcasl', 'rc3d_cbf_map.nii'));
%         perf=spm_read_vols(s2);        

%     data_cells=num2cell(data);     %Convert data to cell array
%     col_header={'Patients','','Controls',''};     %Row cell array (for column labels)
%     row_header={Sd; Sg};     %Column cell array (for row labels)
%     output_matrix=[{' '} col_header; row_header data_cells];     %Join cell arrays
% %     xlswrite('D:/Donnees/PatientsPark/meant1values.xls',output_matrix, strcat('Sheet',string(sheetnum)));     %Write data and both headers
%     xlswrite('D:/Donnees/PatientsPark/meanfgatirvalues.xls',output_matrix, Sd(1:end-2));



% 
% for i = 1 : size(Subj_dir,1)
% disp(Subj_dir(i,1).name);
% t1_path=fullfile(Anat_path, Subj_dir(i,1).name, 'Anat', 'rAnat.nii');
% if (Subj_dir(i,1).isdir==1 && exist(t1_path, 'file') ~= 0)
%     fgatir_path=fullfile(Anat_path, Subj_dir(i,1).name, 'FGATIR');
%     if exist(fullfile(fgatir_path, 'FGATIR.nii'), 'file') ~= 0
% 
%     end
%     cbf_path=fullfile(Perf_path, Subj_dir(i,1).name, 'pcasl');
%     if exist(fullfile(cbf_path, 'cbf_map.nii'), 'file') ~= 0
%        
%     end
% %     diff2_path=fullfile(Diff_path, Subj_dir(i,1).name, 'FA');
% %     if exist(fullfile(cbf_path, 'cbf_map.nii'), 'file') ~= 0
% %         system([C3Dcommand fullfile(cbf_path, 'cbf_map.nii') ' -resample-mm 1.0x1.0x1.0mm -o ' fullfile(cbf_path, 'c3d_cbf_map.nii')]);
% %     end
% end
% end