clear all; close all; clc;


x=-0.2:0.001:0.2;

threshold=0.05;
delta=0.025;
lower_bound=threshold-delta;
upper_bound=threshold+delta;
for i=1:length(x);
    
    if x(i)<lower_bound
        y(i)=0;
    elseif x(i) <upper_bound
        y(i)=(1+(x(i)-threshold)/delta + 1/pi*sin(pi*(x(i)-threshold)/delta))/2;
    else
        y(i)=1;
    end
end

plot(x,y)
       

% function H = Heaviside(phi,epsilon)  
% %   Heaviside(phi,epsilon)  compute the smooth Heaviside function 
% %   
% %   created on 04/26/2004 
% %   author: Chunming Li 
% %   email: li_chunming@hotmail.com 
% %   Copyright (c) 2004-2006 by Chunming Li 
epsilon=delta/10;
H = 0.5*(1+ (2/pi)*atan((x-threshold)./epsilon));
hold all
plot(x,H)