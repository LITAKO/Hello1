% 3 对匹配数据做MTI和MTD
clc;clear;close all;
load('after_pulse_compress.mat');

fs=60*10^6;

pri=100*10^(-6);
N=65;
c=3*10^8;
f=3*10^9;
vr=50;          %m/s
namda=c/f;
fd=2*vr/namda;
wd=2*pi*fd;
t=0:(1/fs):(N*pri-1/fs);
s=zeros(1,int32(N*pri*fs));
for i=1:65
     s(int32(pri*fs*(i-1)+1):int32(pri*fs*(i-1)+length(y1)))=y1;
end

S=s.*exp(1i*wd*t);

figure(1);
plot(t,real(S));
title('一帧信号');
xlabel('t');
ylabel('幅度');

%%数据重排
A=zeros(N,int32(pri*fs));
for i=1:N
    A(i,:)=S(int32(pri*fs*(i-1)+1):int32(pri*fs*i));
end

%%一次对消
B=zeros(N-1,int32(pri*fs));
for i=1:(N-1)
    B(i,:)=A(i,:)-A(i+1,:);
end

%%MTD
C=zeros(size(B));
for i=1:size(C,2)
    C(:,i)=abs(fft(B(:,i)'))';
end
T=pri;
Fd=0:1/((N-1)*T):(N-2)/((N-1)*T);
Fd=-(Fd-max(Fd));
figure(2);
plot(Fd,C);
title('MTD');
xlabel('fd/Hz');
ylabel('幅度');



