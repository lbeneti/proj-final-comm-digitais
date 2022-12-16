clear all;
clc;

% Transmitter parameter structure
prmQPSKTransmitter = plutoradioqpsktransmitter_init;
% Specify Radio ID
prmQPSKTransmitter.Address = 'usb:0'

runPlutoradioQPSKTransmitter(prmQPSKTransmitter);