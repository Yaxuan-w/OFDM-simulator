clc;
clear;

fs = 30.72e6; % Sample rate
Ts = 1/fs; % Sample period / symbol duration
fc = 15e3; % BW of subcarrier
Tc = 1/fc; % Symbol duration
n_FFT = 2048; % Number of IFFT
n_SubC = 1/Tc; % ? Number of subcarrier
n_CP = 256; % ? what is the length of CP
sigNumSamples = floor(Tc/Ts); % integer number of samples

%----------------------Beginning phrase---------------------
bseq = dec2bin('WirelessCommunicationSystemsandSecurityWenYaxuan',8);

%----Change the bseq into a 1x384 double vector----
matrix1 = size(bseq); % bseq is a 48x8 char
a = matrix1(1,1); % a=48
b = matrix1(1,2); % b=8
% Since the bseq's type is char, so we need to transfer that into int
bv = [];
sigCarrier = [];
for i = 1:a 
    for j = 1:b
        bv1 = bseq(i,j); % Get value in bseq. Type: char
        bv1 = bv1*1; % Tranfer type: char -> int
        bv1 = bv1 - 48; % To get the value of char represent. 
        bv = [bv bv1]; % Add to bv
    end
end
data = [bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv,bv]; % Cope 64 times to satisfy the requirement
sigCarrier = data(1:1,1:24576);
N = length(sigCarrier);

% figure;
% subplot(4,1,1);
% t_scale = Ts*1e6 ;
% plot(0:1*t_scale:(sigNumSamples-1)*t_scale,sigCarrier);
% axis([0 (sigNumSamples-1)*t_scale -0.1 1.1])
% xlabel('Time (msec)');
% ylabel('Amplitude');
% title('Bit Stream');

%-----------------------Modulation--------------------------
% figure;
% plot(sigCarrier);xlabel('Original');axis([0 N -2 2]);grid on;
% 
% figure;
bpsk = modulation(sigCarrier, 1);
% scatterplot(bpsk),grid; title('bpsk modulated transmitted data')
% plot(bpsk);xlabel('BPSK');axis([0 N -1 1]);grid on;

qpsk = modulation(sigCarrier, 2);
%qpsk = pskmod(bv, 4, pi/4);
% scatterplot(qpsk);axis([-1.2,1.2,-1.2,1.2]);
% hold on;
% rectangle('Position',[-1, -1, 2, 2],'Curvature',[1, 1]);axis equal;
% title('QPSK')

qam16 = modulation(sigCarrier, 4);
scatterplot(qam16);
title('16QAM');

qam64 = modulation(sigCarrier, 6);
% scatterplot(qam64);
% title('64QAM');

% Choose the modulation type
modu_data = qam16;

num_cols=ceil(length(modu_data)/n_FFT);
%-----------------Serial to Parallel------------------------
data_matrix = reshape(modu_data,n_FFT, num_cols);
%------------------------IFFT-------------------------------
ifft_data=ifft(data_matrix);
%---------Insert cyclic prefix--add n_CP to the head--------
Tx_cd=[ifft_data(n_FFT-n_CP+1:end,:);ifft_data];  
[rows_ifft_data cols_ifft_data]=size(Tx_cd);
len_ofdm_data = rows_ifft_data*cols_ifft_data;  % length of data
% OFDM symbol, and save to .mat file
ofdm_signal = reshape(Tx_cd, 1, len_ofdm_data); 
save('outBuffer.mat', 'ofdm_signal', 'sigCarrier')
figure(2)
plot(real(ofdm_signal)); xlabel('Time'); ylabel('Amplitude');
title('OFDM Signal');grid on;
