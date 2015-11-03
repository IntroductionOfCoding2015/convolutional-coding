close all;
clear all;
clc;

INTERATIONS = 1;


load 5dBPSNRdata.mat dataFile % 1KB
% dataFile = randi([0, 1], 1024*8, 1);
CRC_poly = [1; 1; 0; 0; 0; 0; 0; 0; 0; 1; 1; 1; 1]; % CRC_12: x^12+x^11+x^3+x^2+x+1

PSNR = -5: 0.5: 10; % dB
% block error ratio
block_err_hard2 = zeros(size(PSNR)); block_err_hard3 = zeros(size(PSNR));
block_err_soft2 = zeros(size(PSNR)); block_err_soft3 = zeros(size(PSNR));

for i = 1: length(PSNR)
	disp(['PSNR = ' num2str(PSNR(i))]);
	% encode
	% has end, has CRC
	signal_2 = conv_send(dataFile, 1, 2, CRC_poly);
	signal_3 = conv_send(dataFile, 1, 3, CRC_poly);
	for j = 1: INTERATIONS

		% transmit
		signal_2n = transmit(signal_2, PSNR(i));
		signal_3n = transmit(signal_3, PSNR(i));

		% has end, has CRC, block error ratio(block_err_...)
		[file_dec_hard2, block_err] = conv_receive(signal_2n, 1, 2, CRC_poly, 1);
		block_err_hard2(i) = block_err_hard2(i) + block_err;

		[file_dec_hard3, block_err] = conv_receive(signal_3n, 1, 3, CRC_poly, 1);
		block_err_hard3(i) = block_err_hard3(i) + block_err;

		[file_dec_soft2, block_err] = conv_receive(signal_2n, 1, 2, CRC_poly, 0);
		block_err_soft2(i) = block_err_soft2(i) + block_err;

		[file_dec_soft3, block_err] = conv_receive(signal_3n, 1, 3, CRC_poly, 0);
		block_err_soft3(i) = block_err_soft3(i) + block_err;
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
