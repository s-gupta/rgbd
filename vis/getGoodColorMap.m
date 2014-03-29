function cmap = getGoodColorMap(n)
	cc = colorcube(ceil(n*8/7)+5);
	cc = cc(1:n,:);

	% [IDX C] = kmeans(cc,k);
	% C = max(C,0);
	% 
	%Take one from each cluster
	% figure(1);
	% [val ind] = unique(IDX);
	% A = 1:k;
	% imagesc(A);
	% colormap(cc(ind,:));
	% 
	% 
	% figure(2);
	% A = 1:n;
	% imagesc(A);
	% colormap(cc);

	%Assign the farthest color from the already assigned color
	cc = [hsv(10); cc];
	d = squareform(pdist(cc));
	clear ind;
	ind(1:10) = 1:10;
	for i = 11:n,
		[gr ind(i)] = max(min(d(ind,:),[],1));
	end
% 	A = 1:n;
% 	imagesc(A);
% 	colormap(cc(ind,:));
	cmap = cc(ind,:);
end