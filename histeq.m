


input_img = imread('outdoor.png');
ref_img = imread('people.png');
input_img = rgb2gray(input_img);
ref_img = rgb2gray(ref_img);
% H
imh_i = imhist(input_img);
imh_r = imhist(ref_img);

% P(H)
s_imh_i = sum(imh_i); %total intensity values of i/p img hist
s_imh_r = sum(imh_r); %total intensity values of ref img hist
P_Hi = imh_i/s_imh_i; %P(H) for the input image
P_Hr = imh_r/s_imh_r; %P(H) for the reference image

%CDF
CDFi = zeros(1,256);
CDFr = zeros(1,256);
CDFi(1) = P_Hi(1); 
CDFr(1) = P_Hr(1); 
for i = 2:256
    CDFi(i) = CDFi(i-1) + P_Hi(i); 
    CDFr(i) = CDFr(i-1) + P_Hr(i); 
end

%Rounded
cdfi_rounded = round(255*CDFi);
cdfr_rounded = round(255*CDFr);

new_hist = zeros(256);
%mapping 
for i=1:256
    cdf_dif = abs(CDFi(i)-CDFr(1));
    for j =1:256
        if abs(CDFi(i)-CDFr(j)) < cdf_dif
            new_hist(i) = cdfr_rounded(j);
        end
    end
end

%transformation
si = size(input_img);
sr = size(ref_img);

% generate the input image after histogram equalization and mapping
ep_img = zeros(si);
for i = 1:si(1)
    for j = 1:si(2)
        t = input_img(i,j)+1;  % pixels values of input image
        ep_img(i,j) = new_hist(t); % mapping with the equalized histogram
    end
end 

% additional work :) 
eq_img = zeros(sr);
for i = 1:sr(1)
    for j = 1:sr(2)
        t = ref_img(i,j)+ 1;  % pixels values of input image
        eq_img(i,j) = cdfr_rounded(t); % mapping with the equalized histogram
    end  
end  

subplot(2,2,1); imshow(ep_img,[]);title('output image'); % the result
subplot(2,2,2); bar(new_hist);title('output image histogram'); %the mapped hsitogram
subplot(2,2,3); imshow(eq_img,[]);title('o/p reference image');
subplot(2,2,4) ;bar(cdfr_rounded);title('o/p reference image histogram');

%done 30/11/2021
% Bilal Hoor
%email: bilalahoor@gmail.com
% ^_^