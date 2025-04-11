clc; clear all

load("C:\Users\ck2049\Downloads\v1\v1\class0.mat")
im1 = squeeze(class0(1,:,:));

new_time = 1:3000;
window_size = 328; 
overlap = round(0.8 * window_size); 
nfft = 110;

[s,f,t] = spectrogram(im1, window_size, overlap, nfft, 1, 'yaxis'); 
I = (normalize(abs(s)', 'range', [0 1]));
I = imrotate(I,90);