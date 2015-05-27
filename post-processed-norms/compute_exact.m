function E = compute_exact(xx,yy,b, show_plot,U)

% Beta (in degree): 36.94490033
% pre-shock density value: 1.222212286
% Post-shock density value 2.281318668
teta = 15./180*pi;
beta = 1.; % 36.94490033/180*pi;
M_left = 2.5;
gamma = 1.4;
left = 1.2222122856;
%rite = 2.281318668;

% compute the oblique shock angle 'beta'
resi = 1.; resi_prime = 1.;
while(abs(resi/resi_prime) > 1.e-15)
    resi = tan(teta)*tan(beta);
    resi = resi*(M_left*M_left*(gamma+cos(2*beta))+2);
    resi = resi - (2*M_left*M_left*sin(beta)*sin(beta)-2);
    resi_prime = tan(teta)*(1.+tan(beta)*tan(beta));
    resi_prime = resi_prime*(M_left*M_left*(gamma+cos(2*beta))+2);
    resi_prime = resi_prime-tan(teta)*tan(beta)*M_left*M_left*2*sin(2*beta);
    resi_prime = resi_prime-4*M_left*M_left*sin(beta)*cos(beta);
    beta = beta-resi/resi_prime;
end

% Compute density ratio
rho_ratio = (gamma+1.)*M_left*M_left*sin(beta)*sin(beta);
rho_ratio = rho_ratio/((gamma-1)*M_left*M_left*sin(beta)*sin(beta)+2.);

% Compute the right density called 'rite'
rite = left*rho_ratio;

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

