% Clear previous data and set up initial parameters
clc;
clear all;
close all;

% Data to be transmitted
data = [0 0 0 1 1 0 1 1];
figure(1)
subplot(3,2,1);
stem(data, 'LineWidth', 1.5), grid on;
title('Original Message Data');
xlabel('Time (sec)');
ylabel('Amplitude (volt)');
axis([0 9 0 1.5]);

% Convert data to NRZ format: 0 -> -1, 1 -> +1
data_NZR = 2 * data - 1; 
s_p_data = reshape(data_NZR, 2, length(data) / 2); % Reshape into symbols of 2 bits

% Modulation parameters
br = 1e6;              % Bit rate (1 Mbps)
f = br;                % Carrier frequency
T = 1/br;              % Duration of one bit
t = T/99:T/99:T;       % Time vector for one bit duration

% QPSK Modulation
y_in = [];             % In-phase component
y_qd = [];             % Quadrature component
y = [];                % QPSK modulated signal

for i = 1:length(data)/2
    % Generate in-phase and quadrature components
    y1 = s_p_data(1,i) * cos(2 * pi * f * t); % In-phase component
    y2 = s_p_data(2,i) * sin(2 * pi * f * t); % Quadrature component
    
    % Append each symbol's components to the output arrays
    y_in = [y_in y1];
    y_qd = [y_qd y2];
    y = [y y1 + y2]; % QPSK signal is the sum of in-phase and quadrature components
end

% Time vector for entire QPSK signal
tt = T/99:T/99:(T * length(data)) / 2;

% Plot in-phase component
subplot(4,1,1);
plot(tt, y_in, 'LineWidth', 1.5), grid on;
title('In-phase Component');
xlabel('Time (sec)');
ylabel('Amplitude (volt)');

% Plot quadrature component
subplot(4,1,2);
plot(tt, y_qd, 'LineWidth', 1.5), grid on;
title('Quadrature Component');
xlabel('Time (sec)');
ylabel('Amplitude (volt)');

% Plot QPSK modulated signal
subplot(4,1,3);
plot(tt, y, 'r', 'LineWidth', 1.5), grid on;
title('QPSK Modulated Signal (In-phase + Quadrature)');
xlabel('Time (sec)');
ylabel('Amplitude (volt)');

% Demodulation - Coherent detection of in-phase and quadrature components
demod_data = [];

for i = 1:length(data)/2
    % Extract the i-th symbol
    symbol = y((i-1)*length(t) + 1 : i*length(t));
    
    % Demodulate in-phase component
    Z_in = symbol .* cos(2 * pi * f * t); % Multiply with cosine
    Z_in_intg = (trapz(t, Z_in)) * (2 / T); % Integrate over symbol period
    
    % Demodulate quadrature component
    Z_qd = symbol .* sin(2 * pi * f * t); % Multiply with sine
    Z_qd_intg = (trapz(t, Z_qd)) * (2 / T); % Integrate over symbol period
    
    % Threshold detection to recover original bits
    if Z_in_intg > 0
        demod_in = 1;
    else
        demod_in = 0;
    end
    
    if Z_qd_intg > 0
        demod_qd = 1;
    else
        demod_qd = 0;
    end
    
    % Append demodulated bits
    demod_data = [demod_data demod_in demod_qd];
end

% Plot demodulated data
subplot(4,1,4);
stem(demod_data, 'LineWidth', 1.5), grid on;
title('Demodulated Data');
xlabel('Time (sec)');
ylabel('Amplitude (volt)');
axis([0 9 0 1.5]);
