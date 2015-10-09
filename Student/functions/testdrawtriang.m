
image_names_file    = 'names_images_toyhouse.txt';
CAMERAS = 2;
img = load_images_grey( image_names_file, CAMERAS );
texture = img{1}';
H = 768;
W = 576;
triang = [1 2 3;
          2 3 4;
          1 3 4];
X = [0 0 W W];
Y = [0 H 0 H];
Z = [1 1 1 1];
U = X;
V = Y;


TRIANGLES = size( indices, 1 );
handles = [];

vertices = triang(1,:);

vertices3d = [  X(vertices);
                Y(vertices);
                Z(vertices)];

vertices2d = [  U(vertices);
                V(vertices)];
    
% h = draw_textured_triangle( vertices3d, vertices2d, texture, 256 );
% function handle = draw_textured_triangle( points3d, points2d, img, textureSize )
% 
% [H,W,CHANNELS] = size( img );
points3d = vertices3d;
points2d=vertices2d;
img=texture;
textureSize=256;
% outputPoints = [1 W 1;
%                 H H 1];
outputPoints = [1 W 1;
                H H 1];
         
tform = maketform( 'affine', points2d', outputPoints' );

% tform = fitgeotrans(points2d',outputPoints','affine');
triTexture = imtransform( img, tform, 'bicubic', ...
                         'xdata', [1 W], 'ydata', [1 H], 'size', ...
                         textureSize*[1 1] );
% triTexture = imwarp(outputPoints,tform);
% Vertex indices used to create 2-by-2 surface coordinates:
indices = [3 3;
           1 2];

x = points3d(1,:);
y = points3d(2,:);
z = points3d(3,:);

X = x(indices);
Y = y(indices);        
Z = z(indices);        

handle = surf( X, Y, Z, triTexture, 'FaceColor', 'texturemap', 'EdgeColor', 'none' );
% handle = surf( X, Y, Z, [1 1; H 1; H W; 1 W], 'FaceColor', 'texturemap', 'EdgeColor', 'none' );

colormap('Gray')
handles = [handles; h];



% draw_textured_triangles( triang, X, Y, Z, U, V, texture, 768 )