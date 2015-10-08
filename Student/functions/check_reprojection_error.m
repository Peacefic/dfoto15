% % function [error_average, error_max] = check_reprojection_error(data, cam, point3d)
% %
% % Method:   Evaluates average and maximum error 
% %           between the reprojected image points (cam*point3d) and the 
% %           given image points (data), i.e. data = cam * point3d 
% %
% %           We define the error as the Euclidean distance in 2D.
% %
% %           Requires that the number of cameras is C=2.
% %           Let N be the number of points.
% %
% % Input:    points2d is a 3xNxC array, storing all image points.
% %
% %           cameras is a 3x4xC array, where cams(:,:,1) is the first and 
% %           cameras(:,:,2) is the second camera matrix.
% %
% %           point3d 4xN matrix of all 3d points.
% %       
% % Output:   
% %           The average error (error_average) and maximum error (error_max)
% %      
% 
function [error_average, error_max] = check_reprojection_error( points2d, cameras, points3d )

number_of_points = size(points3d,2);
no_of_cams = size(cameras,1)/3;
v_errors = zeros(1,no_of_cams* number_of_points);

% Calculate the re-projected data (3*m,n) as data.
reprojected_data(:,:,1) = cameras(:,:,1)*points3d;
reprojected_data(:,:,2) = cameras(:,:,2)*points3d;



reprojected_data(:,:,1) = normalise_last( reprojected_data(:,:,1));

reprojected_data(:,:,2) = normalise_last( reprojected_data(:,:,2));

count = 1;
for i = 1:no_of_cams
    for j = 1:number_of_points
        current_error = reprojected_data(:,j,1) - points2d(:,j,1);
        v_errors(count) = sqrt(current_error'*current_error);
        count = count + 1;
    end
end

% Returned values
error_average = sum(v_errors)/(number_of_points*no_of_cams);
error_max = max(v_errors);

end
% %------------------------------
% % TODO: FILL IN THIS PART
% 
% The true average error is:     25.4
% The computed average error is: 28.3
% The true max error is:         43.7
% The computed max error is:     43.7