function [ n,c ] = normal_( points )
% compute the underlying surface's normal and curvature for the points
%   Yucheng Dai
%   2017/01/13
%   daiyc@radi.ac.cn
% Compute the MxM covariance matrix CM
CM = cov(points);
% Compute the eigenvector of CM
[V, LAMBDA] = eig(CM);
% Find the minimum eigenvalue and corresponding eigenvector.
lambda_ = diag(LAMBDA);
[~,idx] = min(lambda_);
%% the local surface's estimated curvature and normal.
n = V(:,idx)./norm(V(:,idx)); % Normalize,
c = lambda_(idx)/sum(lambda_);
end
