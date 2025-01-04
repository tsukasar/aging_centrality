function Sfig11

rootdir = 'C:\aging_centrality\';
cd(rootdir)

tfname = 'sfig11_decoding_bimodal.mat';
load(tfname)

num2age ={'Young','Middle','Advanced'};
ag2color = {[0 0 0],[1 0 1],[1 0 0]};

%% Parameter setting for decoding

%time window for SVM
frameRate_unified = 15;  %unifying framerate 
histLength = [5,10];
win = 200;  % in ms
movingwin = 50;
anova_window = round(win*frameRate_unified/1000);  % ms to frame unit
moving_win   = round(movingwin*frameRate_unified/1000);
tbin = -histLength(1)*frameRate_unified:moving_win:histLength(2)*frameRate_unified-anova_window;
xaxis = linspace(-histLength(1),histLength(2),numel(tbin)); %xaxis = xaxis+0.25; %adjust analysis window for SVM 
iaxis = find(xaxis>-1&xaxis<4);
xaxis2 = xaxis(iaxis);

niteration=100;
Samp_GoHit  = .5;
Delay       = Samp_GoHit + 2;
w = [1 1 1];

%% Figure of decording pfm sum all the data across age-groups
figure(	...  
                'Position',			[0 100 1050 1250],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 12], ...
                'PaperSize',        [11 8.5] ...
      );hold on
  
for a=group_analyze %age group
  
   if a==1
      decoding_accuracy1 = decoding_accuracy.upper.young;
      decoding_accuracy2 = decoding_accuracy.lower.young;
   elseif a==2
      decoding_accuracy1 = decoding_accuracy.upper.aged;
      decoding_accuracy2 = decoding_accuracy.lower.aged;
   elseif a==3
      decoding_accuracy1 = decoding_accuracy.upper.aaged;
      decoding_accuracy2 = decoding_accuracy.lower.aaged;
   end


   %% time-series of decoding 
   subplot(2,3,a)
    color_upper = [0 0 1]; color_lower = [0 1 1]; 
    errorshade(xaxis2,mean(decoding_accuracy1,1),std(decoding_accuracy1,0,1)./sqrt(niteration-1), color_upper, color_upper+(w-color_upper)*.7); hold on
    errorshade(xaxis2,mean(decoding_accuracy2,1),std(decoding_accuracy2,0,1)./sqrt(niteration-1), color_lower, color_lower+(w-color_lower)*.7); hold on
    
    minz = 0.4; maxz = 1;

    if a==1
        text(1,1-0.3,'-High DC','color',color_upper)
        text(1,1-0.4,'-Low DC','color',color_lower)
    end

    xlim([-.5 3]); ylim([minz maxz])
    plot([0 0],[min([0 minz*1.1]) maxz*1.1],'k'); hold on
    plot([xaxis2(1) xaxis2(end)],[0.5 0.5],'k--'); hold on
    plot([Samp_GoHit Samp_GoHit],[min([0 minz*1.2]) maxz*1.2],'k--');hold on
    plot([Delay Delay],[min([0 minz*1.2]) maxz*1.2],'k--');hold on
    ylabel('Decoding accuracy'); xlabel('Time from sample (s)');
    title(num2age{a})
    set(gca, 'TickDir', 'out');
    axis square

   %% average decoding accuracy along diagonal line
  subplot(2,3,a+3)
    delay_bin = find(xaxis2>=0.5&xaxis2<=2.5);
    tmp1 = mean(decoding_accuracy1(:,delay_bin),2); %high DC
    tmp2 = mean(decoding_accuracy2(:,delay_bin),2); %low DC
    value = [tmp2 tmp1];
    thismean = mean(value,1); thissem = std(value,1)./sqrt(size(value,1)-1);
    errorbar(1:2, thismean, thissem, '-o', 'Color',ag2color{a},'LineWidth',2,'MarkerSize',5);hold on
    p = signrank(value(:,1),value(:,2));
    text(.3,.93, ['p =' num2str(p(1))] )
       
    set(gca, 'XTickLabel',{'Low DC', 'High DC'},'XTick',1:2);
    set(gca, 'TickDir', 'out');
    xlim([0 3]); ylim([.5,1])
    axis square;box off

    ylabel('Decoding accuracy')
    title([num2age{a} ])

 
end