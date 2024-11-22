% Data for LRC computation
data = [
    1 0 1 1 0 0 1 0;
    0 1 1 0 1 1 0 1;
    1 0 0 1 1 0 1 0;
    0 1 1 0 0 1 1 1
];
% Initialize variables
[rows, cols] = size(data);
lrc = zeros(1, cols);

% Compute LRC
for col = 1:cols
    lrc(col) = mod(sum(data(:, col)), 2);
end

% Display the result
disp('LRC: ');
disp(lrc);
