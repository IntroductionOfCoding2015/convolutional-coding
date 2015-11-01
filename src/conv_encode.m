function [ symbols ] = conv_encode( original_symbols, ifHasEnd, efficiency, CRCpoly )

	if(any(CRCpoly))
		crc_symbols = crc_encode(original_symbols, CRCpoly, 25*8);
	else
		crc_symbols = original_symbols;
	end
	crc_symbols = [0; 0; 0; crc_symbols];
	L = length(crc_symbols);
	symbols = [];

	if (efficiency == 2)
		A0 = [1, 1];
		A1 = [1, 1];
		A2 = [0, 1];
		A3 = [1, 1];
	elseif(efficiency == 3)
		A0 = [1, 1, 1];
		A1 = [0, 1, 1];
		A2 = [1, 0, 1];
		A3 = [1, 1, 1];
	end

	for i = 4: L
		y = mod(crc_symbols(i)*A0+crc_symbols(i-1)*A1+crc_symbols(i-2)*A2+crc_symbols(i-3)*A3, 2);
		symbols = [symbols, y];
	end

	if (ifHasEnd == 1)
		symbols = [symbols'; 0; 0; 0];
	else
		symbols = symbols';
	end

end
