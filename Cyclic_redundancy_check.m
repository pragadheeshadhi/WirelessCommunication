data = [1 0 1 1 0 0 1 0];
poly = [1 0 0 1 1];
data = logical(data);    % Convert data to binary
poly = logical(poly);    % Convert poly to binary
data_padded = [data, zeros(1, length(poly) - 1)];

for i = 1:length(data)
    if data_padded(i) == 1
        data_padded(i:i + length(poly) - 1) = xor(data_padded(i:i + length(poly) - 1), poly);
    end
end
    
crc = data_padded(end - length(poly) + 2:end);
disp('CRC: ');
disp(crc);
