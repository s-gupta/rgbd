function [gPb_orient] = globalPb_pieces(imgFile, outFile, overlap, piece_size)
% by Pablo Arbelaez
% arbelaez@ees.berkeley.edu
% 
% DESCRY=IPTION: version of globalPb for large images. Proceeds by chpping
% the image into pieces, processing each piece independently, and then
% merging the result withlinear blending.

if nargin<4, piece_size='250000'; end % in pixels
if nargin<3, overlap='25'; end % in pixels

overlap = str2double(overlap);
piece_size = str2double(piece_size);

%% prepare data

pieceFilePat = outFile(1:end-4);
nb_pieces = img2pieces(imgFile, pieceFilePat, overlap, piece_size);


%% gPb in pieces

for i = 1 : nb_pieces
    globalPb(sprintf('%s_img%d.png',pieceFilePat,i), sprintf('%s_img%d.mat',pieceFilePat,i));
end

%% assemble output with blending

gPb_orient = pieces2gPb(imgFile, pieceFilePat, overlap, piece_size);
save(outFile,'gPb_orient');

%% clean up

for i =1:nb_pieces
    delete(sprintf('%s_img%d.png',pieceFilePat,i));
    delete(sprintf('%s_img%d.mat',pieceFilePat,i));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nb_pieces = img2pieces(imgFile, pieceFilePat, overlap, piece_size)

img = imread(imgFile);
[txo, tyo, nch]=size(img);
orig_size = txo*tyo;
rsz = ceil(sqrt(orig_size/piece_size));

txb = ceil(txo/rsz);
tyb = ceil(tyo/rsz);

nb_pieces= 0;
for sx = 0 : rsz-1,
    for sy = 0 : rsz-1,
        pieceFile = sprintf('%s_img%d.png',pieceFilePat, nb_pieces+1);
        
        xi = max(1, sx*txb-overlap);
        xe = min(txo, (sx+1)*txb+overlap);
        yi = max(1, sy*tyb-overlap); 
        ye = min(tyo, (sy+1)*tyb+overlap); 
        
        piece = img( xi:xe,yi:ye,:);
        imwrite(piece,pieceFile);
        nb_pieces = nb_pieces+1;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gPb_orient = pieces2gPb(imgFile, pieceFilePat, overlap, piece_size)


img = imread(imgFile);
[txo, tyo, nch]=size(img);
orig_size = txo*tyo;
rsz = ceil(sqrt(orig_size/piece_size));

txb = ceil(txo/rsz);
tyb = ceil(tyo/rsz);

gPb_orient = zeros(txo,tyo,8);
mask_all = zeros(txo,tyo);
mask_piece = zeros(txo,tyo);

pc= 0;
for sx = 0 : rsz-1,
    for sy = 0 : rsz-1,
        
        pieceFile = sprintf('%s_img%d.mat',pieceFilePat, pc+1);
        tmp=load(pieceFile);
        gPb_piece = tmp.gPb_orient;
        
        xi = max(1, sx*txb-overlap);
        xe = min(txo, (sx+1)*txb+overlap);
        yi = max(1, sy*tyb-overlap);
        ye = min(tyo, (sy+1)*tyb+overlap);
        
        mask_piece(:) = 1;
        mask_piece(xi:xe,yi:ye) = 0;
        dst=bwdist(mask_piece);
        dst(dst>2*overlap)=2*overlap; dst=dst/max(dst(:));
        
        for o = 1: 8
            gPb_orient( xi:xe,yi:ye,o) = dst(xi:xe, yi:ye).*gPb_piece(:,:,o) + gPb_orient( xi:xe,yi:ye,o);
        end
        
        mask_all( xi:xe,yi:ye) = dst(xi:xe,yi:ye) + mask_all( xi:xe,yi:ye);
        pc = pc+1;
    end
end

for o = 1: 8
        gPb_orient( :,:,o) = gPb_orient( :,:,o) ./ mask_all;
end


