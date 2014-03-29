function mU = saveUCM(imSet, ucmThresh)
% function mU = saveUCM(imSet, ucmThresh)
% saveUCM('val', 0);
  paths = getPaths();
  outDir = paths.visUCMDir;
  imList = getImageSet(imSet);
  mU = 0;
  for i = 1:length(imList), 
    ucm = getUCM(imList{i});
    ucm = ucm.*(ucm >= ucmThresh);
    ucm = ucm(3:2:end,3:2:end);
    ucm = imdilate(ucm,strel('disk',2));
    mU = max(max(ucm(:)), mU);
    % Draw boundary of the image
    ucm([1 end], :) = 1;
    ucm(:, [1 end]) = 1;
    outFileName = fullfile(outDir, sprintf('%s.png', imList{i}));
    imwrite(im2uint8(1-ucm),gray(256),outFileName, 'png');
  end
end
