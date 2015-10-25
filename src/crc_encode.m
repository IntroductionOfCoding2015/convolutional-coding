function crced_symbols = crc_encode(symbols, crc_poly, frame_size)
    frames = ceil(length(symbols) / frame_size));
    pad = frames * frame_size - length(symbols);
    symbols = [symbols; zeros(pad, 1)];

    generator = comm.CRCGenerator(crc_poly, 'ChecksumsPerFrame', frames);
    crced_symbols = step(generator, x);
end
