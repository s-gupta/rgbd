function im = putsubarray(sz, mask, i1, i2, j1, j2, defaultVal)
% function im = putsubarray(sz, mask, i1, i2, j1, j2, defaultVal)
  im = zeros(sz);
  im(:) = defaultVal;
  szM = size(mask);
  assert(szM(1) == i2-i1+1 && szM(2) == j2-j1+1, 'Size of mask not same as the range for putting it in.\n');
  if(i2 < 1 || i1 > sz(1) || j2 < 1 || j1 > sz(2)) 
    %% Nothing to do, the box is outside the image
  else
    offIim = max(i1,1); 
    offImask = offIim-i1+1;
    offJim = max(j1, 1);
    offJmask = offJim-j1+1;
    h = min(sz(1)-offIim+1, szM(1)-offImask+1);
    w = min(sz(2)-offJim+1, szM(2)-offJmask+1);
    %[offIim offImask offJim offJmask h w]
    im(offIim:offIim+h-1, offJim:offJim+w-1) = mask(offImask:offImask+h-1, offJmask:offJmask+w-1);
  end
end
