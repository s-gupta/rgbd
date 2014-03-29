function out = drawRegionsText(reg, name, imSz, textSz)
  regI = reg;
	
	mask = separateInstancesGT(regI);
	J = ones(size(regI));
	
	% figure(1); imagesc(J,[0 1]); colormap gray;
	
	centroids = zeros(0,2);
	for i = 1:max(mask(:)),
		m = mask == i;
		m = imclose(m,strel('disk',3));
		m = imfill(m,'holes');
		[c2, c1] = find(bwmorph(m,'shrink',inf) == 1);
    centroids(i,:) = [c1 c2];
	end
	
	ar = accumarray(mask(mask>0),mask(mask>0)>0);
	
	id = accumarray(mask(mask>0),regI(mask>0), [], @unique);
  out = true(round(size(reg)*imSz));
	for j = find(ar' > 1000),
    fprintf('.');
    m = char2img(name{id(j)}, textSz); m = m{1};
    % Place this at the centroid
    sz = size(m);
    i1 = round(centroids(j,2))-sz(1)/2;
    i2 = i1+sz(1)-1;
    j1 = round(centroids(j,1))-sz(2)/2;
    j2 = j1+sz(2)-1;
    out = out & putsubarray(size(out), m, i1, i2, j1, j2, 1) == 1;
    % text(centroids(j,1)-20, centroids(j,2), name{id(j)},'FontSize', 18);
  end
end
