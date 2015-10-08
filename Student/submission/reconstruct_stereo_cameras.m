% function [cams, cam_centers] = reconstruct_stereo_cameras(E, K1, K2, points2d); 
%
% Method:   Calculate the first and second camera matrix. 
%           The second camera matrix is unique up to scale. 
%           The essential matrix and 
%           the internal camera matrices are known. Furthermore one 
%           point is needed in order solve the ambiguity in the 
%           second camera matrix.
%
%           Requires that the number of cameras is C=2.
%
% Input:    E is a 3x3 essential matrix with the singular values (a,a,0).
%
%           K is a 3x3xC array storing the internal calibration matrix for
%           each camera.
%
%           points2d is a 3xC matrix, storing an image point for each camera.
%
% Output:   cams is a 3x4x2 array, where cams(:,:,1) is the first and 
%           cams(:,:,2) is the second camera matrix.
%
%           cam_centers is a 4x2 array, where (:,1) is the first and (:,2) 
%           the second camera center.


function [cams, cam_centers] = reconstruct_stereo_cameras(E, K, points2d)

Ka= K(:,:,1);
Kb= K(:,:,2);
% Calculate camera a matrix Ma = Ka(I|0).
Ma = Ka*[eye(3)  zeros(3,1)];

% Calculate camera b matrix Mb = KbR(I|t).
% Calculate translation t.
[U,S,V] = svd(E);    


% Calculate t.
t = V(:,end); % Normalize t. ./sum(V(:,end))

% Calculate rotation R (R1=IWV' or R2=UW'V') with W=[0 -1 0; 1 0 0; 0 0 1]
W = [0 -1 0; 1 0 0; 0 0 1];
R1 = U*W*V';
R2 = U*W'*V';

% Check the determinant of R1 and R2 is 1.
if (det(R1) == -1) R1 = R1.*-1; end
if (det(R2) == -1) R2 = R2.*-1; end

% Find the 4 possible Mb's.
Mb1 = Kb*R1*[eye(3) t];
Mb2 = Kb*R1*[eye(3) -t];
Mb3 = Kb*R2*[eye(3) t];
Mb4 = Kb*R2*[eye(3) -t];

% Check which pair [Ma; Mb] has the point in front of both cameras.

temp1(:,:,1)= Ma;
temp2(:,:,1)= Ma;
temp3(:,:,1)= Ma;
temp4(:,:,1)= Ma;
temp1(:,:,2)= Mb1;
temp2(:,:,2)= Mb2;
temp3(:,:,2)= Mb3;
temp4(:,:,2)= Mb4;

p1 = reconstruct_point_cloud(temp1,points2d(:,:,:))';
p2 = reconstruct_point_cloud(temp2,points2d(:,:,:))';
p3 = reconstruct_point_cloud(temp3,points2d(:,:,:))';
p4 = reconstruct_point_cloud(temp4,points2d(:,:,:))';

% Normalize the points (needed for check if is in front a camera or not).
p1 = p1./p1(4);
p2 = p2./p2(4);
p3 = p3./p3(4);
p4 = p4./p4(4);

% Find the aligned points (with or without -?).
aligned_point1 = R1*[eye(3) t]*p1';
aligned_point2 = R1*[eye(3) -t]*p2';
aligned_point3 = R2*[eye(3) t]*p3';
aligned_point4 = R2*[eye(3) -t]*p4';

% Choose the point that is positive in both camA and camB.
cam_centers = [0 0 0 1; -t' 1]';
if ( (sign(p1(3)) == 1) && (sign(aligned_point1(3)) == 1) )   
    disp('OPTION 1 - In front of camera');
    
    cams(:,:,1)= Ma;
    cams(:,:,2)= Mb1; 
    
end

if ( (sign(p2(3)) == 1) && (sign(aligned_point2(3)) == 1) )  
    disp('OPTION 2 - In front of camera');   
   
    cams(:,:,1)= Ma;
    cams(:,:,2)= Mb2;
    
end

if ( (sign(p3(3)) == 1) && (sign(aligned_point3(3)) == 1) )  
    disp('OPTION 3 - In front of camera');
  
    cams(:,:,1)= Ma;
    cams(:,:,2)= Mb3;
end

if ( (sign(p4(3)) == 1) && (sign(aligned_point4(3)) == 1) )  
    disp('OPTION 4 - In front of camera');
   
    cams(:,:,1)= Ma;
    cams(:,:,2)= Mb4;
end
 
end

% cameras_error(:,:,2) =
% 
%     0.0000    0.0000   -0.0000    0.0659
%     0.0000         0   -0.0000    0.0254
%     0.0000    0.0000    0.0000   -0.0000
% 
% 
% camera_centers_error =
% 
%          0   -0.0136
%          0   -0.0010
%          0    0.0020
%          0    0.0752


