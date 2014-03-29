function saveContours(imSet)
  paths = getPaths();
  outDir = paths.visCCDir; 
  
  imList = getImageSet(imSet);

  ucmThresh = 0.20;

  td = 0.1;
  tn = 0.15;
  bgThresh = 0;
  i = 1;
  s = 0.01;
  
  for i = 1:length(imList),
    try
    dgThresh = td*4;
    ngThresh = tn*3;
    im_i = imList{i};
        
    I = getColorImage(im_i);
    ucm = getUCM(im_i);
    ucm = ucm(3:2:end, 3:2:end);
    
    % figure(1); subplot(2,3,1); imagesc(I);
    % figure(1); subplot(2,3,2); imagesc(pc(:,:,3));
    
    dt = load(fullfile(paths.gradientsForRecognition, 'zgMax', im_i));
    ng1 = sum(dt.signal(:,:,1:4), 3);
    ng2 = sum(dt.signal(:,:,5:8), 3);
    dg = sum(dt.signal(:,:,9:12), 3);
    dt = load(fullfile(paths.gradientsForRecognition, 'bgMax', im_i));
    bg = sum(dt.signal(:,:,1:3), 3);

    dg = dg.*double(ucm >= ucmThresh);
    ng1 = ng1.*double(ucm >= ucmThresh);
    ng2 = ng2.*double(ucm >= ucmThresh);
    bg = bg.*double(ucm >= ucmThresh);
    
    ng = max(ng1, ng2);
    whichNg = (sign(ng2-ng1)+1)/2+1;
    whichNg(whichNg == 0.5) = 2;
    
    Iout = zeros(size(I,1),size(I,2));
    Iout(bg > bgThresh) = 1;
    ng1(whichNg ~= 1) = 0;
    ng2(whichNg ~= 2) = 0;
    Iout(ng1 >= ngThresh) = 2;
    Iout(ng2 >= ngThresh) = 3;
    Iout(dg >= dgThresh) = 4;
    
    figure(1); subplot(1,3,1); imagesc(I);
    figure(1); subplot(1,3,2); imagesc(Iout, [0 4]); title(sprintf('%0.2f, %0.2f', td, tn));
    
    cc(:,:,1) = Iout == 4;
    cc(:,:,2) = Iout == 3;
    cc(:,:,3) = Iout == 2;
    
    cc = imdilate(cc, strel('disk', 1));
    % I = rgb2gray(I);
    I = repmat(I, [1 1 3]);
    J = drawContoursColor(im2double(I),double(cc));
    
    figure(1); subplot(1,3,3); imagesc(J);
    
    fileName = fullfile(outDir, sprintf('%s.png', im_i)); 
    imwrite(im2uint8(J), jet(256), fileName, 'png');

  %    tp = ones(size(cc))*0.5;
  %    tp = bsxfun(@times, max(cc,[],3) == 0,tp);
  %    tp(:) = 1-tp(:);
  %    outFileName = sprintf('%s/overlay/img_%04d.png',outDir, im_i);
  %    imwrite(im2uint8(cc), outFileName, 'png', 'Alpha',tp(:,:,1));
  %     
  %     fileName = sprintf('%s/UCM/depthV2_100/img_%04d.png', c.resultsDir, im_i);
  %     imwrite(Iout == 4, fileName, 'png');
  %     
  %     fileName = sprintf('%s/UCM/normal1V2_100/img_%04d.png', c.resultsDir, im_i);
  %     imwrite(Iout == 2, fileName, 'png');
  %     
  %     fileName = sprintf('%s/UCM/normal2V2_100/img_%04d.png', c.resultsDir, im_i);
  %     imwrite(Iout == 3,  fileName, 'png');
  %     
  %      fileName = sprintf('%s/UCM/albedoV2_100/img_%04d.png', c.resultsDir, im_i);
  %      imwrite(Iout == 1, fileName, 'png');
    catch ee
      prettyexception(ee);
      fprintf('Could not process, %s', im_i);
    end
  end
end
