% function points3d = reconstruct_point_cloud(cam, data)
%
% Method:   Determines the 3D points3d points by triangulation
%           of a stereo camera system. We assume that the data 
%           is already normalized 
% 
%           Requires that the number of cameras is C=2.
%           Let N be the number of points.
%
% Input:    points2d is a 3xNxC array, storing all image points.
%
%           cameras is a 3x4xC array, where cameras(:,:,1) is the first and 
%           cameras(:,:,2) is the second camera matrix.
% 
% Output:   points3d 4xN matrix of all 3d points.


function points3d = reconstruct_point_cloud( cameras, points2d )

pA = points2d(:,:,1);
pB = points2d(:,:,2);

n = size(pA,2);
% General projection matrix M of each camera.
Ma = cameras(:,:,1); 
Mb = cameras(:,:,2); 

% Calculate Q(4x4).
ec1 = [(pA(1,:).*Ma(3,1) - Ma(1,1)); (pA(1,:).*Ma(3,2) - Ma(1,2));(pA(1,:).*Ma(3,3) - Ma(1,3)); (pA(1,:).*Ma(3,4) - Ma(1,4))]';
ec2 = [(pA(2,:).*Ma(3,1) - Ma(2,1)); (pA(2,:).*Ma(3,2) - Ma(2,2));(pA(2,:).*Ma(3,3) - Ma(2,3)); (pA(2,:).*Ma(3,4) - Ma(2,4))]';
  
ec3 = [(pB(1,:).*Mb(3,1) - Mb(1,1)); (pB(1,:).*Mb(3,2) - Mb(1,2));(pB(1,:).*Mb(3,3) - Mb(1,3)); (pB(1,:).*Mb(3,4) - Mb(1,4))]';
ec4 = [(pB(2,:).*Mb(3,1) - Mb(2,1)); (pB(2,:).*Mb(3,2) - Mb(2,2));(pB(2,:).*Mb(3,3) - Mb(2,3)); (pB(2,:).*Mb(3,4) - Mb(2,4))]';
  
Q = [ec1 ec2 ec3 ec4];

% Get points3ds.
points3d = zeros(4,n);
for i = 1:n
    % Get W.
    W = reshape(Q(i,:),4,4)';
    
    % Compute eigenvectors (V) and eigenvalues (S) of W.
    [U,S,V] = svd(W);
    
    % Add to points3ds.
    points3d(:,i) = V(:,end);
    
 
end




