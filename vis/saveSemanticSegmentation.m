function saveSemanticSegmentation(imSet, inDir, ucmThresh)
% function saveSemanticSegmentation(imSet, inDir, ucmThresh)
%   inDir = 'cachedir/segdetV5/output/semanticSegmentation/svm-full-mclWt-rawWt_entryLevel_ancFullSceneDet4v3_spArea-00-v2_tr-train1_val-train2_useVal-1/';
%   ucmThresh = 0.16;
%   saveSemanticSegmentation('img_5001', inDir, ucmThresh)

  paths = getPaths();
  outDir = paths.visSSDir;
  
  imList = getImageSet(imSet);
  
  dt = getMetadata('classMapping40');
  className = dt.className;
  % imList = {'img_6407'}

  for i = 1:length(imList),
    I = getColorImage(imList{i});

    dt = load(fullfile(inDir, imList{i}));
   
    segm = dt.segmentation;

    ucm = getUCM(imList{i});
    ucm = ucm(3:2:end,3:2:end) >= ucmThresh;
    
    I = im2double(I);
    ucm = imdilate(ucm,strel('disk',0));
    I = bsxfun(@times,I,~ucm);

    img = drawRegionsText(segm, className, 1, 20);
    J = drawRegionsPaper(I, segm+1);
    J = imresize(J, size(img(:,:,1)),'nearest');
    J = bsxfun(@times, J, img == 1 & imresize(ucm, size(img)) == 0);
    J = imresize(J, size(I(:,:,1)));
    % figure(1); imagesc(J);
    
    outFileName = fullfile(outDir, sprintf('%s.png', imList{i}))
    imwrite(J ,outFileName, 'png');
  end
end
%  
%      tp = ones(size(img))*0.5;
%      tp = bsxfun(@times, img == 0 & imresize(ucm, 2) == 0,tp);
%      tp(:) = 1-tp(:);
%  
%    %     figure(1); imagesc(tp);
%    %     figure(2); imagesc(J);
%           
%        outFileName = sprintf('%s/overlay/img_%04d.png',outDir, imList{i})
%        imwrite(J, outFileName, 'png', 'Alpha',tp(:,:,1));
%  
%    %     drawRegionsTextV5(I, segm, className);
%    %     set(gcf, 'Position',[0 0 size(I,2) size(I,1)],'Visible','off');
%    %     set(gca, 'Position',[0 0 1 1]);
%    %     axis off;
%    %     
%    %     img = hardcopy(1, '-dzbuffer', '-r200');
%    %     img = imresize(img, 2*[size(I,1), size(I,2)]);
%    %     img = im2uint8(img);
%    % 
%    %     outFileName = sprintf('%s/full/img_%04d.png',outDir, imList{i});
%    %     imwrite(img,outFileName,'png');
%         
%        
%        
%    %     pause;
%        
%        
%    %     outFileName = sprintf('%s/overlay/img_%04d_%s.png',outDir, imList{i}, outFileVer);
%    %     imwrite(J,outFileName,'png','Alpha',tp(:,:,1));
%    %     
%    %     K = (im2double(I)+J)/2;
%    %     outFileName = sprintf('%s/full/img_%04d_%s.png',outDir, imList{i}, outFileVer);
%    %     imwrite(J,outFileName,'png');
%  
%    %     figure(1); clf; imagesc(I);
%    %     figure(2); imagesc(J); title(sprintf('%d', imList{i}));
%    %     figure(3); imagesc(K); title(sprintf('%d', imList{i}));
%    end
%  
%  end
