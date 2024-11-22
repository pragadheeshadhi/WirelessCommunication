f = 900e6; % Frequency in Hz (900 MHz)
d = 1:1:1000; % Distance in meters (1 to 1000 m)
ht = 30; % Transmitter height in meters
hr = 1.5; % Receiver height in meters
c = 3e8; % Speed of light in m/s
lambda = c/f; % Wavelength in meters
% Hata Model
% Urban area
a_hr = (1.1 * log10(f) - 0.7) * hr - (1.56 * log10(f) - 0.8); % Correction factor
L_hata = 69.55 + 26.16 * log10(f/1e6) - 13.82 * log10(ht) - a_hr + (44.9 - 6.55 * log10(ht)) * log10(d/1000);
% Okumura Model
L_okumura = 46.3 + 33.9 * log10(f/1e6) - 13.82 * log10(ht) - a_hr + (44.9 - 6.55 * log10(ht)) * log10(d/1000);
% Walfish Model
L_walfish = 20*log10(f) + 20*log10(d) - 147.55 + 10*log10(ht) + 10*log10(hr);
% Long Distance Model
L_long_distance = 32.44 + 20*log10(f/1e6) + 20*log10(d);
% Free Space Path Loss Model
L_free_space = 20*log10(d) + 20*log10(f) - 147.55; % in dB
figure;
plot(d, L_hata, 'b', 'DisplayName', 'Hata Model');
hold on;
plot(d, L_okumura, 'r', 'DisplayName', 'Okumura Model');
plot(d, L_walfish, 'g', 'DisplayName', 'Walfish Model');
plot(d, L_long_distance, 'm', 'DisplayName', 'Long Distance Model');
plot(d, L_free_space, 'k', 'DisplayName', 'Free Space Model');
grid on;
xlabel('Distance (m)');
ylabel('Path Loss (dB)');
title('Path Loss Models');
legend show;
hold off;