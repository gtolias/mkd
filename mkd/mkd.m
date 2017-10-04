% compute kernel descriptor for a patch
%
% Usage: v = mkd(patch, pre, ctheta, reltv, dol2norm)
%
%   patch   : image patch
%   pre     : precomputed embeddings and phi for fixed patch pixels
%   ctheta  : embedding coefficients for theta
%   reltv   : use relative gradient angle
%   dol2norm: l2 normalize the descriptor
%   v       : kernel descriptor
% 
% Authors: A. Bursuc, G. Tolias, H. Jegou. 2015. 
%
% Modified for Multiple-Kernel Local-Patch Descriptor, BMVC 20107
% Authors: A. Mukundan, G. Tolias, O. Chum, 2017

function v = mkd(patch, pre, ctheta, reltv, dol2norm)

	if ~exist('reltv'), reltv = 1; end  % relative gradient angle
	if ~exist('dol2norm'), dol2norm = 1; end
	if ~isfield(pre, 'mexp'), pre.mexp = 0.5; end

	patch = imfilter(patch, fspecial('gaussian', [5 5], 1.4), 'same', 'replicate');
	% patch gradients
	[mag, theta] = gradpatch(patch);    

	% theta embedding
	if reltv
		etheta = angle2vec(ctheta, theta(:)' - pre.phi');
	else
		etheta = angle2vec(ctheta, theta(:)');
	end
	% weight by magnitude, modulate, and aggregate
	v = ((repmat(mag(:).^pre.mexp, 1, size(etheta, 1))') .* etheta) * pre.epos';
	% vector l2 normalize
	if dol2norm, v = v(:) ./ sqrt(sum(v(:).^2)); end
