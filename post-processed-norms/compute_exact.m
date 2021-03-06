function E = compute_exact(xx,yy,b, show_plot,U)

% Beta (in degree): 36.94490033
% pre-shock density value: 1.222212286
% Post-shock density value 2.281318668
theta = 15./180*pi;
beta = 1.; % 36.94490033/180*pi;
M_left = 2.5;
gamma = 1.4;
left = 1.2222122856;
%rite = 2.281318668;

% compute the oblique shock angle 'beta'
resi = 1.; resi_prime = 1.;
while(abs(resi/resi_prime) > 1.e-15)
    resi = tan(theta)*tan(beta);
    resi = resi*(M_left^2*(gamma+cos(2*beta))+2);
    resi = resi - (2*M_left^2*sin(beta)*sin(beta)-2);
    resi_prime = tan(theta)*(1.+tan(beta)*tan(beta));
    resi_prime = resi_prime*(M_left^2*(gamma+cos(2*beta))+2);
    resi_prime = resi_prime-tan(theta)*tan(beta)*M_left^2*2*sin(2*beta);
    resi_prime = resi_prime-4*M_left^2*sin(beta)*cos(beta);
    beta = beta - resi/resi_prime;
end

% Compute density ratio
rho_ratio = (gamma+1.)*M_left^2*(sin(beta))^2;
rho_ratio = rho_ratio/((gamma-1)*M_left^2*(sin(beta))^2+2.);

% mach_ratio ratio
press_ratio = 1 +2*gamma/(gamma+1)*(M_left^2*(sin(beta))^2-1);

% pressure ratio
Msin2 = M_left^2*(sin(beta))^2;
num = 1+(gamma-1)/2*Msin2;
den = gamma*Msin2-(gamma-1)/2;
mach_ratio = 1/sin(beta-theta)*sqrt(num/den)/M_left;

P_left=101325;
entro_ratio = log(press_ratio*P_left/(rho_ratio*left)^gamma) / log(P_left/left^gamma);


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

