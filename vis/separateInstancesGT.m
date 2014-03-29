function inst = separateInstancesGTV1(instance)
	inst = zeros(size(instance),'uint16');
	count = 0;
	for i = 1:max(instance(:)),
		mask = instance == i;
		mask = imclose(mask,strel('disk',3));
		[L N] = bwlabel(mask,8);
		mask = instance == i;
		L(instance ~= i) = 0;
		
		u = unique(L(:))+1;
		map(u) = 1:length(u);
		L = map(L+1)-1;
	
		inst(find(mask)) = L(find(mask)) + count;
		if(nnz(mask) > 0)
			count = count + max(L(mask));
		end
	end	
end
