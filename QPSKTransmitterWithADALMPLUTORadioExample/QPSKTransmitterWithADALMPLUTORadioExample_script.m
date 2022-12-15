clear all;
clc;
%% QPSK Transmitter with ADALM-PLUTO Radio
% This example shows how to use the ADALM-PLUTO Radio System objects to implement 
% a QPSK transmitter. The ADALM-PLUTO radio in this system will keep transmitting 
% indexed "Hello world" messages at its specified center frequency. You can demodulate 
% the transmitted message using the <matlab:openExample('plutoradio/QPSKReceiverWithADALMPLUTORadioExample.m') 
% QPSK Receiver with ADALM-PLUTO Radio> example. This example assumes that two 
% ADALM-PLUTO radios are attached to your computer.
%% Implementations
% This example describes the MATLAB® implementation of a QPSK transmitter with 
% ADALM-PLUTO radio. There is another implementation of this example that uses 
% Simulink®.
% 
% MATLAB script using System objects: <matlab:openExample('plutoradio/QPSKTransmitterWithADALMPLUTORadioExample.m') 
% QPSKTransmitterWithADALMPLUTORadioExample>.
% 
% Simulink implementation using blocks: <matlab:openExample('plutoradio/QPSKTransmitterWithADALMPLUTORadioSimulinkExample.m') 
% QPSKTransmitterWithADALMPLUTORadioSimulinkExample>.
% 
% You can also explore a no-radio QPSK Transmitter and Receiver example that 
% models a general wireless communication system using an AWGN channel and simulated 
% channel impairments at <matlab:openExample('comm/QPSKTransmitterAndReceiverExample') 
% QPSKTransmitterAndReceiverExample.m>.
%% Introduction
% This example has the following motivation:
%% 
% * To implement a real QPSK-based transmission-reception environment in MATLAB 
% using ADALM-PLUTO Radio System objects.
% * To illustrate the use of key Communications Toolbox™ System objects for 
% QPSK system design.
%% 
% In this example, the transmitter generates a message using ASCII characters, 
% converts the characters to bits, and prepends a Barker code for receiver frame 
% synchronization. This data is then modulated using QPSK and filtered with a 
% square root raised cosine filter. The filtered QPSK symbols can be transmitted 
% over the air using the ADALM-PLUTO Transmitter System object and the ADALM-PLUTO 
% radio.
%% Initialization
% The <matlab:openExample('plutoradio/QPSKTransmitterWithADALMPLUTORadioExample','supportingFile','plutoradioqpsktransmitter_init.m') 
% plutoradioqpsktransmitter_init.m> script initializes the simulation parameters 
% and generates the structure prmQPSKTransmitter.

% Transmitter parameter structure
prmQPSKTransmitter = plutoradioqpsktransmitter_init;
% Specify Radio ID
prmQPSKTransmitter.Address = 'usb:1'
%% Code Architecture
% The function runPlutoradioQPSKTransmitter implements the QPSK transmitter 
% System object, QPSKReceiver, and ADALM-PLUTO radio System object, comm.SDRTxPluto.
% 
% *QPSK Transmitter*
% 
% The transmitter includes the *Bit Generation*, *QPSK Modulator* and *Raised 
% Cosine Transmit Filter* objects. The *Bit Generation* object generates the data 
% frames. The Barker code is sent on both in-phase and quadrature components of 
% the QPSK modulated symbols. This is achieved by repeating the Barker code bits 
% twice before modulating them with the QPSK modulator.
% 
% The remaining bits are the payload. The payload contains 100 'Hello world 
% ###' messages, where '###' is an increasing sequence of '000', '001', ... '099' 
% in binary forms. The number of messages is tunable via the initialization file, 
% namely <matlab:openExample('plutoradio/QPSKTransmitterWithADALMPLUTORadioExample','supportingFile','plutoradioqpsktransmitter_init.m') 
% transmitter initialization file>. Please make corresponding changes in the receiver 
% initialization file, <matlab:openExample('plutoradio/QPSKReceiverWithADALMPLUTORadioExample','supportingFile','plutoradioqpskreceiver_init.m') 
% receiver initialization file>. The payload is then scrambled to guarantee a 
% balanced distribution of zeros and ones for the timing recovery operation in 
% the receiver object. The scrambled bits are modulated by the *QPSK Modulator* 
% (with Gray mapping). The *Raised Cosine Transmit Filter* upsamples the modulated 
% symbols by two, and has roll-off factor of 0.5. The output rate of the *Raised 
% Cosine Filter* is set to be 400k samples per second with a symbol rate of 200k 
% symbols per second. Please match the symbol rate of the transmitter model and 
% the receiver model correspondingly.
% 
% *ADALM-PLUTO Transmitter*
% 
% The host computer communicates with the ADALM-PLUTO radio using the ADALM-PLUTO 
% transmitter System object. The CenterFrequency, Gain, and InterpolationFactor 
% arguments are set by the parameter variable prmQPSKTransmitter.
%% Execution
% Connect two ADALM-PLUTO Radios to the computer. Start the transmitter script 
% in one MATLAB session and then run the <matlab:openExample('plutoradio/QPSKReceiverWithADALMPLUTORadioExample.m') 
% QPSK Receiver with ADALM-PLUTO Radio> example in another MATLAB session.

runPlutoradioQPSKTransmitter(prmQPSKTransmitter);
%% 
% If the message is not properly decoded by the receiver object, you can vary 
% the gain of the source signals in the *ADALM-PLUTO Transmitter* and *ADALM-PLUTO 
% Receiver* System objects by changing the SimParams.PlutoGain value in the <matlab:openExample('plutoradio/QPSKTransmitterWithADALMPLUTORadioExample','supportingFile','plutoradioqpsktransmitter_init.m') 
% transmitter initialization file> and in the <matlab:openExample('plutoradio/QPSKReceiverWithADALMPLUTORadioExample','supportingFile','plutoradioqpskreceiver_init.m') 
% receiver initialization file>.
% 
% Also, a large relative frequency offset between the transmit and receive radios 
% can prevent the receiver functions from properly decoding the message. If that 
% happens, you can determine the offset by running the <matlab:plutoradiofreqcalib 
% Frequency Offset Calibration (Tx) with ADALM-PLUTO Radio> and the <matlab:plutoradiofreqcalib_rx 
% Frequency Offset Calibration (Rx) with ADALM-PLUTO Radio> models, then applying 
% that offset to the center frequency of the ADALM-PLUTO Receiver System object.
%% Appendix
% This example uses the following script and helper functions:
%% 
% * <matlab:openExample('plutoradio/QPSKTransmitterWithADALMPLUTORadioExample','supportingFile','runPlutoradioQPSKTransmitter.m') 
% runPlutoradioQPSKTransmitter.m>
% * <matlab:openExample('plutoradio/QPSKTransmitterWithADALMPLUTORadioExample','supportingFile','plutoradioqpsktransmitter_init.m') 
% plutoradioqpsktransmitter_init.m>
% * <matlab:openExample('plutoradio/QPSKTransmitterWithADALMPLUTORadioExample','supportingFile','QPSKTransmitter.m') 
% QPSKTransmitter.m>
% * <matlab:openExample('plutoradio/QPSKTransmitterWithADALMPLUTORadioExample','supportingFile','QPSKBitsGenerator.m') 
% QPSKBitsGenerator.m>
%% 
% _Copyright 2017-2022 The MathWorks, Inc._