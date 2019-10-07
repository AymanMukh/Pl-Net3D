function processdata(data,start,ending,label,folder)

%%  fit planes to given 3D data, extract plane properties 
%  
%       input:
%  data: 3D data (n*3), where n is the number of points
%  normals: input points normals (n*3), where n is the number of points
%  start: starting position from the given data
%  start: ending position from the given data
%
%  output: save planes parameters to files on local hard drive


for j= start:ending % length(label)

disp(j)
file=strcat(folder,num2str(j));

points=data(:,:,j);

% find points normals

%  ptCloud=pointCloud(points');
%  normals = pcnormals(ptCloud,50)'; 
[ normals ,~ ] = normal(points',.25);  % 'k', 50 
normals=normals';
 
 %% find planes in shape    

        nuu=length(points(1,:));q=1; go=true; qq=1;

        while go

        [plane,inl]=planefit(points,normals,.08,.3,100);
             qq=qq+1;

        if length(inl)>3   
        fr(q)=(length(inl)/nuu);
        planes(q,:)=(plane);
        planesnorm(q,:)=(plane(1:3)./norm(plane(1:3)));
        centrs_of_planes(q,:)=(median(points(:,inl)'));  % centr1=median(All_points(:,inl)');       
        cen(q)=(centrs_of_planes(q,1)^2+centrs_of_planes(q,2)^2+centrs_of_planes(q,3)^2)^.5;
        try 
        inl_points=rotate(points(:,inl));
        catch
        disp('na')
        inl_points=(points(:,inl));
        end

        planes_length(q,:)=[(-median(inl_points(inl_points(:,1)<0,1))+median(inl_points(inl_points(:,1)>0,1))),(-median(inl_points(inl_points(:,2)<0,2))+median(inl_points(inl_points(:,2)>0,2)))];
        planes_Dim(q,:)=[median(inl_points(inl_points(:,1)<0,1)),median(inl_points(inl_points(:,1)>0,1)),median(inl_points(inl_points(:,2)<0,2)),median(inl_points(inl_points(:,2)>0,2))];

        q=q+1;
%         filtered_points=[filtered_points,points(:,inl)];
        points(:,inl)=[];
        normals(:,inl)=[];
        
        end

        if length(points(1,:))<=0.05*nuu  || q>30 || qq>100
            go=false;
        end

        end
        
         if ~isempty(fr)
         [B,I] = sort(fr,'descend');
         fr=fr(I); 
         planes=single(planes(I,:));
         planesnorm=planesnorm(I,:);
         centrs_of_planes=centrs_of_planes(I,:);
         planes_length=planes_length(I,:);
         planes_Dim=planes_Dim(I,:);
         cen=cen(I);
         else
         fr=[]; 
         planes=[];
         planesnorm=[];
         centrs_of_planes=[];     
         planes_length=[];
         planes_Dim=[];
         cen=[];
         end
         
        shap=label(j);
        save(file,'fr');
%         save(file,'filtered_points','-append');
        save(file,'shap','-append');
        save(file,'planesnorm','-append');
        save(file,'planes','-append'); 
        save(file,'planes_Dim','-append'); 
        save(file,'planes_length','-append');
        save(file,'centrs_of_planes','-append');
        save(file,'cen','-append');
end

end

