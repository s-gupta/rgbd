if 0
  dirs = {'/work2/sgupta/rmrc/cachedir/segdetV5/cache/visOut/det',...
    '/work2/sgupta/rmrc/cachedir/segdetV5/cache/visOut/amodal/full',...
    '/work2/sgupta/rmrc/cachedir/segdetV5/cache/visOut/ss',...
    '/work2/sgupta/rmrc/cachedir/segdetV5/cache/visOut/ucm',...
    '/work2/sgupta/rmrc/cachedir/segdetV5/cache/visOut/cc',...
    '/home/eecs/sgupta/Projects/cvpr2013/cameraReady/results/KinectColorSmall', ...
    '/home/eecs/sgupta/Projects/cvpr2013/cameraReady/results/depthSmall',...
    };

  sfx = {'', '', '', '', '', '', '_V0'};
  expr = {'det', 'amodal', 'ss', 'ucm', 'cc', 'color', 'depth'};

  ids = [6022, 5118, 5296, 5464, 6092, 6204, 6291, 5001, 5733, 6288, 5802, 5945];
  outDir = '/work2/sgupta/rmrc/cachedir/segdetV5/cache/visOut/submit/';
  for i = 1:length(ids)
    for j = 1:length(dirs),
      f1 = fullfile(dirs{j}, sprintf('img_%04d%s.png', ids(i), sfx{j}));
      f2 = fullfile(outDir, sprintf('results-%s-img_%04d.png', expr{j}, ids(i)));
      fprintf('cp %s %s\n', f1, f2);
      copyfile(f1, f2);
    end
  end
end

if 1
  % Generate the final big table here
  [v, f] = accumMats('cachedir/segdetV5/cache/outs/*val-indivCat.mat', {'dt.evalResExternal.accuracies', 'dt.evalResExternal.fwavacc', 'dt.evalResExternal.avacc', 'mean(dt.evalResRawScores.maxIU)', 'dt.evalResExternal.pixacc', 'dt.evalResExternal.className'});
  ind = [1 5 9 6 8 7];
  f(ind)
  for i = 1:6,
    v{i} = v{i}(ind);
  end

  acc = cat(2, v{1}{:});
  fwavacc = cat(2, v{2}{:});
  avacc = cat(2, v{3}{:});
  maxIU = cat(2, v{4}{:});
  pixacc = cat(2, v{5}{:});
  acc = cat(1, acc, fwavacc, avacc, maxIU, pixacc);
  acc(end+1,:) = mean(acc([3 4 5 6 7 8 10 12 14 17 18 25 29 32 33 34 35 36], :));
  className = v{6}{1};

  acc = acc*100;

  className = {className{:}, '$fwavacc$', '$avacc$', '$mean(maxIU)$', '$pixacc$', 'objAcc'};

  K = 15;
  for i = 1:K:2*K+1,
    lOut = genTable(acc(i:min(i+K-1, end), :)', {'\cite{silbermanECCV12}', '\cite{renCVPR12}', 'our', 'our+det', 'our+scene', 'our+scene+det'}, className(i:min(end,i+K-1)), '', @(x)sprintf('%0.3g', x));
    lOut
  end
end

if 0
  % Put everything together
  [v, f] = accumMats('cachedir/segdetV5/cache/outs/*val-indivCat.mat', {'dt.evalResExternal.accuracies', 'dt.evalResExternal.fwavacc', 'dt.evalResExternal.avacc', 'mean(dt.evalResRawScores.maxIU)', 'dt.evalResExternal.pixacc', 'dt.evalResExternal.className'});

  ind = [3 2 13 10 12 11];
  f(ind)
  for i = 1:6,
    v{i} = v{i}(ind);
  end


  acc = cat(2, v{1}{:});
  fwavacc = cat(2, v{2}{:});
  avacc = cat(2, v{3}{:});
  maxIU = cat(2, v{4}{:});
  pixacc = cat(2, v{5}{:});
  acc = cat(1, acc, fwavacc, avacc, maxIU, pixacc);
  className = v{6}{1};

  acc = acc*100;

  className = {className{:}, '$fwavacc$', '$avacc$', '$mean(maxIU)$', '$pixacc$'};

  for i = 1,
    lOut = genTable(acc(i:min(i+K-1, end), :)', {'\cite{silbermanECCV12}-SC', '\cite{silbermanECCV12}-LP', 'our', 'our+det', 'our+scene', 'our+scene+det'}, className(i:min(end,i+K-1)), '', @(x)sprintf('%0.3g', (x)));
    lOut
  end
end
