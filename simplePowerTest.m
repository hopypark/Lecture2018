clear
DELIMITER='\t';
HEADERLINES=1;
SAMPLING_FREQUENCY = 500;
%nFFT = 4096;
%hp = 0.5;
%lp = 100;
%fir_order = 0.22;%2/lp;

[filename,pathname]=uigetfile('F:\SNU_DATA\DEPRESSION_LJH\*.txt','file open...', 'MultiSelect', 'on');

D=importdata([pathname,filename], DELIMITER, HEADERLINES);
rawS=D.data(:,2)'; % 21ch-eeg, VEOG, HEOG, ECG

  
    figure('position',[300 200 1000 500])

    % raw signal
    subplot(3,2,[1 2]);
    plot((1:length(rawS))./SAMPLING_FREQUENCY, rawS);
    xlabel('time(s)');ylabel('Amplitude');
    title(['Raw Signal: ' strrep(strrep(filename, '.mat',''),'_','-')],'fontsize',13);
    S=detrend(rawS')'; % removes linear trend in data  
    % detrended signal
    subplot(3,2,[3 4]);
    plot((1:length(S))./SAMPLING_FREQUENCY, S);
    xlabel('time(s)');ylabel('Amplitude');
    title('Detrended Signal','fontsize',13);
        
    
    nFFT = 2^(nextpow2(length(S)));    
    f = SAMPLING_FREQUENCY*(0:(nFFT/2))/nFFT;
    Y = fft(S,nFFT);
    P2 = abs(Y/nFFT); % amplitude,  abs(Y/L).^2 - Power
    P1 = P2(1:nFFT/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    
    % fft-amplitude    
    subplot(3,2,5);
    plot(f,P1) 
    xlabel('f (Hz)')
    ylabel('Amplitude(f)')
    xlim([0 100]);ylim([0 45]);

    % fft - amplitude 
    % zoom in
    subplot(3,2,6)
    plot(f,P1)
    xlabel('f (Hz)')
    ylabel('Amplitude(f)')
    xlim([0 50]);ylim([0 1]);
    

% 
% deSignal = detrend(tmpSignal,'linear');  % use inbuilt detrend function
% 
% [Signal] = nbt_filter_fir(deSignal, 0.5, 100, nFS ,20);   
% 
% % m=[];
% % b = fir1(floor(fir_order*nFS),[hp lp]/(nFS/2));
% % for ii=1:24
% %     %m = mean(deSignal(ii,:));
% %     %rmSignal(ii,:) = deSignal(ii,:)-m;
% %     temp = filter(b,1,deSignal(ii,:));
% %     Signal(ii,:) = temp(1, (nFS*fir_order*hp*2):end);
% % end
%     
% 
% [p,f]=pwelch(Signal(1,:),hamming(nFFT),[],nFFT,nFS);
% 
% %p=sqrt(p);
% len = size(Signal,2);
% figure('position',[100,100,1000,700]);
% plot((1:len)./nFS, tmpSignal(1,:));grid;
% ylabel('Amplitude (\muV)');
% 
% figure('position',[100,100,800,600]);
% plot(f,p)
% xlim([0 nFS/2]);grid minor;
% title('Power-Cz','fontweight','bold')
% ylabel('PSD ');ylim([0 100])


% L=8192;%length(8192);
% n = 2^nextpow2(L);
% Y = fft(Signal(1,:),n);   
% 
% f = nFS*(0:(n/2))/n;
% P = abs(Y/n);
% figure('position',[100,100,1000,700]);
% subplot(2,1,1);plot(f,P(1:n/2+1)) 
% title([filename '-Cz'],'fontsize',13)
% xlabel('Frequency (f)')
% ylabel('|P(f)|')
% grid;xlim([0 100]);
% 
% 
% Y = fft(Signal(1,:),n);   
% 
% f = nFS*(0:(n/2))/n;
% P = abs(Y/n);
% 
% subplot(2,1,2);plot(f,P(1:n/2+1)) 
% title([filename '-ECG'],'fontsize',13)
% xlabel('Frequency (f)')
% ylabel('|P(f)|')
% grid;xlim([0 100]);