function [symbols, err_rate] = conv_decode( signal, ending, efficiency, crc_poly, hard )

if efficiency == 2
	A = [1 0 1 1; 1 1 1 1]';
else
	A = [1 1 0 1; 1 0 1 1; 1 1 1 1]';
end

tails = [0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1];
prev_dis = [0 -1 -1 -1 -1 -1 -1 -1];
dis = [-1 -1 -1 -1 -1 -1 -1 -1];
prev_sym = cell(1,8);
sym = cell(1,8);

for i = 1:length(signal)
	for k = 1:8
		if prev_dis(k) >= 0
			for symbol = [0,1]
				input = [tails(k,:), symbol];
				output = mod(input * A,2);
                idx = input(2)*4+input(3)*2+input(4)+1;
				d = conv_dis(output,signal(i),efficiency,hard);
				if dis(idx) < 0
					dis(idx) = prev_dis(k) + d;
					sym{idx} = [prev_sym{k}, symbol];
				elseif dis(idx) > prev_dis(k) + d
					dis(idx) = prev_dis(k) + d;
					sym{idx} = [prev_sym{k}, symbol];
				end
			end
		end
	end
	prev_sym = sym;
	prev_dis = dis;
	dis = [-1 -1 -1 -1 -1 -1 -1 -1];
end

if ending
	symbols = sym{1}';
    symbols = symbols(1:end-3);  % Remove ending.
else
	symbols = sym{find(prev_dis==min(prev_dis),1)}';
end

if any(crc_poly)
    [symbols, err_rate] = crc_decode(symbols, crc_poly, 25 * 8);
else
    err_rate = 0;
end
