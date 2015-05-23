clear all; clc;

syms x1 x2 x3 x4 y1 y2 y3 y4 x y s t
syms b1 b2 b3 b4

b1 = (1-s)*(1-t)/4;
b2 = (1+s)*(1-t)/4;
b3 = (1+s)*(1+t)/4;
b4 = (1-s)*(1+t)/4;

x = x1*b1 + x2*b2 + x3*b3 + x4*b4 
y = y1*b1 + y2*b2 + y3*b3 + y4*b4 

simplify(x)
% combine(x)
collect(x,s)

expand(4*x)
expand(4*y)

x1 + x2 + x3 + x4 - s*x1 + s*x2 + s*x3 - s*x4 - t*x1 - t*x2 + t*x3 + t*x4 + s*t*x1 - s*t*x2 + s*t*x3 - s*t*x4
y1 + y2 + y3 + y4 - s*y1 + s*y2 + s*y3 - s*y4 - t*y1 - t*y2 + t*y3 + t*y4 + s*t*y1 - s*t*y2 + s*t*y3 - s*t*y4
x1=0;x2=3;x3=2;x4=0;
y1=0;y2=0;y3=1;y4=1;
x = x1*b1 + x2*b2 + x3*b3 + x4*b4 
simplify(x)
y = y1*b1 + y2*b2 + y3*b3 + y4*b4 
simplify(y)

