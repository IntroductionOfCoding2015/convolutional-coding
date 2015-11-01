function dis = conv_dis( output, signal, efficiency, hard )

if efficiency == 2
	symbols = [0 0; 0 1; 1 1; 1 0];
else
	symbols = [0 0 0; 0 0 1; 0 1 1; 0 1 0; 1 1 0; 1 1 1; 1 0 1; 1 0 0];
end
V = zeros(length(symbols));
for i = 1:2^efficiency
	V(i) = exp(j*2*pi/2^efficiency*(i-1));
end

if hard
	distances = abs(V - signal);
	idx = find(distances==min(distances),1);
	dis = sum(abs(output-symbols(idx)));
else
	idx = ismember(symbols,output,'rows');
	dis = abs(V(idx)-signal);
end

end
