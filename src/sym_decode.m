function symbols = sym_decode(signal, efficiency)
    demodulator = comm.PSKDemodulator(2^efficiency, 'BitOutput', true, ...
                                                    'PhaseOffset', 0);
    symbols = step(demodulator, signal);
end
