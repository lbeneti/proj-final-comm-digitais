%% QPSK Receiver with ADALM-PLUTO Radio
% This example shows how to use the ADALM-PLUTO Radio System objects
% to implement a QPSK receiver. The receiver addresses
% practical issues in wireless communications, such as carrier frequency
% and phase offset, timing offset and frame synchronization. This system
% receives the signal sent by the
% <matlab:openExample('plutoradio/QPSKTransmitterWithADALMPLUTORadioExample.m')
% QPSK Transmitter with ADALM-PLUTO Radio> example. The receiver
% demodulates the received symbols and prints a simple message to the
% MATLAB(R) command line.

% Copyright 2017-2022 The MathWorks, Inc.

%% Implementations
% This example describes the MATLAB implementation of a QPSK receiver with
% ADALM-PLUTO Radio. There is another implementation of this example that
% uses Simulink(R).
%
% MATLAB script using System objects:
% <matlab:openExample('plutoradio/QPSKReceiverWithADALMPLUTORadioExample.m') QPSKReceiverWithADALMPLUTORadioExample>.
%
% Simulink implementation using blocks: <matlab:openExample('plutoradio/QPSKReceiverWithADALMPLUTORadioSimulinkExample.m') QPSKReceiverWithADALMPLUTORadioSimulinkExample>.
%
% You can also explore a no-radio QPSK Transmitter and Receiver example
% that models a general wireless communication system using an AWGN channel
% and simulated channel impairments at
% <matlab:openExample('comm/QPSKTransmitterAndReceiverExample') 
% QPSKTransmitterAndReceiverExample>.

%% Introduction
% This example has the following motivation:
%
% * To implement a real QPSK-based transmission-reception environment in
% MATLAB using ADALM-PLUTO System objects.
%
% * To illustrate the use of key Communications Toolbox(TM) System
% objects for QPSK system design, including coarse and fine carrier
% frequency compensation, closed-loop timing recovery with bit stuffing and
% stripping, frame synchronization, carrier phase ambiguity resolution, and
% message decoding.
%
% In this example, the ADALM-PLUTO System object receives data
% corrupted by the transmission over the air and outputs complex baseband
% signals which are processed by the QPSK Receiver System object. 
% This example provides a reference design of a practical digital receiver
% that can cope with wireless channel impairments. The receiver includes
% FFT-based coarse frequency compensation, PLL-based fine frequency
% compensation, timing recovery with fixed-rate re-sampling and bit
% stuffing/skipping, frame synchronization, and phase ambiguity resolution.

%% Initialization
% The <matlab:openExample('plutoradio/QPSKReceiverWithADALMPLUTORadioExample','supportingFile','plutoradioqpskreceiver_init.m') plutoradioqpskreceiver_init.m>
% script initializes the simulation parameters and generates the structure
% _prmQPSKReceiver_.

% Receiver parameter structure
prmQPSKReceiver = plutoradioqpskreceiver_init;
% Specify Radio ID
prmQPSKReceiver.Address = 'usb:0'

%% Code Architecture
% The function runPlutoradioQPSKReceiver implements the QPSK receiver using
% the QPSK receiver System object, QPSKReceiver, and ADALM-PLUTO radio System
% object, comm.SDRRxPluto.
%
% *ADALM-PLUTO Receiver*
%
% This example communicates with the ADALM-PLUTO radio using the ADALM-PLUTO
% Receiver System object. The parameter structure _prmQPSKReceiver_ sets the
% CenterFrequency, Gain, and InterpolationFactor etc.
%
% *QPSK Receiver*
%
% This component regenerates the original transmitted message. It is
% divided into five subcomponents, modeled using System objects. Each
% subcomponent is modeled by other subcomponents using System objects.
%
% 1) Automatic Gain Control: Sets its output power to a level ensuring that
% the equivalent gains of the phase and timing error detectors keep
% constant over time. The AGC is placed before the *Raised Cosine Receive
% Filter* so that the signal amplitude can be measured with an oversampling
% factor of two. This process improves the accuracy of the estimate.
%
% 2) Coarse frequency compensation: Uses a correlation-based algorithm to
% roughly estimate the frequency offset and then compensate for it. The
% estimated coarse frequency offset is averaged so that fine frequency
% compensation is allowed to lock/converge. Hence, the coarse frequency offset
% is estimated using a "comm.CoarseFrequencyCompensator" System
% object and an averaging formula; the compensation is performed using a
% "comm.PhaseFrequencyOffset" System object.
%
% 3) Timing recovery: Performs timing recovery with closed-loop scalar
% processing to overcome the effects of mismatched sample rate between
% the transmitter and the receiver due to inaccuracies of crystal 
% oscillators used in sampling clock generation, we employ a 
%  *comm.SymbolSynchronizer* System object. The object implements a
% PLL to correct the symbol timing error in the received signal. The
% rotationally-invariant Gardner timing error detector is chosen for the
% object in this example; thus, timing recovery can precede fine frequency
% compensation. The input to the object is a fixed-length frame of samples.
% The output of the object is a frame of symbols whose length can vary due
% to bit stuffing and stripping, depending on actual channel delays.
%
% 4) Fine frequency compensation: Performs closed-loop scalar processing
% and compensates for the frequency offset accurately, using a
% *comm.CarrierSynchronizer* System object. The object implements a
% phase-locked loop (PLL) to track the residual frequency offset and the
% phase offset in the input signal.
%
% 5) Preamble Detection: Detects the location of the known Barker code in
% the input using a *comm.PreambleDetector* System object. The object
% implements a cross-correlation based algorithm to detect a known sequence
% of symbols in the input.
%
% 6) Frame Synchronization: Performs frame synchronization and, also,
% converts the variable-length symbol inputs into fixed-length outputs,
% using a *FrameSynchronizer* System object. The object has a secondary
% output that is a boolean scalar indicating if the first frame output is
% valid.
%
% 7) Data decoder: Performs phase ambiguity resolution and demodulation.
% Also, the data decoder compares the regenerated message with the
% transmitted one and calculates the BER.
%
% For more information about the system components, refer to the
% <matlab:openExample('plutoradio/QPSKReceiverWithADALMPLUTORadioSimulinkExample.m') QPSK Receiver with ADALM-PLUTO Radio example using
% Simulink>.

