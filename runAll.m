function [ucm, amodal, superpixels, semantics, scenes] = runAll(imNum, rgbImage, depthImage, cameraMatrix)
% function runAll(imNum, rgbImage, depthImage, cameraMatrix)
% Still works by saving all intermediate features as files.
% Input:
%   imNum: the number to associate this file as. If you dont know what to use, just pick any number from 1 to 5000
%   rgbImage: as obtained from the Kinect
%   depthImage: for each pixel has the depth in metres. Missing data is represented as NaNs, in double format. 
%     Should be after projection from the depth camera to the RGB camera.
%   cameraMatrix: to project the depth image into the point cloud.
% Output:
% 

  % Create a new name for the image 
  imName = sprintf('img_%04d', imNum);
  
  paths = getPaths(0);
  % Write the color image
  imwrite(im2uint8(rgbImage), fullfile(paths.colorImageDir, [imName '.png']), 'png');

  % Write the point cloud
  [x3 y3 z3] = getPointCloudFromZ(double(depthImage*100), cameraMatrix, 1);
  save(fullfile(paths.pcDir, [imName '.mat']), 'x3', 'y3', 'z3');

  % Compute UCM features
	computeUCMFeatures(imName, paths, false);

  % Compute the UCM
  featuresToUcm('trainval', paths, imName);

  % Pick threshold for UCM
  allResultsFileName = fullfile(paths.outDir, 'allBUSResults.mat');
  dt = load(allResultsFileName, 'th');
  ucmThresh = dt.th.ucmThresh;

  % Compute Amodal completion
	amodalParam = struct('thresh', [-1 26], 'ucmThresh', ucmThresh);
	ucm2 = getUCM(imName);
	pc = getPointCloud(imName);
	doAmodalCompletion(imName, paths, ucm2, pc, amodalParam);

  % Compute generic, sift and gtextons
	wrapperComputeFeatures1(imName, ucmThresh);
  
  % Compute category specific features
	modelFile = fullfile(paths.modelDir, 'svm-categorySpecific_entryLevel_categorySpecific-all.mat');
  dirName = fullfile(paths.featuresDir, 'categorySpecific-all');
  if(~exist(dirName, 'dir'))
    mkdir(dirName);
  end
  dt = load(modelFile, 'param', 'models');
	categorySpecificFeatures(imName, paths, dt.param, dt.models);

  % Compute Scores for without the scene classification
  modelFileName = fullfile(paths.modelDir, 'svm-full_entryLevel_ancFull_tr-train_val-val_useVal-1.mat');
	[softOutputDir, hardOutputDir] = testModel(imName, paths, modelFileName);

  % Compute the scene classification and scores
	sceneModelName = fullfile(paths.modelDir, 'scene-objScores_tr-train_val-val_useVal-1'); %TODO
  outputFileName = testSceneModel(imName, paths, sceneModelName);
  wrapperComputeFeatures3(imName, outputFileName);
  
  % Compute the final scores and semantic segmentation
  modelFileName = fullfile(paths.modelDir, 'svm-full_entryLevel_ancFullScene_tr-train_val-val_useVal-1.mat');
	[softOutputDir, hardOutputDir] = testModel(imName, paths, modelFileName);

  % Generate visualizations!
  saveUCM(imName, ucmThresh);
  saveAmodalFigs(imName);
  saveContours(imName)
  saveSemanticSegmentation(imName, hardOutputDir, ucmThresh);

  ucm = getUCM(imName);
  [amodal.clusters, amodal.superpixels, amodal.ucmThresh] = getAmodalCompletion(imName);
  superpixels = amodal.superpixels;

  semantics = load(fullfile(softOutputDir, imName));
  dt = load(fullfile(hardOutputDir, imName));
  semantics.segmentation = dt.segmentation;

end
