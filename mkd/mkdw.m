% compute kernel descriptor for a patch and perform whitening
%
% Usage: v = prmw(patch, prm)
%
%   patch   : image patch
%   prm     : all the required parameters to extract and whiten
%   v       : kernel descriptor
% 
% Authors: A. Mukundan, G. Tolias, O. Chum, 2017

function v = mkdw(patch, prm)

	v = vecpostproc([mkd(patch, prm.prepolar, prm.ctheta, 1); mkd(patch, prm.precart, prm.ctheta2, 0)]);
	v = whitenapply(v, prm.lw.m, prm.lw.P, prm.D); 