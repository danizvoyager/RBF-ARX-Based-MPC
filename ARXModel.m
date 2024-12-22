function W=ARXModel(ym,model)
% ym: [y(t-1) y(t-2)]

W=zeros(1,model.Order_y+4*model.Order_u+1);
temp=zeros(1,(model.Order_y+4*model.Order_u+1)*(model.N_Center+1));
beta=model.beta;

Ker=ones(1,(model.N_Center+1)*2);                 % Kernels intialized
for k=1:2                                                % for different kinds of RBFs
    for i=1:model.N_Center                                % for each center
        norm=0;                                % the distance
        for j=1:model.D_Center
            norm=norm+(ym(j)-model.center((k-1)*model.N_Center*model.D_Center+(i-1)*model.D_Center+j))^2;      
        end
        Ker((k-1)*(model.N_Center+1)+i+1)=exp(-model.gamma0((k-1)*model.N_Center+i)*norm);  % Kernels' results
    end
end

for i=1:(1+model.Order_y)*2
    temp(i)=beta(i)*Ker(model.N_Center+1-mod(i,model.N_Center+1));
end

for i=(1+model.Order_y)*2+1:length(beta)
    temp(i)=beta(i)*Ker(model.N_Center+1+model.N_Center+1-mod(i,model.N_Center+1));
end

for j=1:length(W)
    W(j)=temp(2*j-1)+temp(2*j);
end