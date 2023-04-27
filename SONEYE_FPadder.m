inputNumberFile = fopen("SONEYE_FPadder_INPUT_T.txt", "w");
outputNumberFile = fopen("SONEYE_FPadder_EXP_OUTPUT_T.txt", "w");

test = float2bin(0.5);
inputVal_1 = 0.5;
inputVal_2 = -0.4375;
exponential = 0;
outputVal = inputVal_1 + inputVal_2;
for j = 0:1
    fprintf(inputNumberFile, "%s\r\n", "X XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); %reset value, val 1, val 2
    fprintf(outputNumberFile, "%s\r\n", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); %final sum of two floating point numbers of previous input values
end

fprintf(inputNumberFile, "%s\r\n", "1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); %reset value, val 1, val 2 (resets design)
fprintf(outputNumberFile, "%s\r\n", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); %for now the output will be the larger exponent

%extra line to delay output
fprintf(outputNumberFile, "%s\r\n", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); %for now the output will be the larger exponent

for i = 1:110
    d = rand(3);
    exponential_1 = mod(ceil((d(1,3) * 100)),15);
    exponential_2 = mod(ceil((d(2,3) * 100)),15);
    sign_1 = mod(ceil((d(3,1) * 10)),2);
    sign_2 = mod(ceil((d(3,2) * 10)),2);
    inputVal_1 = (ceil(d(1,1) * d(2,1) * 100)) * (-1)^sign_1 * (2)^exponential_1;
    inputVal_2 = (ceil(d(1,2) * d(2,2) * 100)) * (-1)^sign_2 * (2)^exponential_2;
    output = single(inputVal_1) + single(inputVal_2);
    
    inputVal_1_bin = float2bin(inputVal_1);
    inputVal_2_bin = float2bin(inputVal_2);
    output_bin = float2bin(output);
    
    fprintf(inputNumberFile, "0 %s %s\r\n", inputVal_1_bin, inputVal_2_bin);
    fprintf(outputNumberFile, "%s\r\n", output_bin); 
    
end
fprintf(inputNumberFile, "%s", ".");
fprintf(outputNumberFile, "%s", ".");

fclose(inputNumberFile);
fclose(outputNumberFile);

%{
%% Example Testing
numOfBits = 32;
inputVal_1 = 0.5;
inputVal_2 = -0.4375;
outputVal = 0.0625;
for j = 0:1
    fprintf(inputNumberFile, "%s\r\n", "X XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); %reset value, val 1, val 2
    fprintf(outputNumberFile, "%s\r\n", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); %final sum of two floating point numbers of previous input values
end

fprintf(inputNumberFile, "%s\r\n", "1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); 
fprintf(outputNumberFile, "%s\r\n", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); %for now the output will be the larger exponent

fprintf(inputNumberFile, "%s\r\n", "0 00111111000000000000000000000000 10111110111000000000000000000000"); %0.5, -0.4375
fprintf(outputNumberFile, "%s\r\n", "00111101100000000000000000000000"); %00111101100000000000000000000000

fprintf(inputNumberFile, "%s\r\n", "0 10111110011010000000000000000000 00111111111100000000000000000000"); %-0.2265625, 1.875
fprintf(outputNumberFile, "%s\r\n", "00111101100000000000000000000000"); %00111101100000000000000000000000

fprintf(inputNumberFile, "%s\r\n", "0 10111111111100000000000000000000 10111110011010000000000000000000 "); %-1.875 -0.2265625
fprintf(outputNumberFile, "%s\r\n", "00111111110100110000000000000000");

fprintf(inputNumberFile, "%s\r\n", "0 01111111010000000000000000000000 00000000100100000000000000000000"); %2.55211775191e+38, 1.32243114468e-38
fprintf(outputNumberFile, "%s\r\n", "11000000000001101000000000000000");

fprintf(inputNumberFile, "%s\r\n", "0 00000000100100000000000000000000 01111111010000000000000000000000"); %1.32243114468e-38, 2.55211775191e+38
fprintf(outputNumberFile, "%s\r\n", "01111111010000000000000000000000"); %0 11111110 10000000000000000000000

fprintf(inputNumberFile, "%s\r\n", "0 00111111011100000000000000000000 00111111000000000000000000000001"); %0.9375, 0.500000059605
fprintf(outputNumberFile, "%s\r\n", "01111111010000000000000000000000"); %254 = 127 + 127, (-126 or 127) 

fprintf(inputNumberFile, "%s\r\n", "0 00000111111100000000000000000000 00000111111100000000000000000001"); %3.61111864573e-34, 3.61111887531e-34
fprintf(outputNumberFile, "%s\r\n", "00111111101110000000000000000000"); %1.4375

fprintf(inputNumberFile, "%s\r\n", "0 00000111101111111111111111111000 00000111101111111111111111111001"); %2.88889307987e-34, 2.88889330946e-34
fprintf(outputNumberFile, "%s\r\n", "00001000011100000000000000000000");  %7.2222373E-34

fprintf(inputNumberFile, "%s\r\n", "0 11000111111110000000000000000000 11001011111111111111111111111100"); %-126976.0, -33554424.0
fprintf(outputNumberFile, "%s\r\n", "00001000001111111111111111111000"); %5.7777864e-34

fprintf(inputNumberFile, "%s\r\n", "0 11000111111110000000000000000000 11001011111111111111111111111100"); %-126976.0, -33554424.0
fprintf(outputNumberFile, "%s\r\n", "11001100000000000111101111111110"); %-33681400


%{

fprintf(inputNumberFile, "%s\r\n", "0 10111110011010000000000000000000 00111111111100000000000000000000"); %-0.2265625, 1.875
fprintf(outputNumberFile, "%s\r\n", "01111111 11010000000000000000000 11100000000000000000000 00111111110100110000000000000000"); %00111111110100110000000000000000

fprintf(inputNumberFile, "%s\r\n", "0 10111110011010000000000000000000 00111111111100000000000000000000"); %-0.2265625, 1.875
fprintf(outputNumberFile, "%s\r\n", "01111111 11010000000000000000000 11100000000000000000000 00111111110100110000000000000000");

fprintf(inputNumberFile, "%s\r\n", "0 10111111111100000000000000000000 10111110011010000000000000000000 "); %-1.875 -0.2265625, 
fprintf(outputNumberFile, "%s\r\n", "01111111 11010000000000000000000 11100000000000000000000 11000000000001101000000000000000"); %11000000000001101000000000000000

fprintf(inputNumberFile, "%s\r\n", "0 10111111111100000000000000000000 10111110011010000000000000000000 "); %-1.875 -0.2265625, 
fprintf(outputNumberFile, "%s\r\n", "01111111 11010000000000000000000 11100000000000000000000 11000000000001101000000000000000");

fprintf(inputNumberFile, "%s\r\n", "0 01111111010000000000000000000000 00000000100100000000000000000000"); %2.55211775191e+38, 1.32243114468e-38
fprintf(outputNumberFile, "%s\r\n", "11111110 00100000000000000000000 10000000000000000000000 01111111010000000000000000000000"); %0 11111110 10000000000000000000000

fprintf(inputNumberFile, "%s\r\n", "0 01111111010000000000000000000000 00000000100100000000000000000000"); %2.55211775191e+38, 1.32243114468e-38
fprintf(outputNumberFile, "%s\r\n", "11111110 00100000000000000000000 10000000000000000000000 01111111010000000000000000000000");

fprintf(inputNumberFile, "%s\r\n", "0 00000000100100000000000000000000 01111111010000000000000000000000"); %1.32243114468e-38, 2.55211775191e+38
fprintf(outputNumberFile, "%s\r\n", "11111110 00100000000000000000000 10000000000000000000000 01111111010000000000000000000000"); %254 = 127 + 127, (-126 or 127) 

fprintf(inputNumberFile, "%s\r\n", "0 00000000100100000000000000000000 01111111010000000000000000000000"); %1.32243114468e-38, 2.55211775191e+38
fprintf(outputNumberFile, "%s\r\n", "11111110 00100000000000000000000 10000000000000000000000 01111111010000000000000000000000"); %254 = 127 + 127, (-126 or 127) 

fprintf(inputNumberFile, "%s\r\n", "0 00111111011100000000000000000000 00111111000000000000000000000001"); %0.9375, 0.500000059605
fprintf(outputNumberFile, "%s\r\n", "01111110 00000000000000000000001 11100000000000000000000 00111111101110000000000000000000"); %254 = 127 + 127, (-126 or 127) 

fprintf(inputNumberFile, "%s\r\n", "0 00111111011100000000000000000000 00111111000000000000000000000001"); %0.9375, 0.500000059605
fprintf(outputNumberFile, "%s\r\n", "01111110 00000000000000000000001 11100000000000000000000 00111111101110000000000000000000"); %1.4375

fprintf(inputNumberFile, "%s\r\n", "0 00000111111100000000000000000000 00000111111100000000000000000001"); %3.61111864573e-34, 3.61111887531e-34
fprintf(outputNumberFile, "%s\r\n", "00001111 11100000000000000000000 11100000000000000000001 00001000011100000000000000000000");  %7.2222373E-34

fprintf(inputNumberFile, "%s\r\n", "0 00000111111100000000000000000000 00000111111100000000000000000001");
fprintf(outputNumberFile, "%s\r\n", "00001111 11100000000000000000000 11100000000000000000001 00001000011100000000000000000000");

fprintf(inputNumberFile, "%s\r\n", "0 00000111101111111111111111111000 00000111101111111111111111111001"); %2.88889307987e-34, 2.88889330946e-34
fprintf(outputNumberFile, "%s\r\n", "00001111 01111111111111111111000 01111111111111111111001 00001000001111111111111111111000"); 

fprintf(inputNumberFile, "%s\r\n", "0 00000111101111111111111111111000 00000111101111111111111111111001");
fprintf(outputNumberFile, "%s\r\n", "00001111 01111111111111111111000 01111111111111111111001 00001000001111111111111111111000");
%} 
fprintf(inputNumberFile, "%s", ".");
fprintf(outputNumberFile, "%s", ".");

fclose(inputNumberFile);
fclose(outputNumberFile);

%}
function b = float2bin(f)
%This function converts a floating point number to a binary string.
%
%Input: f - floating point number, either double or single
%Output: b - string of "0"s and "1"s in IEEE 754 floating point format
%
%Floating Point Binary Formats
%Single: 1 sign bit, 8 exponent bits, 23 significand bits
%Double: 1 sign bit, 11 exponent bits, 52 significand bits
%
%Programmer: Eric Verner
%Organization: Matlab Geeks
%Website: matlabgeeks.com
%Email: everner@matlabgeeks.com
%Date: 22 Oct 2012
%
%I allow the use and modification of this code for any purpose.
%Input checking
if ~isfloat(f)
  disp('Input must be a floating point number.');
  return;
end
f = single(f);
hex = '0123456789abcdef'; %Hex characters
h = num2hex(f);	%Convert from float to hex characters in IEEE 754 format (single only if num type is single)
hc = num2cell(h); %Convert to cell array of chars
nums =  cellfun(@(x) find(hex == x) - 1, hc); %Convert to array of numbers
bins = dec2bin(nums, 4); %Convert to array of binary number strings
b = reshape(bins.', 1, numel(bins)); %Reshape into horizontal vector
end
