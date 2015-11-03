close all;
clear all;
clc;

INTERATIONS = 10;


load 5dBPSNRdata.mat dataFile % 1KB
% dataFile = randi([0, 1], 1024*8, 1);
CRC_poly = [1; 1; 0; 0; 0; 0; 0; 0; 0; 1; 1; 1; 1]; % CRC_12: x^12+x^11+x^3+x^2+x+1

PSNR = -5: 0.5: 10; % dB
% block error ratio
block_err_hard2 = zeros(size(PSNR)); block_err_hard3 = zeros(size(PSNR));
block_err_soft2 = zeros(size(PSNR)); block_err_soft3 = zeros(size(PSNR));
% fail ratio
fail_ratio_hard2 = zeros(size(PSNR)); fail_ratio_hard3 = zeros(size(PSNR));
fail_ratio_soft2 = zeros(size(PSNR)); fail_ratio_soft3 = zeros(size(PSNR));
% bit error ratio
error_ratio_hard2 = zeros(size(PSNR)); error_ratio_hard3 = zeros(size(PSNR));
error_ratio_soft2 = zeros(size(PSNR)); error_ratio_soft3 = zeros(size(PSNR));
% bit error ratio under hard dicision (no ending)
err_noEnd_hard2 = zeros(size(PSNR)); err_noEnd_hard3 = zeros(size(PSNR));

for i = 1: length(PSNR)
	% encode
	% has end, has CRC
	signal_2 = conv_send(dataFile, 1, 2, CRC_poly);
	signal_3 = conv_send(dataFile, 1, 3, CRC_poly);
	% has end, no CRC
	signal_noCRC_2 = conv_send(dataFile, 1, 2, []);
	signal_noCRC_3 = conv_send(dataFile, 1, 3, []);
	% no end, no CRC
	signal_noEnd_2 = conv_send(dataFile, 0, 2, []);
	signal_noEnd_3 = conv_send(dataFile, 0, 3, []);
	for j = 1: INTERATIONS

		% transmit
		signal_2n = transmit(signal_2, PSNR(i));
		signal_3n = transmit(signal_3, PSNR(i));
		signal_noCRC_2n = transmit(signal_noCRC_2, PSNR(i));
		signal_noCRC_3n = transmit(signal_noCRC_3, PSNR(i));
		signal_noEnd_2n = transmit(signal_noEnd_2, PSNR(i));
		signal_noEnd_3n = transmit(signal_noEnd_3, PSNR(i));

		% has end, has CRC, block error ratio(block_err_...)
		[file_dec_hard2, block_err] = conv_receive(signal_2n, 1, 2, CRC_poly, 1);
		block_err_hard2(i) = block_err_hard2(i) + block_err;

		[file_dec_hard3, block_err] = conv_receive(signal_3n, 1, 3, CRC_poly, 1);
		block_err_hard3(i) = block_err_hard3(i) + block_err;

		[file_dec_soft2, block_err] = conv_receive(signal_2n, 1, 2, CRC_poly, 0);
		block_err_soft2(i) = block_err_soft2(i) + block_err;

		[file_dec_soft3, block_err] = conv_receive(signal_3n, 1, 3, CRC_poly, 0);
		block_err_soft3(i) = block_err_soft3(i) + block_err;

		% has end, no CRC, bit error ratio(error_ratio_...) and fail_to_send_file ratio(fail_ratio_...)
		[file_dec_noCRC_hard2, ~] = conv_receive(signal_noCRC_2n, 1, 2, [], 1);
		difference = xor(file_dec_noCRC_hard2, dataFile);
		error_ratio_hard2(i) = error_ratio_hard2(i) + sum(difference)/length(dataFile);
		if(sum(difference) ~= 0)
			fail_ratio_hard2(i) = fail_ratio_hard2(i) + 1;
		end

		[file_dec_noCRC_hard3, ~] = conv_receive(signal_noCRC_3n, 1, 3, [], 1);
		difference = xor(file_dec_noCRC_hard3, dataFile);
		error_ratio_hard3(i) = error_ratio_hard3(i) + sum(difference)/length(dataFile);
		if(sum(difference) ~= 0)
			fail_ratio_hard3(i) = fail_ratio_hard3(i) + 1;
		end

		[file_dec_noCRC_soft2, ~] = conv_receive(signal_noCRC_2n, 1, 2, [], 0);
		difference = xor(file_dec_noCRC_soft2, dataFile);
		error_ratio_soft2(i) = error_ratio_soft2(i) + sum(difference)/length(dataFile);
		if(sum(difference) ~= 0)
			fail_ratio_soft2(i) = fail_ratio_soft2(i) + 1;
		end

		[file_dec_noCRC_soft3, ~] = conv_receive(signal_noCRC_3n, 1, 3, [], 0);
		difference = xor(file_dec_noCRC_soft3, dataFile);
		error_ratio_soft3(i) = error_ratio_soft3(i) + sum(difference)/length(dataFile);
		if(sum(difference) ~= 0)
			fail_ratio_soft3(i) = fail_ratio_soft3(i) + 1;
		end

		% no end, no CRC, hard dicision only, bit error ratio(err_noEnd_hard2/3)
		[file_dec_noEnd_hard2, ~] = conv_receive(signal_noEnd_2n, 0, 2, [], 1);
		difference = xor(file_dec_noEnd_hard2, dataFile);
		err_noEnd_hard2(i) = err_noEnd_hard2(i) + sum(difference)/length(dataFile);

		[file_dec_noEnd_hard3, ~] = conv_receive(signal_noEnd_3n, 0, 3, [], 1);
		difference = xor(file_dec_noEnd_hard3, dataFile);
		err_noEnd_hard3(i) = err_noEnd_hard3(i) + sum(difference)/length(dataFile);

	end

	if(PSNR(i) >=0 && PSNR(i) <= 5)
		figure;
		for k = 1: 40
			dataFile_block = dataFile((k-1)*25*8+1: k*25*8);
			recFile_block = file_dec_hard2((k-1)*25*8+1: k*25*8);
			err_code = xor(dataFile_block, recFile_block);
			subplot(5, 8, k); stem(err_code);
        end
        suptitle(['error map when PSNR = ', num2str(PSNR(i)), 'dB']);
	end

	% average of INTERATIONS times
	block_err_hard2(i) = block_err_hard2(i)/INTERATIONS; block_err_hard3(i) = block_err_hard3(i)/INTERATIONS;
	block_err_soft2(i) = block_err_soft2(i)/INTERATIONS; block_err_soft3(i) = block_err_soft3(i)/INTERATIONS;
	error_ratio_hard2(i) = error_ratio_hard2(i)/INTERATIONS; error_ratio_hard3(i) = error_ratio_hard3(i)/INTERATIONS;
	error_ratio_soft2(i) = error_ratio_soft2(i)/INTERATIONS; error_ratio_soft3(i) = error_ratio_soft3(i)/INTERATIONS;
	fail_ratio_hard2(i) = fail_ratio_hard2(i)/INTERATIONS; fail_ratio_hard3(i) = fail_ratio_hard3(i)/INTERATIONS;
	fail_ratio_soft2(i) = fail_ratio_soft2(i)/INTERATIONS; fail_ratio_soft3(i) = fail_ratio_soft3(i)/INTERATIONS;
	err_noEnd_hard2(i) = err_noEnd_hard2(i)/INTERATIONS; err_noEnd_hard3(i) = err_noEnd_hard3(i)/INTERATIONS;

