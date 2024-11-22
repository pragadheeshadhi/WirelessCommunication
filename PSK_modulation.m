% Parameters
Fs = 1000;          % Sampling frequency
f1 = 5;             % Carrier frequency for bit 1
f2 = 5;             % Carrier frequency for bit 0
bit_duration = 1; % Duration for each bit in seconds
% Message signal
me = [1 0 1 1 0 1 0 1];      % Message bits
t = 0:1/Fs:bit_duration*length(me) - 1/Fs; % Time vector for the entire signal duration
samples_per_bit = bit_duration * Fs; % Samples per bit

% Generate the message signal as a square wave
me_signal = repelem(me, samples_per_bit); % Repeat each bit for the sample duration

% Generate the PSK modulated signal
modulated_signal = zeros(1, length(t));
for i = 1:length(me)
    if me(i) == 1
        modulated_signal((i-1)*samples_per_bit + 1:i*samples_per_bit) = cos(2 * pi * f1 * t((i-1)*samples_per_bit + 1:i*samples_per_bit));
    else
        modulated_signal((i-1)*samples_per_bit + 1:i*samples_per_bit) = cos(pi/2 +2 * pi * f1 * t((i-1)*samples_per_bit + 1:i*samples_per_bit));
    end
end

% Demodulation (FSK Demodulation using Envelope Detection and Thresholding)
demodulated_signal = zeros(1, length(me));
for i = 1:length(me)
    segment = modulated_signal((i-1)*samples_per_bit + 1:i*samples_per_bit);
    power_f1 = mean(abs(hilbert(segment .* sin(2 * pi * f1 * t((i-1)*samples_per_bit + 1:i*samples_per_bit)))));
    power_f2 = mean(abs(hilbert(segment .* cos(2 * pi * f2 * t((i-1)*samples_per_bit + 1:i*samples_per_bit)))));
    if power_f1 > power_f2
        demodulated_signal(i) = 1;
    else
        demodulated_signal(i) = 0;
    end
end

% Convert demodulated signal to time-series for plotting
demod_signal = repelem(demodulated_signal, samples_per_bit);

% Plotting
figure;

% Plot message signal
subplot(3, 1, 1);
stairs(t, me_signal, 'LineWidth', 1.5); % Plot the message signal
title('Message Signal');
xlabel('Time');
ylabel('Amplitude');

% Plot FSK modulated signal
subplot(3, 1, 2);
plot(t, modulated_signal); % Plot the PSK modulated signal
title('PSK Modulated Signal');
xlabel('Time');
ylabel('Amplitude');
xlim([0, bit_duration*length(me)]);

% Plot demodulated signal
subplot(3, 1, 3);
stairs(t, demod_signal, 'LineWidth', 1.5); % Plot the demodulated bits
title('Demodulated Signal');
xlabel('Time');
ylabel('Amplitude');
xlim([0, bit_duration*length(me)]);
ylim([-0.1 1.1]);
