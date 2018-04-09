%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  CSC3185 Assignment 1
%
%  Name: Àî²©î£
% 
%  Student Number: 115010170
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Describe how your method works below:
%--I tried to use Median_Cut Algorithm to solve this problem. 
%
%--But during the implement period I find the Algorithm is in three 
%dimensionand it is hard to be implemented in two dimension.
%
%--So, I tried to make this cut procedure linear.
%
%--What we should to is to cut the 256 into 256 blocks and each block
%should have different R G B value. In order to make the goal, R should 
%be cut 8 times, G should be cut 8 times in every R block, and B should be 
%cut 4 times in every G block. By this means finally the line for 0 to 255 
%will have 256 entries and each entries will have 3 values which are R G B.
%
%--In this program, at first I cut the line 0 to 255 by R's value into 8
%blocks, then use for loop to cut the line 0 to 255 by G's value into 64
%blocks (8 smaller blocks for each R block), and cut the line 0 to 255 by
%B's value into 256 blocks (4 much more smaller blocks for each G block).
%
%--Then the LUT will have size for 256 * 3.
%
%--When I use lena-color.bmp the error is 184 but when I use another
%picture the error change to 145 and lower.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Add your code below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LUT = [];

%%%%below is for R's label and R's value:

R = [1:256];
Label = zeros(size(R,2),size(R,1));
% to make R[1:256] rather than [0:255] is more convience to use in program
% make a matrix Label to store the value of each blocks.

medianR = floor(median(R));
higherR = [median(R):256];
lowerR = [0:median(R)];
Label(medianR:256) = bitset(uint8(0),1);
% use median function to differentiate the higher part and lower part of
% the whole line, and set the higher part with its first bit 1.

medianR1 = floor(median(lowerR));
medianR2 = floor(median(higherR));
l_lowerR = [0:medianR1];
l_higherR = [medianR1:medianR];
h_lowerR = [medianR:medianR2];
h_higherR = [medianR2:256];
Label(medianR1:medianR) = bitset(uint8(0),4);
Label(medianR2:256) = bitset(uint8(1),4);
% this is second time cutting, so this time the l_higherR part and h_higher
% part should have their fourth bit set 1.

medianR3 = floor(median(l_lowerR));
medianR4 = floor(median(l_higherR));
medianR5 = floor(median(h_lowerR));
medianR6 = floor(median(h_higherR));
Label(medianR3:medianR1-1) = bitset(uint8(0),7);
Label(medianR4:medianR) = bitset(uint8(8),7);
Label(medianR5:medianR2-1) = bitset(uint8(1),7);
Label(medianR6:256) = bitset(uint8(9),7);
% this is third time cutting, so this time we have 7 medians.
% the procedure is like this £º
%
% 0    R3    R1    R4    R    R5    R2    R6    255
% |    |     |     |     |    |     |     |      |
%------------------------------------------------------>
% So for R3-R1 , R4-R , R5-R2 , R6-255 should have their 7th bit set 1.


for i = 1:8
    R = reshape(R,256,1);
    R((i-1)*32 <= R & R <= 32*i) = floor(median(32*(i-1):32*i));
    i = i + 1;
    R1 = [Label;R];
end
Label = reshape(R1,256,2);
% to store the value of R in to the matrix Label.

L_v = [0 64 8 72 1 65 9 73];
%L_v means label value to store the label value of R G B.

%%%below is G's part: for every R block G should cut it into 8 blocks:
for j = 1:8
    G = [(j-1)*32+1:j*32];
    medianG = floor(median(G));
    lowerG = [min(G(:)):median(G)];
    higherG = [median(G):max(G(:))];
    Label(medianG:max(G(:))) = bitset(uint8(L_v(j)),2);
    % to make G's block size equal to every R block.
    % use median function to differentiate each higher part and lower part
    % make the higher part have its 2nd bit set 1.
    % use L_v to represent the label value stored before but do not record
    % the change of L_v.
    
    medianG1 = floor(median(lowerG));
    medianG2 = floor(median(higherG));
    l_lowerG = [min(G(:)):medianG1];
    l_higherG = [medianG1:medianG];
    h_lowerG = [medianG:medianG2];
    h_higherG = [medianG2:max(G(:))];
    Label(medianG1+1:medianG) = bitset(uint8(L_v(j)),5);
    Label(medianG2+1:max(G(:))) = bitset(uint8(L_v(j)+2),5);
    % 2nd time cutting, 4 parts. each part higher than median should have
    % its label value's 5th bit set 1.
    % for the part have been in the first time cutting's higher part it
    % should have its L_v + 2, because their 2nd bit had been set 1.
    
    medianG3 = floor(median(l_lowerG));
    medianG4 = floor(median(l_higherG));
    medianG5 = floor(median(h_lowerG));
    medianG6 = floor(median(h_higherG));
    Label(medianG3+1:medianG1) = bitset(uint8(L_v(j)),8);
    Label(medianG4+1:medianG) = bitset(uint8(L_v(j)+16),8);
    Label(medianG5+1:medianG2) = bitset(uint8(L_v(j)+2),8);
    Label(medianG6+1:max(G(:))) = bitset(uint8(L_v(j)+18),8);
    % third time cutting, 8 parts. each part higher than median should have
    % its label value's 8th bit set 1.
    
