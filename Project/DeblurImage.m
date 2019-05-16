I = imread('flower.jpeg');
figure;imshow(I);title('Original Image');

I = rgb2gray(I);
figure;imshow(I);title('Black & White Image');

PSF = fspecial('gaussian',7,10);
Blurred = imfilter(I,PSF,'symmetric','conv');
imshow(Blurred)
title('Blurred Image')

UNDERPSF = ones(size(PSF)-4);
[J1,P1] = deconvblind(Blurred,UNDERPSF);
figure;
imshow(J1);
title('Deblurring with Undersized PSF');

OVERPSF = padarray(UNDERPSF,[4 4],'replicate','both');
[J2,P2] = deconvblind(Blurred,OVERPSF);
figure;
imshow(J2);
title('Deblurring with Oversized PSF');

INITPSF = padarray(UNDERPSF,[2 2],'replicate','both');
[J3,P3] = deconvblind(Blurred,INITPSF);
figure;
imshow(J3)
title('Deblurring with INITPSF')

figure;
subplot(2,2,1);
imshow(PSF,[],'InitialMagnification','fit');
title('True PSF');
subplot(222);
imshow(P1,[],'InitialMagnification','fit');
title('Reconstructed Undersized PSF');
subplot(2,2,3);
imshow(P2,[],'InitialMagnification','fit');
title('Reconstructed Oversized PSF');
subplot(2,2,4);
imshow(P3,[],'InitialMagnification','fit');
title('Reconstructed true PSF');

WEIGHT = edge(Blurred,'sobel',.08);
se = strel('disk',2);
WEIGHT = 1-double(imdilate(WEIGHT,se));
WEIGHT([1:3 end-(0:2)],:) = 0;
WEIGHT(:,[1:3 end-(0:2)]) = 0;
figure;
imshow(WEIGHT);
title('Weight Array');

[J,P] = deconvblind(Blurred,INITPSF,30,[],WEIGHT);
figure;
imshow(J);
title('Deblurred Image');
