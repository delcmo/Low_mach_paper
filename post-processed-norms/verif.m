clear all; close all; clc

% verif

% load 2d quadrature
nquadx=10; nquady=10;
[xq,yq,wq] = GL_2D(nquadx,nquady);
% load basis function
b = shape_functions(xq,yq);
% for i=1:4
%     figure(i)
%     surf(reshape(xq,nquadx,nquady),reshape(yq,nquadx,nquady),reshape(b(:,i),nquadx,nquady))
% end


Jxw = compute_jacobian(xq,yq,wq,[0 12 6 0],[0 0 11 11]);
sum(Jxw)