end

% below is to set G's value for each part
temp_G = [1:32];
temp_G(1:4) = 16;
temp_G(5:8) = 48;
temp_G(9:12) = 80;
temp_G(13:16) = 112;
temp_G(17:20) = 144;
temp_G(21:24) = 176;
temp_G(25:28) = 208;
temp_G(29:32) = 240;
   
temp_G = reshape(temp_G,32,1);
G = repmat(temp_G,8,1);
% repeat G value's format for 8 times to suit in Label's size.
Label = [Label G];

%%%below is for B's value:
[a,b]= unique(Label(:,1));
[b,b] = sort(b);
L_v = a(b,:);
% Because we have cut the line 0-255 in to 8 blocks by R and each R block
% have been cut into 8 blocks by G, so this time we have 64 blocks on this
% line. So L_v this time should have 64 values.
% above three line is to make the Label value unique and follow the
% originalorder.
for k = 1:64
    B = [(k-1)*4+1:k*4];
    medianB = floor(median(B));
    lowerB = [min(B(:)):medianB];
    higherB = [medianB:max(B(:))];
    
    medianB1 = floor(median(lowerB));
    medianB2 = floor(median(higherB));
    
    Label(medianB+1:max(B(:))) = bitset(uint8(L_v(k)),3);
    Label(medianB1+1:medianB) = bitset(uint8(L_v(k)),6);
    Label(medianB2+1:max(B(:))) = bitset(uint8(L_v(k)+4),6);

end

% for every four entry B should have value from [32 96 160 224]
temp_B = [1:4];
temp_B(1:1) = 32;
temp_B(2:2) = 96;
temp_B(3:3) = 160;
temp_B(4:4) = 224;
temp_B = reshape(temp_B,4,1);
B = repmat(temp_B,64,1);
Label = [Label B];

[a,b] = unique(Label(:,1));
[b,b] = sort(b);
L_v = a(b,:);
% the above three line can make sure Label's first column have 256
% different value.
LUT = Label;
LUT = sortrows(LUT,1);
LUT(:,1) = [];

P = imread('lena-color.bmp');%Read this image into Matlab
IND = zeros(size(P,1),size(P,2));  %obtain a matrix IND with size 256¡Á256
for i=1:size(P,1),
    for j=1:size(P,2),
        
        C0 = double(P(i,j,:));
        C = reshape(C0,1,3);   % convert it to a row vector 
        min_e = mean((C-LUT(1,:)).^2);  %the mean square error of first row
        min_ind = 1;
        for k=2:size(LUT,1),
            e = mean((C-LUT(k,:)).^2);
            if (e < min_e)
                min_e = e;
                min_ind = k;
            end
        end
        IND(i,j) = min_ind;
    end
end

P2 = zeros(size(IND,1),size(IND,2),3);
for i=1:size(IND,1),
    for j=1:size(IND,2),
        C = LUT(IND(i,j),:);
        for k=1:3,
            P2(i,j,k) = C(k);
        end
    end
end
P2 = uint8(P2);
imshow(P2);

imwrite(P2,'lena-color-b.bmp')
A = imread('lena-color-b.bmp');
P = imread('lena-color.bmp');
err = immse(P,A);
% use immse to compare the difference of to photos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  End of your code 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = toc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add a line below to save your variables LUT, IND, P2, err, t under the file name a1_[student_number].mat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save a1_115010170 LUT IND P2 err t