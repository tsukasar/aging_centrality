function Sfig12

rootdir = 'C:\aging_centrality\';
cd(rootdir)

tfname = 'sfig12_decoding_bimodal.mat';
load(tfname)

num2age ={'Young','Middle','Advanced'};
ag2color = {[0 0 0],[1 0 1],[1 0 0]};

%% Parameter setting

%time window for SVM
frameRate_unified = 15;  %unifying framerate 
histLength = [5,10];
win = 200;  % in ms 
movingwin = 50;
anova_window = round(win*frameRate_unified/1000);  % ms to frame unit
moving_win   = round(movingwin*frameRate_unified/1000);
tbin = -histLength(1)*frameRate_unified:moving_win:histLength(2)*frameRate_unified-anova_window;
xaxis = linspace(-histLength(1),histLength(2),numel(tbin));
iaxis = find(xaxis>-1&xaxis<4);
xaxis2 = xaxis(iaxis);
delay_bin = find(xaxis2>=0.5&xaxis2<=2.5);

%SVM parameters
nshuffle = 10;
niteration=100;  

 %% Merged decoding performance comparison across age-groups
figure;hold on
  
 for ag=1:3
     if ag==1
      decoding_accuracy1 = decoding_accuracy.merge.young;
      decoding_accuracy_sh1 = decoding_accuracy_sh.merge.young;  %iteration(100) x nshuffle
     elseif ag==2
      decoding_accuracy1 = decoding_accuracy.merge.aged;
      decoding_accuracy_sh1 = decoding_accuracy_sh.merge.aged;  %iteration(100) x nshuffle
     elseif ag==3
      decoding_accuracy1 = decoding_accuracy.merge.aaged;
      decoding_accuracy_sh1 = decoding_accuracy_sh.merge.aaged;  %iteration(100) x nshuffle
     end
      
     tmp = mean(decoding_accuracy1(:,delay_bin),2); %merge
     thismean = mean(tmp,1); thissem = std(tmp,1)./sqrt(size(tmp,1)-1);
     errorbar(ag, thismean, thissem, 'o', 'Color', ag2color{ag}, 'LineWidth',2,'MarkerSize',5);hold on
   
     decoding_accuracy_sh_delay = mean(decoding_accuracy_sh1(:,delay_bin),2);
     
     shtmp1 = 0;
     for n=1:niteration
       shtmp1 = shtmp1 + decoding_accuracy_sh_delay([1:nshuffle]+nshuffle*(n-1),:);
     end
     shtmp1= shtmp1/niteration;
   
     p_lines = prctile(shtmp1,[2.5 97.5],1);
     plot([.7 1.3]+ag-1,[p_lines(1,:) p_lines(1,:)],'--','Color', ag2color{ag}); hold on  
     plot([.7 1.3]+ag-1,[p_lines(2,:) p_lines(2,:)],'--','Color', ag2color{ag}); hold on  
    
 end

  set(gca, 'XTickLabel',num2age,'XTick',1:3);
  set(gca, 'TickDir', 'out');
  xlim([0 4]); ylim([.4,1])
  axis square; box off

  ylabel('Decoding accuracy')
  title('Decoding accuracy across the entire population')

