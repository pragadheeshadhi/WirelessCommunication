% Parameters
n = 256; % Number of bits to process
M = 16; % Size of signal constellation (16-QAM)
k = log2(M); % Number of bits per symbol
tu = 3.2e-6; % Useful symbol period
tg = 0.8e-6; % Guard interval length
ts = tu + tg; % Total symbol duration
nmax = 64; % Total number of subcarriers
fc = 3.6e9; % Carrier frequency
snr = 0; % Signal to Noise Ratio (SNR)

% Binary data generation
x = randi([0 1], n, 1); % Random binary data stream

% Reshape bits into symbols
xsym = bi2de(reshape(x, k, length(x) / k).', 'left-msb');

% Modulate using 16-QAM
y = qammod(xsym, M);

% IFFT to generate OFDM symbols
c = ifft(y, nmax);

% Bandpass modulation
tt = 0:6.25e-8:ts - 6.25e-8; % Time vector
s = real(c' .* (exp(1j * 2 * pi * fc * tt))); % Bandpass signal

% Plot transmitted OFDM signal
figure;
plot(real(s), 'b');
title('OFDM Signal Transmitted');

% Plot OFDM spectrum
figure;
plot(10 * log10(abs(fft(s, nmax))));
xlabel('Frequency');
ylabel('Power Spectral Density (dB)');
title('Transmit Spectrum OFDM');

% Add AWGN noise to the transmitted signal
ynoisy = awgn(s, snr, 'measured');

% Plot received noisy signal
figure;
plot(real(ynoisy), 'b');
title('Received OFDM Signal with Noise');

% Bandpass demodulation
z = ynoisy .* exp(-1j * 2 * pi * fc * tt); % Remove carrier frequency

% FFT to recover the symbols
z = fft(z, nmax);

% QAM demodulation
zsym = qamdemod(z, M);

% Convert symbols back to binary
z = de2bi(zsym, 'left-msb');
z = reshape(z.', [], 1); % Reshape to vector

% BER calculation
[noe, ber] = biterr(x, z);

% Plot original and recovered messages
figure;
subplot(2, 1, 1);
stem(x(1:256));
title('Original Message');
subplot(2, 1, 2);
stem(z(1:256));
title('Recovered Message');
% Display BER
fprintf('Number of errors: %d\n', noe);
fprintf('Bit Error Rate (BER): %f\n', ber);
