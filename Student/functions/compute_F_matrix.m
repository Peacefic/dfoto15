% function F = compute_F_matrix(points1, points2);
%
% Method:   Calculate the F matrix between two views from
%           point correspondences: points2^T * F * points1 = 0
%           We use the normalize 8-point algorithm and 
%           enforce the constraint that the three singular 
%           values are: a,b,0. The data will be normalized here. 
%           Finally we will check how good the epipolar constraints:
%           points2^T * F * points1 = 0 are fullfilled.
% 
%           Requires that the number of cameras is C=2.
% 
% Input:    points2d is a 3xNxC array storing the image points.
%
% Output:   F is a 3x3 matrix where the last singular value is zero.

function F = compute_F_matrix( points2d )



pA= points2d(:,:,1);
pB= points2d(:,:,2);

% Points normalized.
[norm_matA] = compute_normalization_matrices(pA);
pA_cam_norm = norm_matA*pA;

[norm_matB] = compute_normalization_matrices(pB);
pB_cam_norm = norm_matB*pB;

% Data sizes.
n_1 = size(pA,2);

% Calculate Q (there is no beta, so only alpha, remembering lab 1).
Q = [pB_cam_norm(1,:).*pA_cam_norm(1,:); pB_cam_norm(1,:).*pA_cam_norm(2,:); pB_cam_norm(1,:); ...
     pB_cam_norm(2,:).*pA_cam_norm(1,:); pB_cam_norm(2,:).*pA_cam_norm(2,:); pB_cam_norm(2,:); ...
     pA_cam_norm(1,:); pA_cam_norm(2,:); ones(1,n_1)]';
 Q(isnan(Q)) = 0 ;
% Compute eigenvectors (V) and eigenvalues (S) of Q.
[U,S,V] = svd(Q);

% Select the eigenvector h0 with minimun eigenvalue -> H
F_norm = reshape(V(:,size(Q,2)),3,3)';

% Find E (disabling the normalization).
F_no_properties = norm_matB'*F_norm*norm_matA; 

% Fulfill matrix E properties.
[U,S,V] = svd(F_no_properties);
F = U*[S(1,1) 0 0; 0 S(2,2) 0; 0 0 0]*V'; 