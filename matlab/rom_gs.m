%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Project Name :img_rom.m
% FPGA Open Source Studio
% Author:Lipu
% Description: image to rom
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc

img1 = imread('st.bmp');
gray=rgb2gray(img1);
[a,b,c]= size(img1);
R1=img1(:,:,3);

w = a*b;
k = 0;
% rom.v
fid = fopen('rom_st.v','w');
fprintf(fid,'module rom_st (clock, address, q);\n');
fprintf(fid,'input clock;\n');
fprintf(fid,'output [0:0] q;\n');
fprintf(fid,'input [14:0] address;\n');
fprintf(fid,'reg [0:0] dout;\n');
fprintf(fid,'reg [0:0] ram [32767:0];\n');
fprintf(fid,'assign q = dout;\n');
fprintf(fid,'\n');
fprintf(fid,'initial begin\n');
for i=1:a
    for j= 1:b 
       fprintf(fid,'  ram[%d]  = %d;\n',k,R1(i,j)>128); %frame1
       k=k+1;
    end
end
fprintf(fid,'end\n');
fprintf(fid,'\n');
fprintf(fid,'always @(posedge clock) begin\n');
fprintf(fid,'  dout <= ram[address];\n');
fprintf(fid,'end\n');
fprintf(fid,'\n');
fprintf(fid,'endmodule\n');
fclose(fid);

figure,
subplot(221),imshow(R1),title('gray');
