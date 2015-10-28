function symbols = conv_rec( signal, efficiency, hard )

if efficiency == 1/2
	A = [1 1 0 1; 1 1 1 1]';
	group = 2;
else
	A = [1 0 1 1; 1 1 0 1; 1 1 1 1]';
	group = 3;
end

tails = [0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1];
prev_dis = [0 -1 -1 -1 -1 -1 -1 -1];
dis = [-1 -1 -1 -1 -1 -1 -1 -1];
prev_sym = cell(1,8);
sym = cell(1,8);

if hard
	for i = 1:length(signal)/group
		for k = 1:8
			if prev_dis(k) >= 0
				for symbol = [0,1]
					input = [tails(k,:), symbol];
					output = input * A;
					idx = find(ismember(tails,input(end-2:end),'rows'));
					d = sum(abs(output - signal((i-1)*group+1:i*group)));
					if dis(idx) < 0
						dis(idx) = d;
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
end

symbols = sym{1};