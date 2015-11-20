function dis = conv_dis( output, signal, efficiency, hard )

if efficiency == 2
	symbols = [0 0; 0 1; 1 1; 1 0];
    gray = [0 1 3 2];
    idx_soft = gray(output(1)*2+output(2)+1) + 1;
    num = 4;
else
	symbols = [0 0 0; 0 0 1; 0 1 1; 0 1 0; 1 1 0; 1 1 1; 1 0 1; 1 0 0];
    gray = [0 1 3 2 6 7 5 4];
    idx_soft = gray(output(1)*4+output(2)*2+output(3)+1) + 1;
    num = 8;
end
V = zeros(length(symbols), 1);
for i = 1:num
	V(i) = exp(1j*2*pi/num*(i-1));
end

if hard
	distances = abs(V - signal);
	idx = find(distances==min(distances),1);
	dis = sum(abs(output-symbols(idx,:)));
else
	dis = abs(V(idx_soft)-signal);
end

end
