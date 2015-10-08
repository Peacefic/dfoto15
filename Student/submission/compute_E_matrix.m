% function E = compute_E_matrix( points1, points2, K1, K2 );
%
% Method:   Calculate the E matrix between two views from
%           point correspondences: points2^T * E * points1 = 0
%           we use the normalize 8-point algorithm and 
%           enforce the constraint that the three singular 
%           values are: a,a,0. The data will be normalized here. 
%           Finally we will check how good the epipolar constraints:
%           points2^T * E * points1 = 0 are fullfilled.
% 
%           Requires that the number of cameras is C=2.
% 
% Input:    points2d is a 3xNxC array storing the image points.
%
%           K is a 3x3xC array storing the internal calibration matrix for
%           each camera.
%
% Output:   E is a 3x3 matrix with the singular values (a,a,0).

function E = compute_E_matrix( points2d, K )


pa= points2d(:,:,1);
pb= points2d(:,:,2);

Ka= K(:,:,1);
Kb= K(:,:,2);


% Points in a normalized camera coordinate system.
pa_cam = (Ka)^-1*pa;
pb_cam = (Kb)^-1*pb;

% Points normalized.
[norm_matA] = compute_normalization_matrices(pa_cam);
pa_cam_norm = norm_matA*pa_cam;

[norm_matB] = compute_normalization_matrices(pb_cam);
pb_cam_norm = norm_matB*pb_cam;

% Data sizes.
data_size = size(pa,2);

% Calculate Q (there is no beta, so only alpha, remembering lab 1).
Q = [pb_cam_norm(1,:).*pa_cam_norm(1,:); pb_cam_norm(1,:).*pa_cam_norm(2,:); pb_cam_norm(1,:); ...
     pb_cam_norm(2,:).*pa_cam_norm(1,:); pb_cam_norm(2,:).*pa_cam_norm(2,:); pb_cam_norm(2,:); ...
     pa_cam_norm(1,:); pa_cam_norm(2,:); ones(1,data_size)]';
 Q(isnan(Q)) = 0 ;

[U,S,V] = svd(Q);
E_norm = reshape(V(:,size(Q,2)),3,3)';

% Find E (disabling the normalization).
E_no_properties = norm_matB'*E_norm*norm_matA; 

% Fulfill matrix E properties.
[U,S,V] = svd(E_no_properties);
E = U*[0.5*(S(1,1)+S(2,2)) 0 0; 0 0.5*(S(1,1)+S(2,2)) 0; 0 0 0]*V'; 

end