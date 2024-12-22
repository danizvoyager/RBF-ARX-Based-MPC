function [X,Y]=LSM_Data(ys,us,centers)
% to produce data for LSM
% given the nonlinear parameters
% the X in (X*Beta=Y) can be calcaulated.

global N_lag
global Order_y
global Order_u
global N_Center
global D_Center
global N_S
global gamma0
%% calcaute the data for LSM
Y=ys(N_lag+1:N_lag+N_S,1);                           
X=zeros(size(Y,1),(N_Center+1)*(Order_y+4*Order_u+1)); 
for t=N_lag+1:N_lag+N_S
    Ker=ones(1,(N_Center+1)*2);                 % Kernels intialized
    for k=1:2                                                % for different kinds of RBFs
        for i=1:N_Center                               % for each center
            norm=0;                                % the distance
            for j=1:D_Center
                norm=norm+(ys(t-j)-centers((k-1)*N_Center*D_Center+(i-1)*D_Center+j))^2; 
            end
            Ker((k-1)*(N_Center+1)+i+1)=exp(-gamma0((k-1)*N_Center+i)*norm);  % Kernels' results, only even terms are calculated.
        end                                                                   % other terms are valued 1.
    end
    
    X1=zeros(1,Order_y*(N_Center+1));      % values representing Ker*y when the system is thought as linear system       
    for i=1:Order_y
        X1((i-1)*(N_Center+1)+1:i*(N_Center+1))=Ker(1:N_Center+1).*ys(t-i,1);
    end
    X2=zeros(1,Order_u*(N_Center+1));      % values representing Ker*u when the system is thought as linear system       
    X3=zeros(1,Order_u*(N_Center+1));
    X4=zeros(1,Order_u*(N_Center+1));
    X5=zeros(1,Order_u*(N_Center+1));
    for i=1:Order_u
        X2((i-1)*(N_Center+1)+1:i*(N_Center+1))=Ker(N_Center+2:2*N_Center+2).*us(t-i,1);
        X3((i-1)*(N_Center+1)+1:i*(N_Center+1))=Ker(N_Center+2:2*N_Center+2).*us(t-i,2);
        X4((i-1)*(N_Center+1)+1:i*(N_Center+1))=Ker(N_Center+2:2*N_Center+2).*us(t-i,3);
        X5((i-1)*(N_Center+1)+1:i*(N_Center+1))=Ker(N_Center+2:2*N_Center+2).*us(t-i,4);
    end
    X(t-N_lag,:)=[Ker(1:N_Center+1),X1,X2,X3,X4,X5];   % notice that the value of the term(offset) has the same value of y_kinds
end                