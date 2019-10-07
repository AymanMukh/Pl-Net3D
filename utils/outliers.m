function data=outliers(data,outlayerlevel,range) 


for j=1:length(data(1,1,:))
    
All_points=data(:,:,j);

n=length(All_points);
ran=range(1) + (range(2) -range(1)) *rand(fix(outlayerlevel*n),3)';


i=randperm(length(All_points));
All_points=All_points(:,i);

All_points=All_points(:,1:(n-length(ran)));
All_points=[All_points,ran];
%% save data to same file
data(:,:,j)=All_points;

% scatter3(All_points(1,:),All_points(2,:),All_points(3,:))
%         xlabel('My x label')
%         ylabel('y')
%         zlabel('zz')
end

