m = 4;
 data = randi([0 m-1], 10, 1); % Generate symbols between 0 and m-1 for 4-PSK
 mod_signal = pskmod(data, m); % Modulate the data
 scatterplot(mod_signal); % Use scatterplot for complex symbols
 title('4-PSK Modulated Signal');
 snr = 10;
 noisy_signal = awgn(mod_signal, snr); % Add AWGN noise
 figure;
 plot(real(mod_signal));
 hold on;
 plot(imag(mod_signal));
 title('PSK Mod ');
 figure;
 plot(noisy_signal); % Plot noisy signal in scatterplot
 title('Noisy 4-PSK Signal');
 demod_data = pskdemod(noisy_signal, m); % Demodulate the noisy signal
 % Plot the demodulated data
 figure;
 stem(demod_data); % Use stem to visualize the discrete data
 title('Demodulated Data');