function [plane,inliers]=planefit(points,normals,Threshold,Angle_Threshold,iteration)
%%  find plane with max number of points 
%  seleceted points should have normals within the plane normal
%
%  input:
%  points:  input points (n*3), where n is the number of points
%  normals: input points normals (n*3), where n is the number of points
%  Threshold: allowed threshold or space around the plane for points to be
%  considered as inliers
%  Angle_Threshold: allowed angle difference threshold between points and
%  the plane 
%  iteration: number of iterations to stop loking for plane with max number
%  of points
%
%
%  output:
%  plane: palne equation parameters
%  inliers: inlier points

%%
     nu=length(points(1,:));  
     inliers=[];
     plane=[];
     
     k=0;

     Mdl = KDTreeSearcher(points');
     IdxNN = knnsearch(Mdl,points','K',9); 

       
     while  k<=iteration   % ransac find plane with max points

        indices = randi(nu,1,1);
        np=points(:,IdxNN(indices,1:9))';  
        [normal,~,~] = affine_fit(np);
        np=mean([np(:,1) np(:,2) np(:,3)]);
        d=-(normal(1)*np(1)+ normal(2)*np(2)+normal(3)*np(3));
        
        normal=(normal./norm(normal));
        
            I=[];
            for i=1:nu   % find number of points in each planne
                    p=(points(:,i));
                    n=(normals(:,i));
                    d1 = abs(p'*normal+d);
                    
                    if d1<=Threshold
                       if (abs(n(1)-normal(1))<Angle_Threshold && abs(n(2)-normal(2))<Angle_Threshold && abs(n(3)-normal(3))<Angle_Threshold) || (abs(-n(1)-normal(1))<Angle_Threshold && abs(-n(2)-normal(2))<Angle_Threshold && abs(-n(3)-normal(3))<Angle_Threshold)
                         I=[I,i];
                       end
                       
                    end
            end
                    if length(inliers)< length(I) % && planeDensity(All_points(:,I))>150
                        inliers=I;     plane=[normal' d];    
                    end
              
        k=k+1; 

     end

end












