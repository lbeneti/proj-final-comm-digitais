clear all;
clc;

% Receiver parameter structure
prmQPSKReceiver = plutoradioqpskreceiver_init;
% Specify Radio ID
prmQPSKReceiver.Address = 'usb:0'

printReceivedData = true;    % true if the received data is to be printed

BER = runPlutoradioQPSKReceiver(prmQPSKReceiver, printReceivedData); 

fprintf('Error rate is = %f.\n',BER(1));
fprintf('Number of detected errors = %d.\n',BER(2));
fprintf('Total number of compared samples = %d.\n',BER(3));