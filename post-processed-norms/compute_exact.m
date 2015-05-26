function E = compute_exact(xx,yy,b, show_plot,U)

% Beta (in degree): 36.94490033
% pre-shock density value: 1.222212286
% Post-shock density value 2.281318668
beta = 36.94490033/180*pi;
left = 1.2222122856;
rite = 2.281318668;

% beginning of angle
x0=-0.25;
y0=-0.5;
% shock vector
vec_u = [cos(beta); sin(beta); 0];
% storage for exact solution
nq=size(b,1);
E=zeros(nq,1);

% physical coordinates
X=zeros(nq,1);
Y=zeros(nq,1);
for k=1:4
    X = X + xx(k)*b(:,k);
    Y = Y + yy(k)*b(:,k);
end

for iq=1:nq
    OP = [ X(iq)-x0 ;  Y(iq)-y0; 0];
    a = cross(vec_u, OP);
    if(a(3)>0)
        E(iq)=left;
    else
        E(iq)=rite;
    end
end

if show_plot
    figure(99);
    hold on
    surf(reshape(X,sqrt(nq),sqrt(nq)),reshape(Y,sqrt(nq),sqrt(nq)),reshape(E,sqrt(nq),sqrt(nq)));
    
    if nargin==5
        figure(199);
        hold on
        surf(reshape(X,sqrt(nq),sqrt(nq)),reshape(Y,sqrt(nq),sqrt(nq)),reshape(U,sqrt(nq),sqrt(nq)));
        
        figure(299);
        hold on
        surf(reshape(X,sqrt(nq),sqrt(nq)),reshape(Y,sqrt(nq),sqrt(nq)),reshape(U-E,sqrt(nq),sqrt(nq)));
        
    end
end

end

