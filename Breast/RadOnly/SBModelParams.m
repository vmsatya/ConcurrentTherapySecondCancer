% Reference SB model graph parameters and try to see if we can fit in 
% Proton model with dependence on LET 
% For a given N,alpha- find a particular set of r,lambda,gammapropor
% such that it fits at low doses smilar to SB plot.
% alpha for protons is chosen as 0.1890 ~ 0.18 of SB model

clc;
clear all;
close all;

Dose = 0:1:44;

%---------SB model parameters--------

lambda = 0.4; % Sachs
gamma = 10^(-9);% Sachs
N =  10^9; % Sachs
r = 0.76; % Sachs, fitting
alphaGamma = 0.18; % Taken from SB model

for ii = 1:length(Dose)
    D = Dose(ii);
    K = 20;
    d = D/K;
    gammatemp1(ii) = gamma*d;
    S = exp(-alphaGamma*d);
    P = exp(-gamma*d);
    
    nminus(1) = N;
    nn(1)=N;
    nn(2)=S*P*N;
    m(2) = 0;
    T = 1;
    
    for k = 1:K
        k;
        nplus(k) = S*P*nminus(k);
        nn(2*k+1)=nplus(k);
        
        nminus(k+1) = N/(1-exp(-lambda*T)*(1-(N/nplus(k))));
        nn(2*k+2)=nminus(k+1);
        
        m(2*k+1) = S*(m(2*k)+(1-P)*nminus(k));
        mm(2*k+2)=m(2*k+1);
        
        m(2*(k+1)) = m(2*k+1)*((nminus(k+1)/nplus(k))^(r));
        mm(2*k+1)=m(2*k+2);
    end
    
    M(ii) = mm(2*K+2)*((N/nplus(K))^(r));
    ERR(ii) = 1.2 * M(ii);
    %ERR(ii) = 1.0 * M(ii);
end
hold on
plot(Dose,ERR)

%-------- Plot Hodgkin Data from SB paper------------%

A = dlmread('SBBreastValues.txt','\t');

x = A(:,1);
y = A(:,2);

M = dlmread('SBBreast-ErrorBars.txt','\t');

temp1 = M(:,1);
temp2 = M(:,2);

for j = 1:length(temp2)    
    if (mod(j,2) == 0)        
        ly(j) = temp2(j);
    end
    if (mod(j,2) == 1) 
        uy(j) = temp2(j);
    end
end

l = ly(find(ly~=0));
u = uy(find(uy~=0));
for i = 1:length(y)    
    L(i) = y(i) - l(i);
    U(i) = -y(i) + u(i);
end
errorbar(x,y,L,U)
%scatter(x,y,'bo');
hold off
