function data=missing_points(data,missing_point_ratio) 


for j=1:length(data(1,1,:)) %1:length(data(1,1,:))

All_points=data(:,:,j);
n=fix(length(All_points)*(1-missing_point_ratio));

 i=randperm(length(All_points));
 All_points=All_points(:,i);
 All_points=All_points(1:3,1:n);

%% save data to same file
data1(:,:,j)=All_points;

% scatter3(All_points(1,:),All_points(2,:),All_points(3,:))
%         xlabel('My x label')
%         ylabel('y')
%         zlabel('zz')
end
data=data1;
end

