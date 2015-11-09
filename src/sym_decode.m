function symbols = sym_decode(signal, efficiency)
    if efficiency == 2
        gray = [0 1 3 2];
    else
        gray = [0 1 3 2 6 7 5 4];
    end

    levels = 2^efficiency;
    signal = gray(mod(round(angle(signal) / (2 * pi / levels)), levels) + 1);

    symbols = de2bi(signal, efficiency, 'left-msb')';
    symbols = symbols(:);
end
