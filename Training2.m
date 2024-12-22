function [subsystemtwo,MSE2]=Training2(input,output)
Y2=output(:,2);
U=input;
ust=U(1:200,:);          % training data
yst=Y2(1:200,1);
usv=U(1:200,:);         % validating data, validated in 'Validating.m'
ysv=Y2(1:200,1);

global Order_y
global Order_u
global N_Center
global D_Center
global N_lag
global N_S
global gamma0
global beta

%% set properties of the RBF-ARX model
Order_y=3;
Order_u=3;                                            % Order_y and Order_u will determine the number of RBFs.
N_Center=1;                                           % the number of centers per RBF
D_Center=2;                                           % the dimension of RBF centers
N_lag=max(max(Order_y,Order_u),D_Center);
N_S=size(ust,1)-N_lag;
%% SNPOM
scale=max(yst)-min(yst);                            % notice that there will be only two groups of RBFs,
center0=min(yst)+rand(2*N_Center*D_Center,1)*scale;    % one of which is for y and the offest, and another is for u.
x0=center0;                                             % one group contains RBFs which have the same centers and the same gamma0.
                                                                 % In this script, gamma0 will not be optimized,
                                                                 % Because gamma0 are intialized properly in the ObjFun.
options=optimset(@lsqnonlin);
opt_temp=optimset(options,'DiffMaxChange',0.00001,'DiffMinChange',0.00000001,'Display','iter','Jacobian','off',...
        'LargeScale','off','MaxFunEvals',100000,'MaxIter',30,'TolFun',1e-4,'TolX',1e-8,'Algorithm','levenberg-marquardt');
options=opt_temp;                         % training setup

tic                     % timing start
[optimcenter,resnorm]=lsqnonlin(@ObjFun,x0,[],[],options,ust,yst);  % traning
toc                    % timing end
MSE2=resnorm/N_S;    % print MSE

save 'model2paras' beta optimcenter Order_y Order_u N_Center D_Center gamma0 ust yst usv ysv N_S N_lag

subsystemtwo=struct('Order_y',Order_y,'Order_u',Order_u,'N_Center',N_Center,'D_Center',D_Center,'center',optimcenter,'gamma0',gamma0,'beta',beta);

save 'themodel2' subsystemtwo;

'End Training'
end