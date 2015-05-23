function Jxw = compute_jacobian(xq,yq,wq,xx,yy)

% x = a + bs +ct +d st
% same for y

% jacobian = [ dx/ds dx/dt ; dy/ds dy/dt]

x1=xx(1); x2=xx(2); x3=xx(3); x4=xx(4);
y1=yy(1); y2=yy(2); y3=yy(3); y4=yy(4);

% factor 4
% x1 + x2 + x3 + x4 (- s*x1 + s*x2 + s*x3 - s*x4) - t*x1 - t*x2 + t*x3 + t*x4 + s*t*x1 - s*t*x2 + s*t*x3 - s*t*x4
% y1 + y2 + y3 + y4 (- s*y1 + s*y2 + s*y3 - s*y4) - t*y1 - t*y2 + t*y3 + t*y4 + s*t*y1 - s*t*y2 + s*t*y3 - s*t*y4

J11 = (-x1+x2+x3-x4) +(x1-x2+x3-x4)*yq;
J12 = (-x1-x2+x3+x4) +(x1-x2+x3-x4)*xq;
J21 = (-y1+y2+y3-y4) +(y1-y2+y3-y4)*yq;
J22 = (-y1-y2+y3+y4) +(y1-y2+y3-y4)*xq;

Jxw = (J11.*J22 - J12.*J21).*wq /16;

end

