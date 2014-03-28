%% Compute globalPb and hierarchical segmentation for an example image.

addpath(fullfile(pwd,'lib'));

%% 1. compute globalPb on a small image to test mex files
clear all; close all; clc;

imgFile = 'data/101087_small.jpg';
outFile = 'data/101087_small_gPb.mat';

gPb_orient = globalPb(imgFile, outFile);
delete(outFile);

figure; imshow(max(gPb_orient,[],3)); colormap(jet);

ucm = contours2ucm(gPb_orient, 'imageSize');
figure;imshow(ucm);