# Clean liblinear-1.5-dense
cd liblinear-1.5-dense
make clean
cd matlab
make clean
rm ../../trainDense.mexa64
rm ../../predictDense.mexa64
cd ../../

# Clean liblinear
cd liblinear-1.94
make clean
cd matlab
make clean
rm ../../train.mexa64
rm ./../predict.mexa64
cd ../../

# Clean imagestack library
cd imagestack
make -f makefiles/Makefile.linux clean
rm ../ImageStack
cd ../

# Clean vl_feat
cd vlfeat
make clean
cd ../

# Clean Piotr's toolbox

# Clean gPb
