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
Ma = cameras(:,:,1); %cams_norm(:,:,1);
Mb = cameras(:,:,2); %cams_norm(:,:,2);

% Calculate Q(4x4).
ec1 = [(pA(1,:).*Ma(3,1) - Ma(1,1)); (pA(1,:).*Ma(3,2) - Ma(1,2)); ...
       (pA(1,:).*Ma(3,3) - Ma(1,3)); (pA(1,:).*Ma(3,4) - Ma(1,4))]';
ec2 = [(pA(2,:).*Ma(3,1) - Ma(2,1)); (pA(2,:).*Ma(3,2) - Ma(2,2)); ...
       (pA(2,:).*Ma(3,3) - Ma(2,3)); (pA(2,:).*Ma(3,4) - Ma(2,4))]';
  
ec3 = [(pB(1,:).*Mb(3,1) - Mb(1,1)); (pB(1,:).*Mb(3,2) - Mb(1,2)); ...
       (pB(1,:).*Mb(3,3) - Mb(1,3)); (pB(1,:).*Mb(3,4) - Mb(1,4))]';
ec4 = [(pB(2,:).*Mb(3,1) - Mb(2,1)); (pB(2,:).*Mb(3,2) - Mb(2,2)); ...
       (pB(2,:).*Mb(3,3) - Mb(2,3)); (pB(2,:).*Mb(3,4) - Mb(2,4))]';
  
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
% points3d(1,:) = points3d(1,:)./points3d(4,:);
% points3d(2,:) = points3d(2,:)./points3d(4,:);
% points3d(3,:) = points3d(3,:)./points3d(4,:);
% points3d(4,:) = points3d(4,:)./points3d(4,:);
 
% normalize the the 4th coordinate of model points to 1
% points3d = normalise_last(points3d); 
    
% am_points = size(points3d,2);
% dim = size(points3d,1);  
% 
% % Initialize
% points3d_norm = zeros(dim,am_points); 
% 
% for hi1 = 1:am_points
%   if (dim == 3) 
%     if ( abs(points3d(3,hi1)) > eps)
%       points3d_norm(1:3,hi1) = points3d(1:3,hi1) / points3d(3,hi1); 
%     else
%       warning('A points3d point is at infity - we leave it !');
%       points3d_norm(:,hi1) = points3d(:,hi1); 
%     end
%   elseif (dim == 4)
%     if ( abs(points3d(4,hi1)) > eps)
%       points3d_norm(1:4,hi1) = points3d(1:4,hi1) / points3d(4,hi1);
%     else
%       warning('A points3d point is at infity - we leave it !');
%       points3d_norm(:,hi1) = points3d(:,hi1); 
%     end
%   else
%     error('Sorry but the dim of the data has to be 3 or 4');
%   end
% end
%     
%    points3d= points3d_norm;
%     




