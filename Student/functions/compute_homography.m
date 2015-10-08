% H = compute_homography(points1, points2)
%
% Method: Determines the mapping H * points1 = points2
% 
% Input:  points1, points2 are of the form (3,n) with 
%         n is the number of points.
%         The points should be normalized for 
%         better performance.
% 
% Output: H 3x3 matrix 
%

function H = compute_homography( points1, points2 )
%points2 --> H points1

% points1
% points2

points2(isnan(points2)) = 0 ;
points1( :, all(~points2,1) ) = [];
points2( :, all(~points2,1) ) = [];
% points1
% points2

fprintf('');

%points2(isnan(points2)) = 0 ;



[a,sz_points1] = size(points1);
[b,sz_points2] = size(points2);

if sz_points1 == sz_points2
   
    
    alpha = zeros(sz_points1,9);
       beta = zeros(sz_points1,9);
    
    
    for i= 1: sz_points1
       
       
       alpha(i,:)= [ points2(1,i),points2(2,i), 1,0,0,0, -points2(1,i)*points1(1,i), -points2(2,i)*points1(1,i), -points1(1,i)];
       
       beta(i,:)= [0,0,0,points2(1,i),points2(2,i),1, -points2(1,i)*points1(2,i), -points2(2,i)*points1(2,i), -points1(2,i)];
       
    end
    
   Q = [alpha; beta];
   size(Q)
   
   A= Q'*Q;
   
   [U S V]= svd(A);
   
   %U
   %S
   %V
%    alpha
%    beta
   
   h= V(:,end);
   
   H= [h(1:3)';h(4:6)';h(7:9)'];
   
  %H= S;
   
   
   
end


    
end

   
    
  




%-------------------------
% TODO: FILL IN THIS PART
