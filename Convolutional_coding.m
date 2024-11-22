g1 = [1 1 1];  % Polynomial 1
g2 = [1 0 1];  % Polynomial 2
msg = input('Enter bitstream as a row vector (e.g., [1 0 1 1]): ');
msg_padded = [msg 0 0];
encoded = [];
for i = 1:length(msg) 
    window = msg_padded(i:i+2);
    out1 = mod(sum(window .* g1), 2);  % Output from g1
    out2 = mod(sum(window .* g2), 2);  % Output from g2
    encoded = [encoded out1 out2];
end
fprintf('Encoded Bitstream: [%s]\n', num2str(encoded));