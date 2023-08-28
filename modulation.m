function output_modu = modulation(input_modu, index)
% input_modu: input bit stream (0,1)
% index:  modulation type
%		1---bpsk
%		2---qpsk
%		4---16qam
%		6---64qam
% 	else is error
f_length = length(input_modu)/index;
MOD_output_I = zeros(1,f_length);
MOD_output_Q = zeros(1,f_length);
% note: Matlab index starts from 1
switch index
case 1,
    % 1 bit/symbol
    BPSK_I = [-1 1];    % refer to 3GPP TS 36.211 Section 7.1.1 – 7.1.4
    MOD_output_I = BPSK_I(input_modu+1);
    output_modu = -sqrt(1/2)*(MOD_output_I + j * 0);
case 2,
    % 2 bit/symbol
    QPSK_IQ = [-1 1];   % according to 3GPP TS 36.211 Section 7.1.1 – 7.1.4
    % for-loop is used every 2-bit to generate the symbol and not need to 
    % seperate and recombine.
    MOD_output_I = QPSK_IQ(input_modu(1:2:end)+1);
    MOD_output_Q = QPSK_IQ(input_modu(2:2:end)+1);
    output_modu = -sqrt(1/2)*(MOD_output_I + j * MOD_output_Q);
case 4,
    % 4 bit/symbol
    QAM_16_IQ = [-3 -1 3 1];    % according to 3GPP TS 36.211 Section 7.1.1 – 7.1.4
    % for-loop is used every 4-bit to generate the symbol and not need to 
    % seperate and recombine.
    MOD_output_I = QAM_16_IQ(input_modu(1:4:end)*2+input_modu(2:4:end)+1);
    MOD_output_Q = QAM_16_IQ(input_modu(3:4:end)*2+input_modu(4:4:end)+1);
    output_modu = -sqrt(1/10)*(MOD_output_I + j * MOD_output_Q);
case 6,
    % 6 bit/symbol
    QAM_64_IQ = [-7 -5 -1 -3 7 5 1 3];  % according to 3GPP TS 36.211 Section 7.1.1 – 7.1.4
    % for-loop is used every 6-bit to generate the symbol and not need to 
    % seperate and recombine.
    MOD_output_I = QAM_64_IQ(input_modu(1:6:end)*4+input_modu(2:6:end)*2+input_modu(3:6:end)+1);
    MOD_output_Q = QAM_64_IQ(input_modu(4:6:end)*4+input_modu(5:6:end)*2+input_modu(6:6:end)+1);
    output_modu = -sqrt(1/42)*(MOD_output_I + j * MOD_output_Q);
end

