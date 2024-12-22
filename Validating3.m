function [VMSE]=Validating3()
clear;
clc;
load 'model3paras'
load 'themodel3'
beta=subsystemthree.beta;
%% for traning data
[X,Y]=LSM_Data(yst,ust,optimcenter);
y_pre=X*beta;
error=Y-y_pre;
figure('Name','Subsystem Three Training Result','NumberTitle','off');
subplot(3,1,1)
hold on
plot(Y,'k-')
plot(y_pre,'b--')
title("Drum Level Training")
legend('Model O/p','Actual O/P')
subplot(3,1,2)
stem(error)
title("Training Error")
figure('Name','System Inputs','NumberTitle','off');
subplot(2,2,1)
plot(ust(:,1),'r-')
title("Training Airflow one Input")
subplot(2,2,2)
plot(ust(:,2),'r-')
title("Training Airflow two Input")
subplot(2,2,3)
plot(ust(:,3),'r-')
title("Training water flow Input")
subplot(2,2,4)
plot(ust(:,1),'r-')
title("Training Stoker Speed Input")
MSE=sum(error.^2)/size(y_pre,1);
['Training MSE3 = ' num2str(MSE)]
%% for validating data
[X,Y]=LSM_Data(ysv,usv,optimcenter);
y_pre=X*beta;
error=Y-y_pre;
figure('Name','Subsystem Three Validation Result','NumberTitle','off');
subplot(2,1,1)
hold on
plot(Y,'k-')
plot(y_pre,'b--')
title("Drum Level Validation")
legend('Model O/p','Actual O/P')
subplot(2,1,2)
stem(error)
title("Training Error")
figure('Name','System Inputs','NumberTitle','off');
subplot(2,2,1)
plot(usv(:,1),'r-')
title("Validation Airflow one Input")
subplot(2,2,2)
plot(usv(:,2),'r-')
title("Validation Airflow two Input")
subplot(2,2,3)
plot(usv(:,3),'r-')
title("Validation water flow Input")
subplot(2,2,4)
plot(usv(:,1),'r-')
title("Validation Stoker Speed Input")
VMSE=sum(error.^2)/size(y_pre,1);
['Validating MSE3 = ' num2str(VMSE)]
'End Validating'
end