%% DEMO DEBUG CODE %%
%% trains an old liblinear model and new one and compare weights %%


%NOTE : copy the old liblinear model train.mex* to oldtrain.mex*
if(~exist('strain.mexglx','file') && ~exist('strain.mexa64','file'))
  fprintf('Pal, first copy old liblinear model train.mex* to strain.mex*\n');
  return;
end
  

nfeat = 10000; 
ndim  = 500;
if(nfeat == 2);
  l = [1 ; -1];
else
  l   = 2*(rand(nfeat,1) > 0.5) - 1;
end
x   = rand(nfeat,ndim)';
sx  = sparse(x);


s_opts = [1 2 3 4 5 6]; 

cpos = 10; cneg = 2;


clear model; clear smodel;
clear w_err; clear d_err;
for i = 1:length(s_opts),
  fprintf('+++++++++++++++++++++++++++++++++++++++++\n')
  liblinear_opts = sprintf('-s %i -B 1 -q -w+1 %.2f -w-1 %.2f',...
                           s_opts(i),cpos,cneg);
  fprintf('liblinear opts : %s \n',liblinear_opts);
  
  tic;
    model{i}   = train(l,x,liblinear_opts,'col');
    [pl,pa,pd] = predict(l,x,model{i},'','col');
    t1=toc;
  
  tic;
    smodel{i}     = strain(l,sx,liblinear_opts,'col');
    [spl,spa,spd] = spredict(l,sx,smodel{i},'','col');
    t2=toc;
  
  w_err(i) = max(abs(model{i}.w(:) - smodel{i}.w(:)));
  d_err(i) = max(abs(pd(:) - spd(:)));
  
  fprintf('dense  : %fs\nsparse : %fs\n',t1,t2);
end
fprintf('++++++++ CHECKING DIFFERENCES ++++++++++++++\n')
%check if the weights match
for i = 1:length(s_opts),
    if(w_err(i) > eps || d_err(i) > eps ),
      fprintf('case %i (-s %i) : w_err %f, d_err %f (OUCH)\n',i,s_opts(i),w_err(i),d_err(i));
    else
      fprintf('case %i (-s %i) : w_err %f, d_err %f \n',i,s_opts(i),w_err(i),d_err(i));
  end
end


