G = [1 0 0 0 1 1 0;
     0 1 0 0 1 0 1;
     0 0 1 0 0 1 1;
     0 0 0 1 1 1 1];
msg = input('Enter 4-bit message as a row vector (e.g., [1 0 1 1]): ');
codeword = mod(msg * G, 2);
fprintf('Encoded Codeword: [%s]\n', num2str(codeword));
error_pattern = [0 0 0 0 0 1 0]; % Error at 6th bit
received = mod(codeword + error_pattern, 2);
fprintf('Received Codeword (with error): [%s]\n', num2str(received));
H = [1 1 0 1 1 0 0;
     1 0 1 1 0 1 0;
     0 1 1 1 0 0 1];
syndrome = mod(H * received', 2);
fprintf('Syndrome: [%s]\n', num2str(syndrome'));
error_pos = bi2de(syndrome', 'left-msb');
fprintf('Error Position: %d\n', error_pos);
if error_pos ~= 0
    received(error_pos) = mod(received(error_pos) + 1, 2);
    fprintf('Corrected Codeword: [%s]\n', num2str(received));
else
    fprintf('No error detected.\n');
end