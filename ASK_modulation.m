% Parameters
Fs = 100;       % Sampling frequency
Fc = 5;          % Carrier frequency (higher to get visible oscillations)
bit_duration = 1; % Duration for each bit in seconds
% Message signal
me = [1 0 1 1 0 1 0 0];      % Message bits
t = 0:1/Fs:bit_duration*length(me) - 1/Fs; % Time vector for the entire signal duration
samples_per_bit = bit_duration * Fs; % Samples per bit

% Generate the message signal as a square wave
me_signal = repelem(me, samples_per_bit); % Repeat each bit for the sample duration

% Carrier signal
carrier = sin(2 * pi * Fc * t);

% Modulate by multiplying the message and carrier
modulated_signal = me_signal .* carrier;

% Demodulation using envelope detection
demodulated_signal = abs(hilbert(modulated_signal)); % Envelope detection using Hilbert transform

% Downsampling the demodulated signal to reconstruct the original message
% Calculate the average of each bit duration to determine if it's 0 or 1
demodulated_bits = [];
for i = 1:samples_per_bit:length(demodulated_signal)
    avg_amplitude = mean(demodulated_signal(i:i+samples_per_bit-1)); % Average amplitude over each bit period
    if avg_amplitude > 0.5 % Threshold to determine 1 or 0
        demodulated_bits = [demodulated_bits, 1];
    else
        demodulated_bits = [demodulated_bits, 0];
    end
end
demod_signal = repelem(demodulated_bits, samples_per_bit);

% Plotting
figure;
% Plot message signal
subplot(3, 1, 1);
plot(t, me_signal,'LineWidth',1.5); % Plot the message signal
title('Message Signal');
xlabel('Time');
ylabel('Amplitude');
% Plot modulated signal
subplot(3, 1, 2);
plot(t, modulated_signal); % Plot the modulated signal
title('ASK Modulated Signal');
xlabel('Time');
ylabel('Amplitude');
% Plot demodulated signal
subplot(3, 1, 3);
stairs(t, demod_signal, 'LineWidth', 1.5); % Plot the demodulated bits
title('Demodulated Signal');
xlabel('Time');
ylabel('Amplitude');
