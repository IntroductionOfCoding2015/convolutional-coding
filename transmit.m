function noised_signal = transmit(signal, snr)
    noised_signal = awgn(signal, snr, 'measured');
end
