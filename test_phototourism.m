
% edited version of https://github.com/abursuc/kde
% 
% script to extract descriptors, learn whitening and evaluate on the Photo-tourism dataset
%
% Modified for Multiple-Kernel Local-Patch Descriptor, BMVC 20107
% Authors: A. Mukundan, G. Tolias, O. Chum, 2017

addpath(genpath('./'));

pfolder 		=  '/data/patches/';    % brown dataset folder
ofolder 		=  pfolder;				  % output folder
s 				=  64;   % patch size
kapparho 	=  8;		% kappa for kernel on rho (radius in polar coordinates)
kappaphi		=	8;		% kappa for kernel on phi (angle in polar coordinates)
kappatheta	=	8;		% kappa for kernel on theta (relative gradient angle)
nrho 			=  2;		% number of frequencies for approx. of kernel on rho  
nphi			=	2;		% number of frequencies for approx. of kernel on phi
ntheta		=	3;		% number of frequencies for approx. of kernel on theta

kappaxy 		=  1; 	% similarly for the Cartesian case
kappatheta2 =  8;	   % similarly for the Cartesian case
nxy 			=  1;	   % similarly for the Cartesian case
ntheta2 		=  3;    % similarly for the Cartesian case

% coefficients for the individual embeddings
crho 		= embcoef(kapparho, nrho);
cphi 		= embcoef(kappaphi, nphi);
ctheta 	= embcoef(kappatheta, ntheta);
cxy 	= embcoef(kappaxy, nxy);
ctheta2 	= embcoef(kappatheta2, ntheta2);

% pre-compute phi-otimes-rho embedding for 64x64 patch pixels
[epos, phi] = embfixedpos(cphi, crho, s, 'polar');
prepolar.epos = epos; prepolar.phi = phi;
[epos, phi] = embfixedpos(cxy, cxy, s, 'cart');
precart.epos = epos; precart.phi = phi;

if exist([pfolder, '/liberty/'], 'file') ~= 7 | exist([pfolder, '/notredame/'], 'file') ~= 7 | exist([pfolder, '/yosemite/'], 'file') ~= 7
	system('wget http://cmp.felk.cvut.cz/~toliageo/ext/brown/data.tar.gz --directory-prefix /tmp/'); 
	if exist(pfolder, 'file') ~=7, mkdir(pfolder); end 
	system(sprintf('tar -xzvf /tmp/data.tar.gz -C %s', pfolder));
end

fprintf('Extracting descriptors.\n')
datasets = {'liberty', 'notredame', 'yosemite'};
for d = 1:numel(datasets)
	dataset = datasets{d};
	fprintf('Dataset %s\n', dataset);
	clear v patches;
	patches = load_ext(fullfile(pfolder, dataset, [dataset, '_patches.fvecs']));

	parfor i = 1:size(patches, 2)
		patch = patches(:, i);
		patch = reshape(patch, s, s);
		% Kernel DEscriptor (KDE) extraction
		a = mkd(patch, prepolar, ctheta, 1);
		b = mkd(patch, precart, ctheta2, 0);
		v{i} = vecpostproc([a; b]);
	end
	% collect all dataset vectors
	vecs{d} = cell2mat(v);
end

fprintf('Learning the whitening.\n')
	L = {};
	for d = 1:numel(datasets)
	  dataset = datasets{d};
	  pairs = load(sprintf('%s/%s/m50_500000_500000_0.txt',pfolder, dataset));
	  pos = find(pairs(:, 2)==pairs(:, 5));
	  L{end+1} = whitenlearn(vecs{d}, pairs(pos, 1)+1, pairs(pos, 4)+1);
	  L{end}.trainset = dataset;
	end

fprintf('Evaluating.\n')
% evaluate each dataset with Lw variants
for d = 1:numel(datasets)
  dataset = datasets{d};
    pairs = load(sprintf('%s/%s/m50_100000_100000_0.txt',pfolder, dataset));
    for i = 1:numel(L)
    	if d == i, continue; end
      for dim = [128]
        v = whitenapply(vecs{d}, L{i}.m, L{i}.P, dim);
        res = eval_brown (v, pairs);
        fprintf('%10s MKD  %3dD whitening learned on %10s : fpr95 = %.4f\n', dataset, dim, L{i}.trainset, res.fpr_95);
      end
  end
end

% save the configuration learned
cmkd.s = s; cmkd.kapparho = kapparho; cmkd.kappaphi =	kappaphi; cmkd.kappatheta =	kappatheta;
cmkd.nrho	= nrho; cmkd.nphi = nphi; cmkd.ntheta = ntheta; 
cmkd.kappaxy = kappaxy; cmkd.kappatheta2 = kappatheta2;	   
cmkd.nxy = nxy; cmkd.ntheta2	= ntheta2; 
cmkd.crho = crho; cmkd.cphi = cphi; cmkd.ctheta = ctheta; cmkd.cxy = cxy; cmkd.ctheta2 = ctheta2;
cmkd.prepolar = prepolar; cmkd.precart = precart;
for d = 1:numel(datasets), cmkd.lw = L{d}; save(sprintf('%s/mkd_%s.mat', ofolder, datasets{d}), 'cmkd'); end
