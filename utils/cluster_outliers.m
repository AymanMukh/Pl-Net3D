function data=cluster_outliers(data,outlayerlevel,size,noise) 
%-----------------------------------------------------------
% Generate clustered outliers
% input:
% data:  input data points (batch*n*3), where n is the number of points
% outlayerlevel: outliers percentage
% size: number of points in each cluster
% noise: distribution of points in each cluster 
%-----------------------------------------------------------

range=[-1 1];
for j=1:length(data(1,1,:))
    
All_points=data(:,:,j);

n=length(All_points);
cluster_number=fix(outlayerlevel/size*n);  % number of clusters
ran=range(1) + (range(2) -range(1)) *rand(cluster_number,3)';   % center points of clusters
ran1=ran;
ran=[];
w=randn(3,size); 
for i=1:size
   
addi=ran1+noise*w(:,i);
ran=[ran,addi];
end




All_points=All_points(:,1:(n-length(ran)));
All_points=[All_points,ran];
% i=randperm(length(All_points));
% All_points=All_points(:,i);
% All_points=All_points(:,1:n);

%% save data to same file
data(:,:,j)=All_points;

% scatter3(All_points(1,:),All_points(2,:),All_points(3,:))
%         xlabel('My x label')
%         ylabel('y')
%         zlabel('zz')
end