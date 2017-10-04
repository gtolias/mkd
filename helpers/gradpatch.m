% compute patch gradients (magnitude and orientation)
%
% Authors: A. Bursuc, G. Tolias, H. Jegou. 2015. 

function [mag, ori, gx, gy] = gradpatch(patch)

    gx = [ patch(:,2)-patch(:,1) , patch(:,3:end)-patch(:,1:end-2) , patch(:,end)-patch(:,end-1) ] ;
    gy = [ patch(2,:)-patch(1,:) ; patch(3:end,:)-patch(1:end-2,:) ; patch(end,:)-patch(end-1,:) ] ;
    index = (gx == 0);
    gx_reg = gx;
    gx_reg(index) = 1e-5;

   % gradient orientations in interval [-pi , pi]
   ori = atan2(gy, gx_reg);
    % gradient magnitude
   mag = sqrt(gx .^ 2 + gy .^ 2);