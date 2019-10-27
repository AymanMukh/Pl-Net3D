function data=noise(data,noiselevel)
%-----------------------------------------------------------
% Generate noise in the given data
% input:
% data:  input data points (batch*n*3), where n is the number of points
% noiselevel: noise percentage
%-----------------------------------------------------------

for j=1:length(data(1,1,:)) 

All_points=data(:,:,j);

n=length(All_points);

All_points=All_points+noiselevel.*randn(n,3)';


%% save data to same file
data(:,:,j)=All_points;
%% plot
% scatter3(All_points(1,:),All_points(2,:),All_points(3,:))
%         xlabel('My x label')
%         ylabel('y')
%         zlabel('zz')
end


