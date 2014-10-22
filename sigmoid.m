close all; clc; clear all;

Mthresh=0.05;
a=3;
x1=linspace(0,1.25);
y1=(tanh(a*(x1-Mthresh))+abs(tanh(a*(x1-Mthresh))))/2;
plot(x1,y1); hold all

% x=linspace(-20,20);
% y=1./(1+exp(-x));
% plot(x,y)

x2=linspace(0*Mthresh,0.6);
y2=0.5*(1+cos(pi+pi*(x2-x2(1))/(x2(end)-x2(1))));
plot(x2,y2,'+-')










% 
% x=0:100
% a=3
% y=(tanh(a*(x-xo)+abs(tanh(a*(x-xo)))/2;
% y=(tanh(a*(x-xo))+abs(tanh(a*(x-xo))))/2;
% xo=13
% y=(tanh(a*(x-xo))+abs(tanh(a*(x-xo))))/2;
% plot(x,y)
% a=0.1
% y=(tanh(a*(x-xo))+abs(tanh(a*(x-xo))))/2;
% plot(x,y)
% y=1./(1+exp(x))
% plot(x,y)
% y=1./(1+exp(-x));
% plot(x,y)
% y=1./(1+exp(-x+x0));
% y=1./(1+exp(-x+xo));
% plot(x,y)
% z=1-y
% plot(x,z)
% y=1./(1+exp(-x+xo)*a);
% plot(x,y)
% close all
% plot(x,y)
% a=10
% y=1./(1+exp(-x+xo)*a);
% hold all
% plot(x,y)
% a=100
% y=1./(1+exp(-x+xo)*a);
% plot(x,y)
% xo=0.5
% y=1./(1+exp(-x+xo)*a);
% plot(x,y)
% a=1/100
% y=1./(1+exp(-x+xo)*a);
% plot(x,y)
% close all
% plot(x,y)
% a=1/1
% y=1./(1+exp(-x+xo)*a);
% plot(x,y)
% a=1/100
% y=1./(1+exp(-x+xo)*a);
% plot(x,y)
% hold all
% a=1/1
% y=1./(1+exp(-x+xo)*a);
% plot(x,y)
% a=5
% y=1./(1+exp(-x+xo)*a);
% plot(x,y)
% a=1/0.05
% y=1./(1+exp(-x+xo)*a);
% plot(x,y)
% a=5/0.05
% y=1./(1+exp(-x+xo)*a);
% plot(x,y)
% a=20/0.05
% y=1./(1+exp(-x+xo)*a);
% plot(x,y)
% x=0:2:100
% x=0:2
% x=linspace(0,2)
% y=1./(1+exp(-x+xo)*a);
% x=linspace(0,2)
% close all
% plot(x,y)
% a=2/0.05
% y=1./(1+exp(-x+xo)*a);
% plot(x,y)
% a=5
% y=1./(1+exp(-x+xo)*a);
% plot(x,y)
% a=0.05
% y=1./(1+exp(-x+xo)*a);
% plot(x,y)
% a=0.0005
% y=1./(1+exp(-x+xo)*a);
% plot(x,y)