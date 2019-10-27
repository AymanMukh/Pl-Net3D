function collect_data(folder,outputname,files_number)

%%  collect all processed files in one h5 file
%  
%       input:
%  folder: location of processed files
%  outputname: name of the output h5 file
%  files_number: number of files to be collected
%  
%
%  output: save planes parameters of all objects to h5 file
%%
shape_names = {'airplane','bathtub','bed','bench','bookshelf','bottle','bowl','car','chair','cone',...
        'cup','curtain','desk','door','dresser','flower_pot','glass_box','guitar','keyboard','lamp',...
        'laptop','mantel','monitor' 'night_stand','person','piano','plant','radio','range_hood','sink',...
        'sofa','stairs','stool','table','tent','toilet','tv_stand','vase','wardrobe','xbox'};
    
ii=[1 2 8 12 14 22 23 33 35 30]; %  moldelnet10  
q=0;

for j=1:files_number
    
        file=strcat(folder,num2str(j)); %

        load(file,'shap');     % label   
        
    if   1==1 %  any(shap==ii) % 
        q=q+1;
        load(file,'fr');          % fraction of points in each plane
        load(file,'planesnorm');  % normal vectors & d (ax+by+cz=d)/norm(a,b,c)
%         load(file,'planes'); % plane equation (ax+by+cz=d)
        load(file,'centrs_of_planes');  % center of each plane in x y z
%         load(file,'planes_length'); % width hight
        load(file,'planes_Dim'); % min, max x,y,z
%         load(file,'cen');          % distance of each plane center from 0 0 0


       fr=fr/fr(1);
       
       input=single([fr;centrs_of_planes';planes_Dim';planesnorm']); 
         
       
        n=20;      
        
        if length(input(1,:))<n
        co=n-length(input(1,:));
        inputin=[input,zeros(length(input(:,1)),co)];
        else
         inputin=input(:,1:n); 
        end
        
        
       label(q)=single(shap);   
       data(:,:,q)=inputin;
       
    end

end

%%
%  i=randperm(length(label));
%  data=data(:,:,i);
%  label=label(i);


 h5create(outputname,'/data',size(data),'Datatype','single');
 h5write(outputname,'/data',data);
 h5create(outputname,'/label',size(label),'Datatype','uint8');
 h5write(outputname,'/label',label);

 h5disp(outputname);
end