function signal = conv_send(symbols, ending, efficiency, crc_poly)
    code = conv_encode(symbols, ending, efficiency, crc_poly);
    signal = sym_encode(code, efficiency);
end
