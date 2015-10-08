function norm_points3d= normalise_last(points3d);

am_points = size(points3d,2);
dim = size(points3d,1);  

% Initialize
points3d_norm = zeros(dim,am_points); 

for hi1 = 1:am_points
  if (dim == 3) 
    if ( abs(points3d(3,hi1)) > eps)
      points3d_norm(1:3,hi1) = points3d(1:3,hi1) / points3d(3,hi1); 
    else
      warning('A points3d point is at infity - we leave it !');
      points3d_norm(:,hi1) = points3d(:,hi1); 
    end
  elseif (dim == 4)
    if ( abs(points3d(4,hi1)) > eps)
      points3d_norm(1:4,hi1) = points3d(1:4,hi1) / points3d(4,hi1);
    else
      warning('A points3d point is at infity - we leave it !');
      points3d_norm(:,hi1) = points3d(:,hi1); 
    end
  else
    error('Sorry but the dim of the data has to be 3 or 4');
  end
end
    
   norm_points3d= points3d_norm;
   
   end
   