% function Tracking_Car(File,File_Number)
% This function is the main entrance
% Read picture and save video
% Inputs:
%           File:             string      Data set name
%           File_Number:      integter    Picture number
%           Output_Name       string      Output video name
% Outputs:
%           Output_Name.avi   avi
function Tracking_Car(File,File_Number,Output_Name)
    num=0;
    v.FrameRate=1;
    v = VideoWriter(Output_Name);
    open(v);
    dt=1;
    A = [1 0 dt 0; 0 1 0 dt; 0 0 1 0; 0 0 0 1];
    B = [0 0 ;0 0; dt 0;0 dt];
    C = [1 0 0 0;0 1 0 0];
    X=[0;0;0;0];
    P = 10*eye(4);
    u=[3.8;1];
    % the simulated noise 
    R = diag([(0.1)^2 (0.1)^2 (1)^2 (1)^2]);
    Q = diag([(0.1)^2 (0.1)^2]);
    Car_State(:,1) = X;
    for i=2:File_Number
        image_to_detect=[File,'/',num2str(i,'%03d'),'.jpg'];
        background = [File,'/','001.jpg']
        [car_position,detect_car,car_size]=Detect_Car(background,image_to_detect);
        image=imread(image_to_detect);                
        if detect_car==1
            figure,imshow(image,[]);title('Raw');
            hold on;
            u=u+[0.15;0.15];
            [Car_State_Pocessed,P]=Kalman_Filter(X,car_position',A,B,C,Q,R,P,u);
            rectangle('Position',[Car_State_Pocessed(1)-50,Car_State_Pocessed(2)-50,100,100],'EdgeColor','r');
            hold on;
            f(i-1) = getframe(gca);
            num=num+1;
            Car_State(:,num+1)=Car_State_Pocessed;
        else
            figure,imshow(image,[]);title('Raw');
            f(i-1) = getframe(gca);
            hold on;
        end
    end

    close all;   % close figure
    writeVideo(v,f);
    close(v);
end