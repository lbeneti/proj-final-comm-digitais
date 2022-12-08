function runPlutoradioQPSKTransmitter(prmQPSKTransmitter)
%#codegen

%   Copyright 2017 The MathWorks, Inc.

persistent hTx radio
if isempty(hTx)
    % Initialize the components
    % Create and configure the transmitter System object
    hTx = QPSKTransmitter(...
        'UpsamplingFactor',             prmQPSKTransmitter.Interpolation, ...
        'RolloffFactor',                prmQPSKTransmitter.RolloffFactor, ...
        'RaisedCosineFilterSpan',       prmQPSKTransmitter.RaisedCosineFilterSpan, ...
        'MessageBits',                  prmQPSKTransmitter.MessageBits, ...
        'MessageLength',                prmQPSKTransmitter.MessageLength, ...
        'NumberOfMessage',              prmQPSKTransmitter.NumberOfMessage, ...
        'ScramblerBase',                prmQPSKTransmitter.ScramblerBase, ...
        'ScramblerPolynomial',          prmQPSKTransmitter.ScramblerPolynomial, ...
        'ScramblerInitialConditions',   prmQPSKTransmitter.ScramblerInitialConditions);
    
    % Create and configure the Pluto System object.
    radio = sdrtx('Pluto');
    radio.RadioID               = prmQPSKTransmitter.Address;
    radio.CenterFrequency       = prmQPSKTransmitter.PlutoCenterFrequency;
    radio.BasebandSampleRate    = prmQPSKTransmitter.PlutoFrontEndSampleRate;
    radio.SamplesPerFrame       = prmQPSKTransmitter.PlutoFrameLength;
    radio.Gain                  = prmQPSKTransmitter.PlutoGain;
end

currentTime = 0;
disp('Transmission has started')
    
    % Transmission Process
while currentTime < prmQPSKTransmitter.StopTime
    % Bit generation, modulation and transmission filtering
    data = step(hTx);

    % Data transmission
    step(radio, data);

    % Update simulation time
    currentTime = currentTime+prmQPSKTransmitter.FrameTime;
end

if currentTime ~= 0
    disp('Transmission has ended')
end    

release(hTx);
release(radio);

end