%% Execution and Results
% Connect two ADALM-PLUTO Radios to the computer. Start the
% <matlab:openExample('plutoradio/QPSKTransmitterWithADALMPLUTORadioExample.m')
% QPSK Transmitter with ADALM-PLUTO Radio> example in one MATLAB session
% and then start the receiver script in another MATLAB session.

printReceivedData = false;    % true if the received data is to be printed

BER = runPlutoradioQPSKReceiver(prmQPSKReceiver, printReceivedData); 

fprintf('Error rate is = %f.\n',BER(1));
fprintf('Number of detected errors = %d.\n',BER(2));
fprintf('Total number of compared samples = %d.\n',BER(3));

%%
% When you run the simulations, the received messages are decoded and
% printed out in the MATLAB command window while the simulation is running.
% BER information is also shown at the end of the script execution. The
% calculation of the BER value includes the first received frames, when
% some of the adaptive components in the QPSK receiver still have not
% converged.  During this period, the BER is quite high.  Once the
% transient period is over, the receiver is able to estimate the
% transmitted frame and the BER dramatically improves. In this example, to
% guarantee a reasonable execution time of the system in simulation mode,
% the simulation duration is fairly short.  As such, the overall BER
% results are significantly affected by the high BER values at the
% beginning of the simulation. To increase the simulation duration and
% obtain lower BER values,  you can change the SimParams.StopTime variable
% in the <matlab:openExample('plutoradio/QPSKReceiverWithADALMPLUTORadioExample','supportingFile','plutoradioqpskreceiver_init.m') receiver initialization
% file>.
%
% If the message is not properly decoded by the receiver system, you can
% vary the gain of the source signals in the *ADALM-PLUTO Transmitter* and
% *ADALM-PLUTO Receiver* System objects by changing the SimParams.PlutoGain
% value in the <matlab:openExample('plutoradio/QPSKTransmitterWithADALMPLUTORadioExample','supportingFile','plutoradioqpsktransmitter_init.m') transmitter
% initialization file> and in the <matlab:openExample('plutoradio/QPSKReceiverWithADALMPLUTORadioExample','supportingFile','plutoradioqpskreceiver_init.m')
% receiver initialization file>.
%
% Finally, a large relative frequency offset between the transmit and
% receive devices can prevent the receiver functions from
% properly decoding the message.  If that happens, you can determine the offset by
% running the <matlab:plutoradiofreqcalib Frequency Offset Calibration (Tx) with
% ADALM-PLUTO Radio> and the <matlab:plutoradiofreqcalib_rx Frequency Offset
% Calibration (Rx) with ADALM-PLUTO Radio> models, then applying that offset
% to the center frequency of the ADALM-PLUTO Receiver System object.

%% Appendix
% This example uses the following script and helper functions:
%
% * <matlab:openExample('plutoradio/QPSKReceiverWithADALMPLUTORadioExample','supportingFile','runPlutoradioQPSKReceiver.m') runPlutoradioQPSKReceiver.m>
% * <matlab:openExample('plutoradio/QPSKReceiverWithADALMPLUTORadioExample','supportingFile','plutoradioqpskreceiver_init.m') plutoradioqpskreceiver_init.m>
% * <matlab:openExample('plutoradio/QPSKReceiverWithADALMPLUTORadioExample','supportingFile','QPSKReceiver.m') QPSKReceiver.m>

%% References
% 1. Rice, Michael. _Digital Communications - A Discrete-Time
% Approach_. 1st ed. New York, NY: Prentice Hall, 2008.
