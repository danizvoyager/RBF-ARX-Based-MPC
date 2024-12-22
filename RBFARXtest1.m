function [A,B,C,D]=RBFARXtest1(Ts)
load 'themodel1'
load 'model1paras'
y1_pre_by_arx=zeros(1,N_S);
inputvector=zeros(1,4*Order_u + Order_y+1);
inputvector(1)=1;
for t=N_lag+1:N_lag+N_S
    W=ARXModel([yst(t-1),yst(t-2)],subsystemone);
    for i=1:Order_y
        inputvector(i+1)=yst(t-i)
    end
    for i=1:Order_u
        inputvector(i+1+Order_y)=ust(t-i,1);
        inputvector(i+Order_y + Order_u   + 1)=ust(t-i,2);
        inputvector(i+Order_y + 2*Order_u + 1)=ust(t-i,3);
        inputvector(i+Order_y + 3*Order_u + 1)=ust(t-i,4);
    end
    inputvector
 y_pre_by_arx(t)=sum(inputvector.*W); 
end
y1_pre_by_arx=y_pre_by_arx(N_lag+1:N_lag+N_S);
figure('Name','Temperature Prediction','NumberTitle','off');
plot(y1_pre_by_arx);
title('Predicted Value of Tempreature by RBF ARX')
save 'y1_pre_by_arx' y1_pre_by_arx;
'End Testing'
'The tranfer Functions of the system are'
Den=[1,-W(2:Order_y+1)]
Num_U1=[W(Order_y+2:Order_y + Order_u +1),zeros(1,Order_y-Order_u)];
Num_U2=[W(Order_y + Order_u +2:Order_y + 2*Order_u +1),zeros(1,Order_y-Order_u)];
Num_U3=[W(Order_y + 2*Order_u +2: Order_y + 3*Order_u +1),zeros(1,Order_y-Order_u)];
Num_U4=[W(Order_y + 3*Order_u +2:Order_y + 4*Order_u +1),zeros(1,Order_y-Order_u)];
'The tranfer Functions from U1(z) to Y1(z)';
TF_11=tf(Num_U1,Den,Ts);
'The tranfer Functions from U2(z) to Y1(z)'
TF_21=tf(Num_U2,Den,Ts);
'The tranfer Functions from U3(z) to Y1(z)'
TF_31=tf(Num_U3,Den,Ts);
'The tranfer Functions from U4(z) to Y1(z)'
TF_41=tf(Num_U4,Den,Ts);
plantTF = tf({[Num_U1],[Num_U2],[Num_U3],[Num_U4]},{[Den],[Den],[Den],[Den]});
sys=ss(plantTF);
[A,B,C,D] = ssdata(sys);
end