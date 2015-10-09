% function [cams, cam_centers] = reconstruct_uncalibrated_stereo_cameras(F); 
%
% Method: Calculate the first and second uncalibrated camera matrix
%         from the F-matrix. 
% 
% Input:  F - Fundamental matrix with the last singular value 0 
%
% Output:   cams is a 3x4x2 array, where cams(:,:,1) is the first and 
%           cams(:,:,2) is the second camera matrix.
%
%           cam_centers is a 4x2 array, where (:,1) is the first and (:,2) 
%           the second camera center.

function [cams, cam_centers] = reconstruct_uncalibrated_stereo_cameras( F )

cams = zeros(3,4,2);
cams(:,:,1) = eye(3,4);
% S = skewdec(3,3);
S = [0 1 1;
     -1 0 1;
     -1 -1 0];
h = null(F');

cams(1:3,1:3,2) = S*F;
cams(1:3,4,2) = h;

cam_centers(:,1) = null(cams(:,:,1));
cam_centers(:,2) = null(cams(:,:,2));