end

% c = jet(4);

% figure;
% plot(PSNR, err_noEnd_hard2, 'Color', c(1, :)); hold on;
% plot(PSNR, err_noEnd_hard3, 'Color', c(2, :));
% xlabel('PSNR(dB)'); ylabel('bit error ratio under hard dicision (no ending)');
% legend('1/2 efficiency', '1/3 efficiency');

% figure;
% plot(PSNR, block_err_hard2, 'Color', c(1, :)); hold on;
% plot(PSNR, block_err_hard3, 'Color', c(2, :)); hold on;
% plot(PSNR, block_err_soft2, 'Color', c(3, :)); hold on;
% plot(PSNR, block_err_soft3, 'Color', c(4, :));
% xlabel('PSNR(dB)'); ylabel('block error ratio');
% legend('1/2, hard dicision', '1/3, hard dicision', '1/2, soft dicision', '1/3, soft dicision');

% figure;
% plot(PSNR, error_ratio_hard2, 'Color', c(1, :)); hold on;
% plot(PSNR, error_ratio_hard3, 'Color', c(2, :)); hold on;
% plot(PSNR, error_ratio_soft2, 'Color', c(3, :)); hold on;
% plot(PSNR, error_ratio_soft3, 'Color', c(4, :));
% xlabel('PSNR(dB)'); ylabel('bit error ratio (without CRC)');
% legend('1/2, hard dicision', '1/3, hard dicision', '1/2, soft dicision', '1/3, soft dicision');

% figure;
% plot(PSNR, fail_ratio_hard2, 'Color', c(1, :)); hold on;
% plot(PSNR, fail_ratio_hard3, 'Color', c(1, :)); hold on;
% plot(PSNR, fail_ratio_soft2, 'Color', c(1, :)); hold on;
% plot(PSNR, fail_ratio_soft3, 'Color', c(1, :));
% xlabel('PSNR(dB)'); ylabel('fail\_to\_send\_file ratio');
% legend('1/2, hard dicision', '1/3, hard dicision', '1/2, soft dicision', '1/3, soft dicision');
