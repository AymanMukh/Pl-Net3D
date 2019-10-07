function [ norm, curvature ] = normal( points, r_type, k )
% compute underlying surface's normal and curvature in local neighborhoods.
% the neighbors are determined by k-nearest or fixed radius algorithm.
%   Yucheng Dai
%   2017/01/13
%   daiyc@radi.ac.cn
if nargin ==2 && isnumeric(r_type)
    r = r_type;
    ng_type = 1;
elseif nargin ==3 && ischar(r_type)
    ng_type =2;
elseif nargin ==1
    ng_type = 2;
    k = 6;
else
    disp('error');
    norm = [];
    curvature = [];
    return;
end
%% centroid deviation / local coordinate system.
points = bsxfun(@minus, points(:,1:3), mean(points));
%% create a kd-tree 
ns = KDTreeSearcher(points,'Distance','euclidean');
%% allocate memory
norm = zeros(size(points,1),3);
curvature = zeros(size(points,1),1);
%% determine neighbors using the k-nearest or fixed radius algorithm.
if ng_type ==2
    [ngs, ~] = knnsearch(ns, points, 'K', k);
    for i = 1 : size(points,1)
        [norm(i,:), curvature(i)] = normal_(points(ngs(i,:), :));
    end
else
    [ngs,~] = rangesearch(ns, points, r);
    for i = 1 : size(points,1)
        [norm(i,:), curvature(i)] = normal_(points(ngs{i}, :));
    end
end
end