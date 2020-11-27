function xout = zeroPad(xin, zeroImage)

xout = zeroImage;
xout( 1:size(xin,1), 1:size(xin,2) ) = xin;