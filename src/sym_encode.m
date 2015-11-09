function signal = sym_encode(symbols, efficiency)
    if efficiency == 2
        gray = [0 1 3 2];
        weight = [2; 1];
    else
        gray = [0 1 3 2 6 7 5 4];
        weight = [4; 2; 1];
    end

    levels = 2^efficiency;
    signal_num = floor(length(symbols) / efficiency);
    signal = zeros(signal_num, 1);

    for k = 1:signal_num
        symbols((k-1)*efficiency+1:k*efficiency)';
        num = symbols((k-1)*efficiency+1:k*efficiency)' * weight;
        level = find(gray == num);
        signal(k) = exp(j * (level - 1) * 2 * pi / levels);
    end
end
