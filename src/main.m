close all;
clear all;
clc;

INTERATIONS = 20;


load 5dBPSNRdata.mat dataFile % 1KB
% dataFile = randi([0, 1], 1024*8, 1);
CRC_poly = [1; 1; 0; 0; 0; 0; 0; 0; 0; 1; 1; 1; 1]; % CRC_12: x^12+x^11+x^3+x^2+x+1

PSNR = 2: 0.5: 7.5; % dB
% fail ratio
fail_ratio_hard2 = zeros(size(PSNR));
fail_ratio_soft2 = zeros(size(PSNR));

matlabpool(length(PSNR));
parfor i = 1: length(PSNR)
	% encode
	% has end, no CRC
	signal_noCRC_2 = conv_send(dataFile, 1, 2, []);
	for j = 1: INTERATIONS
		disp(['present iteration: ',num2str(j),'\tSNR value: ',num2str(i)]);

		% transmit
		signal_noCRC_2n = transmit(signal_noCRC_2, PSNR(i));

		% has end, no CRC, bit error ratio(error_ratio_...) and fail_to_send_file ratio(fail_ratio_...)
		[file_dec_noCRC_hard2, ~] = conv_receive(signal_noCRC_2n, 1, 2, [], 1);
		difference = xor(file_dec_noCRC_hard2, dataFile);
		if(sum(difference) ~= 0)
			fail_ratio_hard2(i) = fail_ratio_hard2(i) + 1;
		end

		[file_dec_noCRC_soft2, ~] = conv_receive(signal_noCRC_2n, 1, 2, [], 0);
		difference = xor(file_dec_noCRC_soft2, dataFile);
		if(sum(difference) ~= 0)
			fail_ratio_soft2(i) = fail_ratio_soft2(i) + 1;
		end
	end

	% average of INTERATIONS times
	fail_ratio_hard2(i) = fail_ratio_hard2(i)/INTERATIONS;
	fail_ratio_soft2(i) = fail_ratio_soft2(i)/INTERATIONS;
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
