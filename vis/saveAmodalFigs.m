function saveAmodalFigs(imSet)
% function saveAmodalFigs(imSet)
% saveAmodalFigs('val')
  paths = getPaths();
  inDir = paths.amodalDir;
  outDir = paths.visAmodalDir; 

  mkdir(fullfile(outDir, 'overlay'));
  mkdir(fullfile(outDir, 'full'));;
  
  imList = getImageSet(imSet);

  for i = 1:length(imList),
    for pick = [2],
      I = getColorImage(imList{i});

      dt = load(fullfile(inDir, imList{i}));
      T = dt.clusters(:,pick);
      cT = accumarray(T,ones(size(T)));
      j = 0; G = zeros(size(T));
      for k = 1:length(cT),
        if(cT(k) > 1),
          j = j + 1;
          G(T == k) = j+1;
        end
      end
      
      ucm = getUCM(imList{i});
      ucmThresh = dt.ucmThresh;
      superpixels = bwlabel(ucm < ucmThresh);
      ucm = ucm(3:2:end,3:2:end) >= dt.ucmThresh;

      cmap = double(hsv(max(G(:))));
      cmap = [0 0 0; cmap];
      J = double(ind2rgb(G(dt.superpixels),cmap));
      J = bsxfun(@times,J,~ucm);
      
      tp = ones(size(J))*0.5;
      tp = bsxfun(@times, ucm == 0,tp);
      tp(:) = 1-tp(:);
      outFileName = fullfile(outDir, 'overlay', sprintf('%s.png', imList{i}));
      imwrite(J,outFileName,'png','Alpha',tp(:,:,1));
      
      K = (im2double(I)+J)/2;
      outFileName = fullfile(outDir, 'full', sprintf('%s.png', imList{i}));
      imwrite(K,outFileName,'png');
    end
  end
end
