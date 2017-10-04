% Map an angle to a vector 
%
% Usage: x = angle2vec (an, theta)
%
%   an: Fourier coefficients of weighting function 
%   theta: vector [1xN] of angles
%   x : matrix [dxN] of vectors of angles, each column corresponds to an angle
% 
% Authors: A. Bursuc, G. Tolias, H. Jegou. 2015. 
%
function x = angle2vec (an, theta)

n = numel (theta);
nf = numel (an) - 1;

C = an(1);    

x = [repmat(sqrt(C),1,n); cos((1:nf)'*theta); sin((1:nf)'*theta)];
x = bsxfun (@times, x, [1; sqrt(an(2:end)); sqrt(an(2:end))]);
