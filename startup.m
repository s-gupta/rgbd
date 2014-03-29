incl = {'ucm', 'COM', 'utils', ...
	'semantics', 'segmentation', 'vis', ...
	'ucmGT', 'classify', 'sceneClassification', 'allBenchmarks', ...
	'external', 'external/vlfeat/toolbox/', 'external/BSR/grouping/lib', 'external/BSR/bench/benchmarks'};
for i = 1:length(incl)
	addpath(incl{i});
end
vl_setup();
addpath(genpath('external/toolbox'));
fprintf('Set up and ready to use...!\n');
