function miniproject()
  
  orignlImg = double(imread('input_image.jpeg'));   % read directly from greyscale image
  figure(1);imshow(orignlImg, []); title('Chosen Original Image');   
  H = [0.9 0.1 0; 0.2 0.7 0; 0 0 1];    % arbitrary H (adjusted the given sample matrix)
  
  % Generating Affine Image from Chosen Original Image
  affineTransfImg = geotrans(H, orignlImg);
  figure(2);imshow(affineTransfImg, []); title('Affine transformation of Chosen Image');
  % Transforming Affine Image directly to Chosen Image
  reTransfImg = geotrans(inv(H), affineTransfImg);
  figure(3);imshow(reTransfImg, []); title('Affine to Chosen Original Image');
  
  % Transforming the Affine Image back to Chosen Image iteratively
  iterations = 90;    % change the iteration count here (Optimum iteration: [>=80])
  for i=1:iterations
    finalAffineMatrix = leastSquaresCorrelation(orignlImg, affineTransfImg);  
    affineTransfImg = geotrans(inv(finalAffineMatrix), affineTransfImg);  
    figure(4);imshow(affineTransfImg, []); 
    title(['Affine to Chosen Original Image - Iterations: ',num2str(iterations)]);
  endfor
  display('Final Affine Matrix of Chosen Original Image::');
  display(finalAffineMatrix);

  % Testing the transformation of affine images to target image
  orgnlTestImg = double(imread('target_img.png'));
  testTargetImages('C', 40, orgnlTestImg);    % Change the affine image Choice and iteration number here
endfunction

% Transforming the affine images to target image
function testTargetImages(imageChoice, iterations, orignlImg)
  if(imageChoice=='A')  % optimum iteration: [25 - 30] 
    affineTestImg=double(imread('distorted_img_A.png'));
  elseif(imageChoice=='B')  % optimum iteration: [1]
    affineTestImg=double(imread('distorted_img_B.png'));
  elseif(imageChoice=='C')  % optimum iteration: [40 - 50]
    affineTestImg=double(imread('distorted_img_C.png'));
  endif
  figure(5); imshow(affineTestImg, []); title('Affine Image under Test');
  for i=1:iterations
    finalTestAffineMatrix = leastSquaresCorrelation(orignlImg, affineTestImg);
    if(imageChoice=='A')
        affineTestImg = geotrans(finalTestAffineMatrix, affineTestImg);
    else
    affineTestImg = geotrans(inv(finalTestAffineMatrix), affineTestImg);
    endif  
    figure(6);imshow(affineTestImg, []); title(['Affine to Target Image - Iterations: ',num2str(iterations)]);  
  endfor
  display('Final Affine Matrix of Target Image::');
  display(finalTestAffineMatrix);
endfunction

% LSM Calculation
function finalAffineMatrix = leastSquaresCorrelation(orignlImg, transfImg)
  % To solve Az = b to find the 6 parameters (h1,...h6) 
  [x, y] = meshgrid(50:100, 50:100);  % 50:100
  leftWindow = orignlImg(50:100, 50:100);
  rightWindow = transfImg(50:100, 50:100);
  [fx, fy] = gradient(leftWindow, 2);  % Obtaining the gradient information to build the matrix 'A'
  % Constructing A (4X4)
  a11 = sum(sum((fx.^2).*(x.^2)));
  a12 = a21 = sum(sum((fx.^2).*(x.*y)));
  a13 = a31 = sum(sum((fx.*fy).*(x.^2)));
  a14 = a23 = a32 = a41 = sum(sum((fx.*fy).*(x.*y)));
  a22 = sum(sum((fx.^2).*(y.^2)));
  a24 = a42 = sum(sum((fx.*fy).*(y.^2)));
  a33 = sum(sum((fy.^2).*(x.^2)));
  a34 = a43 = sum(sum((fy.^2).*(x.*y)));
  a44 = sum(sum((fy.^2).*(y.^2)));
  A = [a11  a12   a13   a14;
       a21  a22   a23   a24;
       a31  a32   a33   a34;
       a41  a42   a43   a44];  
       
  % b needs intensity difference between leftWindow and rightWindow
  intensityDiff = leftWindow - rightWindow;
  b11 = sum(sum(fx.*x.*intensityDiff));
  b12 = sum(sum(fx.*y.*intensityDiff));
  b13 = sum(sum(fy.*x.*intensityDiff));
  b14 = sum(sum(fy.*y.*intensityDiff));
  b = [b11  b12   b13   b14]';
  mooreSol = pinv(A)*b;   % Moore-Penrose Pseudo-Inverse 
finalAffineMatrix = eye(3)+[mooreSol(1)  mooreSol(2)   0;
                            mooreSol(3)  mooreSol(4)   0;
                                0            0         0];
endfunction