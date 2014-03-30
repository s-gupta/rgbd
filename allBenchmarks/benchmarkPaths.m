function c = benchmarkPaths(setPath)
  [thisdir] = fileparts(mfilename('fullpath'));
	
  c.rootDir = fullfile(thisdir, '..'); 
		c.benchmarkDataDir = fullfile(c.rootDir, 'data', 'benchmarkData');
			c.benchmarkGtDir = fullfile(c.benchmarkDataDir, 'groundTruth');
			c.sceneClassFile = fullfile(c.benchmarkDataDir, 'sceneClassification', 'imgAllScene');
	
	c.benchmarkCache = fullfile(thisdir, '..', 'benchmarkCache');
		c.amodalTmpDir = fullfile(c.benchmarkCache, 'amodal', 'benchmarks');
		c.contoursTmpDir = fullfile(c.benchmarkCache, 'contours', 'benchmarks');
	
	c.floorId = 2;
end
