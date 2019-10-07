clear
close all

addpath('./utils','./data');

load('data/test_data','data')  % MN40_10K
load('data/test_data','label')
%  load('data/test_data','data')
%  load('data/test_data','label')

shape_names = {'airplane','bathtub','bed','bench','bookshelf','bottle','bowl','car','chair','cone',...
        'cup','curtain','desk','door','dresser','flower_pot','glass_box','guitar','keyboard','lamp',...
        'laptop','mantel','monitor' 'night_stand','person','piano','plant','radio','range_hood','sink',...
        'sofa','stairs','stool','table','tent','toilet','tv_stand','vase','wardrobe','xbox'};


%% 
% select shape to visualize
shape=39; 
% select shape starting point
seq=1;

%%
current_shape=1;

for j=1:length(label)
 
if   any(label(j)==shape) %  label1==shape 
    

 if current_shape<seq
     current_shape=current_shape+1;
     continue
 end
     
disp(j)
     points=data(:,:,j);

            %% add outliers , noise , or missing points
%         points=noise(points,.08);
%     points=outliers(points,.5,[-1 1]);
%       points=missing_points(points,.9);
%    points=pseduo_outliers1(points,.2,.05);
%         points=cluster_outliers(points,.2,10,.04);
 %% find points normals
 [ normals_c , curvature ] = normal( points',.2);  % 'k', 50 
 normals_c=normals_c';

%  quiver3(points(1,:),points(2,:),points(3,:),normals_c(1,:),normals_c(2,:),normals_c(3,:));   

%   ptCloud=pointCloud(points');
%   normals_c = pcnormals(ptCloud,80)';

 %% draw shape
 figure
   scatter3(points(1,:),points(2,:),points(3,:),'.');
    quiver3(points(1,:),points(2,:),points(3,:),normals_c(1,:),normals_c(2,:),normals_c(3,:));     
% view(8,-70.6) 
view(180,-70.6) 
xlabel('x')
ylabel('y')
zlabel('z')
axis equal   
grid off
%  label1=find(shape_names==label(j))-1; 
% title(shape_names(label1+1))


 %% find planes in shape    

        nuu=length(points(1,:));q=1; go=true; qq=1;

        while go

        [plane,inl]=planefit(points,normals_c,.08,.8 ,100);
             qq=qq+1;

        if ~isempty(inl)  
          hold on
          scatter3(points(1,inl),points(2,inl),points(3,inl));
            axis equal   
% grid off
        fr(q)=single(length(inl)/nuu);
        planes(q,:)=single(plane);
        planesnorm(q,:)=single(plane(1:3)./norm(plane(1:3)));
        centrs_of_planes(q,:)=single(median(points(:,inl)'));  % centr1=median(All_points(:,inl)');       
        try 
        inl_points=rotate(points(:,inl));
        catch
        disp('na')
        inl_points=(points(:,inl));
        end

        planes_length(q,:)=[(-median(inl_points(inl_points(:,1)<0,1))+median(inl_points(inl_points(:,1)>0,1))),(-median(inl_points(inl_points(:,2)<0,2))+median(inl_points(inl_points(:,2)>0,2)))];
        planes_Dim(q,:)=[median(inl_points(inl_points(:,1)<0,1)),median(inl_points(inl_points(:,1)>0,1)),median(inl_points(inl_points(:,2)<0,2)),median(inl_points(inl_points(:,2)>0,2))];

        q=q+1;
        points(:,inl)=[];
        normals_c(:,inl)=[];
        end

        if length(points(1,:))<=0.05*nuu  || q>20 || qq>100
            go=false;
        end

        end
   hold off
%     set(gca,'visible','off')
   
    if current_shape>=seq
     break
    end

   
end

end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  