function data=rotate(data,phi,theta,n1,n2,n3)
% Rotate
    data=data';
%     phi=deg2rad(phi);theta=deg2rad(theta);
%  scatter3(data(1,:),data(2,:),data(3,:));
% xlabel('My x label')
% ylabel('y')
% zlabel('zz')
% axis equal

% https://au.mathworks.com/matlabcentral/answers/400250-rotation-matrix-3d-point-data
P=data;
x = P(:,1) ; y = P(:,2) ;z = P(:,3) ; % get (x,y,z) coordinate  
 x0 = x-mean(x) ; y0 = y-mean(y) ; z0 = z-mean(z) ; % remove mean 
 P1 = [x0 y0 z0] ; %this step to bring the coord of P near to the origin. The new coord will be created
%  scatter3(P1(:,1),P1(:,2),P1(:,3),'b.');%plot new coord of P1
 HA=[min(P1(:,1)) min(P1(:,2)) max(P1(:,3))+1];%just for better visualaztion
% hold on;scatter3(HA(:,1),HA(:,2),HA(:,3),'g.');%just for better visualaztion
%% Finding  principal vector of 3D data P
PCA=pca(P);
e1=PCA(:,1)'; e2=PCA(:,2)' ;e3=PCA(:,3)';  % 3 principal vector(3 eigenvector) of "input data"
n1=[1 0 0]  ; n2=[0 1 0]   ; n3=[0 0 1];   % 3 unit vector Ox,Oy,Oz
%%  transformation matrix from "e" space to "n" space
R=[e2;e1;e3];  % rotation matrix , match with xyz (e1//n2, e2//n1, e3//n3)
% R=[e1;e2;e3];  % rotation matrix , match with xyz (e1//n1, e2//n2, e3//n3) 
% R=[e3;e2;e1]; % If  e1//n3, e2//n2, e3//n1
%% Finding the new rotate data
 newdata1=(R*P1')';%new data corresponding to P1 coordinate
% hold on; scatter3(newdata1(:,1),newdata1(:,2),newdata1(:,3),'r.');
 newdata=[newdata1(:,1)+mean(x),newdata1(:,2)+mean(y),newdata1(:,3)+mean(z)];
%% Plot the original & rotation 3D data
% figure;scatter3(P(:,1),P(:,2),P(:,3),'b.');
% hold on;scatter3(newdata(:,1),newdata(:,2),newdata(:,3),'r.');
% HA=[min(P(:,1)) min(P(:,2)) max(P(:,3))+1];%just for better visualaztion
% hold on;scatter3(HA(:,1),HA(:,2),HA(:,3),'g.');%just for better visualaztion
% legend('original data(P)','rotated data(newdata)');title({'Plot the rotation matrix 3D point data';'(FINAL RESULT)'});
data=newdata1;






% All_points=data;
% x=All_points(1,:);
% y=All_points(2,:);
% z=All_points(3,:);
% 
% 
% % https://au.mathworks.com/help/phased/ref/rotz.html
% % https://au.mathworks.com/matlabcentral/answers/123763-how-to-rotate-entire-3d-data-with-x-y-z-values-along-a-particular-axis-say-x-axis
% 
% % % x - rotation
% %   X = x;
% %  Y = y*cos(theta)-z*sin(theta);
% %  Z = y*sin(theta)+z*cos(theta);
% %  
% %  x=X;y=Y;z=Z;
% 
% % y- rotation
% X = x*cos(phi) + z*sin(phi);
%  Y = y;
% Z = z*cos(phi) - x*sin(phi);
% 
% %   x=X;y=Y;z=Z;
% % z-rotation
% X = x*cos((theta)) - y*sin(theta);
% Y = x*sin(theta) + y*cos(theta);
% Z = z;
% scatter3(X,Y,Z);
% xlabel('My x label')
% ylabel('y')
% zlabel('zz')
%  hold on
% All_points(1,:)=X;All_points(2,:)=Y;All_points(3,:)=Z;
% data=All_points;


