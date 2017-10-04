% embedding encoding polar coordinates for fixed patch pixel positions
%
% Usage: [epos, phi] = embfixedpos(cphi, crho, s)
%
%   cphi : embedding coefficients for phi
%   crho : embedding coefficients for rho
%   s 	: patch size
%   epos : embeddings for all pixel positions
%   phi  : angle phi for all pixels
% 
% Authors: A. Bursuc, G. Tolias, H. Jegou. 2015. 
%
% Modified for Multiple-Kernel Local-Patch Descriptor, BMVC 20107
% Authors: A. Mukundan, G. Tolias, O. Chum, 2017

function [epos, phi, gmask] = embfixedpos(c1, c2, s, coord, gsigma)

	if ~exist('gsigma'), gsigma = 1.0; end
	if ~exist('coord'), coord = 'polar'; end

	% fixed grid of the patch
	xx = (-(s-1):2:s-1);
	yy = xx';
	xx = repmat(xx, [s 1]);
	yy = repmat(yy, [1 s]);
	xx = xx(:);
	yy = yy(:);

	% polar coordinates
	[phi, rho] = cart2pol(xx, yy);
	rho = rho ./ sqrt(2*(s-1).^2);

	% gaussian weight
	gmask = reshape(exp(-rho.^2/gsigma.^2), s, s);

	switch coord
		case 'polar'
			% embeddings for rho and phi
			ephi = angle2vec(c1, phi(:)');
			erho = angle2vec(c2, rho(:)'*pi);

			% pre-compute phi-rho kronecker
			epos = zeros(size(erho,1)*size(ephi,1),size(ephi,2));
			for i = 1:size(ephi,2)
			   epos(:,i) = kron(ephi(:,i), erho(:,i));
			end

			% apply the gaussian mask
			epos = bsxfun(@times, epos', gmask(:))';

		case 'cart'
			% embeddings for x and y
			ex = angle2vec(c1, 0.5*pi*xx(:)'/(s-1));
			ey = angle2vec(c2, 0.5*pi*yy(:)'/(s-1));

			% pre-compute x-y kronecker
			epos = zeros(size(ex,1)*size(ey,1),size(ey,2));
			for i = 1:size(ex,2)
			   epos(:,i) = kron(ex(:,i), ey(:,i));
			end

			% apply the gaussian mask
			epos = bsxfun(@times, epos', gmask(:))';

		otherwise 
			error('Unknown coordinate system\n');
	end
