function signal = sym_encode(symbols, efficiency)
    modulator = comm.PSKModulator(2^efficiency, 'BitInput', true, ...
                                                'PhaseOffset', 0);
    signal = step(modulator, symbols);
end
