echo off; 
clear;
clc;
Ts=0.01;
load input
load output
[subsystemone,MSE1]=Training1(input,output)
[subsystemtwo,MSE2]=Training2(input,output)
[subsystemthree,MSE3]=Training3(input,output)
[VMSE1]=Validating1();
[VMSE2]=Validating2();
[VMSE3]=Validating3();
[A1,B1,C1,D1]=RBFARXtest1(Ts);
[A2,B2,C2,D2]=RBFARXtest2(Ts);
[A3,B3,C3,D3]=RBFARXtest3(Ts);
A=[A1,zeros(subsystemone.Order_y,subsystemtwo.Order_y) zeros(subsystemone.Order_y,subsystemthree.Order_y);
   zeros(subsystemtwo.Order_y,subsystemone.Order_y) A2 zeros(subsystemtwo.Order_y,subsystemthree.Order_y);
   zeros(subsystemthree.Order_y,subsystemone.Order_y) zeros(subsystemthree.Order_y,subsystemtwo.Order_y) A3];
B=[B1;B2;B3];
C=[C1 zeros(1,subsystemtwo.Order_y) zeros(1,subsystemthree.Order_y);
   zeros(1,subsystemone.Order_y) C2 zeros(1,subsystemthree.Order_y);
   zeros(1,subsystemone.Order_y) zeros(1,subsystemtwo.Order_y) C3];
D=[D1;D2;D3];
SYS=ss(A,B,C,D);
CO=rank(ctrb(A,B))
OV=rank(obsv(A,C))
% %mpcobj= mpc(SYS,0.001)
% % %plant = setmpcsignals(SYS,'MD',4,'UO',3);
% % Create the controller object with sampling period, prediction and control
% % horizons:
% p = 10;                                     % Prediction horizon
% m = 2;                                      % Control horizon
% % mpcobj = mpc(SYS,0.02,p,m);
% plant = setmpcsignals(SYS,'MD',[]);
% mpcobj = mpc(plant,Ts,p,m);
% %Specify MV constraints.
% mpcobj.MV(1).Min = 50;
% mpcobj.MV(1).Max = 85;
% mpcobj.MV(2).Min = 35;
% mpcobj.MV(2).Max = 60;
% mpcobj.MV(3).Min = 30;
% mpcobj.MV(3).Max = 130;
% mpcobj.MV(4).Min = 450;
% mpcobj.MV(4).Max = 600;
% mpcobj.OV(1).Min = 450;
% mpcobj.OV(2).Max = 520;
% mpcobj.OV(2).Min = 60;
% mpcobj.OV(2).Max = 70;
% mpcobj.OV(3).Min = 40;
% mpcobj.OV(3).Max = 60;
% %Define reference signal.
% Tstop = 10;
% ref = [505 65 55];
% r = struct('time',(0:Ts:Tstop)');
% N = numel(r.time);
% r.signals.values=ones(N,1)*ref;
% %OV weights are linearly increasing with time
% ywt.time = r.time;
% ywt.signals.values = (1:N)'*[0.1 0.1 0.1];
% %MV rate weights are decreasing linearly with time
% duwt.time = r.time;
% duwt.signals.values = (1-(1:N)/2/N)'*[.1 .1 .1];
% %ECR weight increases exponentially with time
% ECRwt.time = r.time;
% ECRwt.signals.values = 10.^(2+(1:N)'/N);
% %Start simulation
% mdl = 'mpc_onlinetuning';
% open_system(mdl);                   % Open Simulink(R) Model
% sim(mdl);                           % Start Simulation