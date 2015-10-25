function [symbols, err_rate] = crc_decode(crced_symbols, crc_poly, frame_size)
    frames = ceil(length(crced_symbols) / (frame_size + (length(crc_poly) - 1)));

    detector = comm.CRCDetector(crc_poly, 'ChecksumsPerFrame', frames);
    [symbols, err] = step(detector, crced_symbols);
    err_rate = sum(err) / length(err);
end
