% Method:   compute all normalization matrices.  
%           It is: point_norm = norm_matrix * point. The norm_points 
%           have centroid 0 and average distance = sqrt(2))
% 
%           Let N be the number of points and C the number of cameras.
%
% Input:    points2d is a 3xNxC array. Stores un-normalized homogeneous
%           coordinates for points in 2D. The points2d may have NaN values.
%        
% Output:   norm_mat is a 3x3xC array. Stores the normalization matrices
%           for all cameras, i.e. norm_mat(:,:,c) is the normalization
%           matrix for camera c.

function norm_mat = compute_normalization_matrices( points2d )
 
no_of_cams = size(points2d,1)/3; 
no_of_points = size(points2d,2);   

points2d_NaN_Zero = points2d;
points2d_NaN_Zero(isnan(points2d_NaN_Zero)) = 0; % Convert NaN to zeros.

centroids_points = reshape(sum(points2d_NaN_Zero,2),3,no_of_cams);
centroids = centroids_points(1:2,:)./repmat(centroids_points(3,:),2,1);
centroids = [centroids; ones(1,size(centroids,2))]; % Centroids.

points2d_plus_centroid = points2d;
for i=1:no_of_cams
   for j=1:no_of_points
        if(isnan(points2d_plus_centroid(3*i-2,j)))
            points2d_plus_centroid(3*i-2:3*i,j)= centroids(:,i);
        end
   end
end

% 2 - Calculate distance.
distance_matrix = points2d_plus_centroid - repmat(reshape(centroids,no_of_cams*3,1), 1, no_of_points);

distances = zeros(1,3);
for i=1:no_of_cams
    sum_row = sum(distance_matrix(i*3-2:i*3,:).^2,1);
    distances(i) = sum(sqrt(sum_row),2)./centroids_points(3,i);
end

% Create norm_mat.
for i=1:no_of_cams
    norm_mat(i*3-2:i*3,:)= [sqrt(2)/distances(i) 0 -sqrt(2)*centroids(1,i)/distances(i); 0 sqrt(2)/distances(i) -sqrt(2)*centroids(2,i)/distances(i); 0 0 1];
end

