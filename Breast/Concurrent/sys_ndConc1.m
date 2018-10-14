% This code does the following:
% Number of Fractions = 20 of 2 Gy
% Chemo Cycle = 1 with 21 days


function xprime = sys_ndConc1(t,x,DC,DR,OneCycle,TotalDays)

xprime = zeros(2,1);

N = 10^6;
lambda = 0.40;
r = 0.76;

K = 20;
D = DR;
d = D/K;

tau = 0.02;   % radiation time- 30 minutes = 0.02 days
alphaR = 0.18;
gammaR = 10^(-6); % (d/tau) is the dose rate

gammaC = 0.19*10^(-9);
alphad = 0.1333;
alphaC = 0.2;
RadSen = 1.0;

% Scenario I - Rad is given in the first cycle

if(t<=TotalDays)
    
    chemo = exp(-alphad*mod(t,OneCycle));
    
    xprime(1) = lambda*x(1)*(1-x(1)) - alphaC*chemo*(DC/OneCycle)*x(1) - gammaC*(DC/OneCycle)*x(1);
    xprime(2) = r*lambda*x(2)*(1-x(1)) - alphaC*chemo*(DC/OneCycle)*x(2) + gammaC*(DC/OneCycle)*N*x(1);
    
    if (t<tau+K)
        t-floor(t);
        if (t-floor(t)<=tau)
            t;            
            xprime(1) =  xprime(1) - RadSen*alphaR*(d/tau)*x(1) - gammaR*(d/tau)*x(1);
            xprime(2) =  xprime(2) - RadSen*alphaR*(d/tau)*x(2) + gammaR*(d/tau)*N*x(1);
        end       
    end
else
    
    xprime(1) = lambda*x(1)*(1-x(1));
    xprime(2) = r*lambda*x(2)*(1-x(1));
    
end























