% simple test extracting MKD (Multiple Kernel Descriptor) from a 64x64 patch
%
% Authors: A. Mukundan, G. Tolias, O. Chum. 2017. 

addpath(genpath('./'));

% load one of the pre-saved configurations (contains whitening learned on photo-tourism dataset)
load('precomp_bmvc2017/mkd_liberty.mat')
% load('precomp_bmvc2017/mkd_yosemite.mat')
% load('precomp_bmvc2017/mkd_notredame.mat')

% load a sample patch
patch = imresize(im2double(rgb2gray(imread('peppers.png'))), [cmkd.s, cmkd.s]);
% descriptor extraction
v = mkdw(patch, cmkd);
