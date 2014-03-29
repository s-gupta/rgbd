# Build liblinear-1.5-dense
cd liblinear-1.5-dense/matlab
make
cp train.mexa64 ../../trainDense.mexa64
cp predict.mexa64 ../../predictDense.mexa64
cd ../../

# Build liblinear
cd liblinear-1.94/matlab
make
cp train.mexa64 ../../train.mexa64
cp predict.mexa64 ../../predict.mexa64
cd ../../

# Build imagestack library
cd imagestack
make -f makefiles/Makefile.linux
cp bin/ImageStack ../.
cd ../

# Compile vl_feat
cd vlfeat
make
cd ../

# Compile Piotr's toolbox
cd toolbox
matlab -r 'addpath(genpath(pwd())); toolboxCompile; exit'
cd ../

# Compile gPb
cd BSR/grouping/source
sh build.sh
cd ../../../
