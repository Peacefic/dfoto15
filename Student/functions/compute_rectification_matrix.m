% H = compute_rectification_matrix(points1, points2)
%
% Method: Determines the mapping H * points1 = points2
% 
% Input: points1, points2 of the form (4,n) 
%        n has to be at least 5
%
% Output:  H (4,4) matrix 
% 

function H = compute_rectification_matrix( points1, points2 )


% xA yA zA w 0  0  0  0 0  0  0  0 -xAxB -yAxB -zAxB -wxB
% 0  0  0  0 xA yA zA w 0  0  0  0 -xAyB -yAyB -zAyB -wyB
% 0  0  0  0  0  0  0 0 xA yA zA w -xAzB -yAzB -zAzB -wzB
n = size(points1,2);
xA = points1(1,:)';
yA = points1(2,:)';
zA = points1(3,:)';
w = points1(4,:)';

zero = zeros(n,4);
xB = points2(1,:)';
yB = points2(2,:)';
zB = points2(3,:)';

W = [xA yA zA w zero zero -xA.*xB -yA.*xB -zA.*xB -w.*xB;
     zero xA yA zA w zero -xA.*yB -yA.*yB -zA.*yB -w.*yB;
     zero  zero xA yA zA w -xA.*zB -yA.*zB -zA.*zB -w.*zB];
% size(W)
[~, ~,V] = svd(W);
h = V(:,end);
H = reshape(h,[4 4])';
