function Fig3_decoding_bimodal

rootdir = 'C:\aging_centrality\';
cd(rootdir)

%% Parameter setting

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

nshuffle = 10; 
niteration=100;
Samp_GoHit  = .5;
Delay       = Samp_GoHit + 2;

w = [1 1 1];
num2age ={'Young','Middle','Advanced'};
ag2color = {[0 0 0],[1 0 1],[1 0 0]};

dec_filename='fig3_decoding_bimodal.mat';
load(dec_filename)


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


   cap =  num2age{a};

  subplot(3,3,a) 
    tmp = mean(decoding_accuracy1,3);
    imagesc(xaxis2,xaxis2,mean(tmp,3)); axis square %axis equal 
    %colormap jet; 
    colorbar;
    set(gca, 'TickDir', 'out');
    clim([0.5 1]);
    
    line([xaxis(1) xaxis(end)],[xaxis(1) xaxis(end)],'color','w')
    line([xaxis2(1) xaxis2(end)],[0 0],'color','w')
    line([xaxis2(1) xaxis2(end)],[Samp_GoHit Samp_GoHit],'color','w')
    line([xaxis2(1) xaxis2(end)],[Delay Delay],'color','w')
    line([0 0],[xaxis2(1) xaxis2(end)],'color','w')
    line([Samp_GoHit Samp_GoHit],[xaxis2(1) xaxis2(end)],'color','w')
    line([Delay Delay],[xaxis2(1) xaxis2(end)],'color','w')
    xlim([-.5 3]); ylim([-.5 3]);
    set(gca, 'TickDir', 'out');
    xlabel('Train time','fontsize',10); 
    ylabel('Test time','fontsize',10);
    title([cap ' High DC'])
   
  subplot(3,3,a+3)  
    tmp = mean(decoding_accuracy2,3);
    imagesc(xaxis2,xaxis2,mean(tmp,3)); axis square %axis equal 
    %colormap jet; 
    clim([0.5 1]);colorbar
    set(gca, 'TickDir', 'out');
    
    line([xaxis(1) xaxis(end)],[xaxis(1) xaxis(end)],'color','w')
    line([xaxis2(1) xaxis2(end)],[0 0],'color','w')
    line([xaxis2(1) xaxis2(end)],[Samp_GoHit Samp_GoHit],'color','w')
    line([xaxis2(1) xaxis2(end)],[Delay Delay],'color','w')
    line([0 0],[xaxis2(1) xaxis2(end)],'color','w')
    line([Samp_GoHit Samp_GoHit],[xaxis2(1) xaxis2(end)],'color','w')
    line([Delay Delay],[xaxis2(1) xaxis2(end)],'color','w')
    xlim([-.5 3]); ylim([-.5 3]);
    set(gca, 'TickDir', 'out');
    xlabel('Train time','fontsize',10); 
    ylabel('Test time','fontsize',10);
    title([cap ' Low DC'])
    

    % custom color map. white = 0; blue = -1; red = 1;
     rmap = [0:.01:1]'; omap = ones(size(rmap));
     cmap = [omap rmap rmap;flipud(rmap) flipud(rmap) omap];
    
   subplot(3,3,a+6)
    tmp = mean(decoding_accuracy1,3)-mean(decoding_accuracy2,3);
    imagesc(xaxis2,xaxis2,mean(tmp,3)); axis square %axis equal 
    colormap(flipud(cmap)); colorbar
    set(gca, 'TickDir', 'out');
    clim([-0.2 0.2]); 

    line([xaxis(1) xaxis(end)],[xaxis(1) xaxis(end)],'color','w')
    line([xaxis2(1) xaxis2(end)],[0 0],'color','w')
    line([xaxis2(1) xaxis2(end)],[Samp_GoHit Samp_GoHit],'color','w')
    line([xaxis2(1) xaxis2(end)],[Delay Delay],'color','w')
    line([0 0],[xaxis2(1) xaxis2(end)],'color','w')
    line([Samp_GoHit Samp_GoHit],[xaxis2(1) xaxis2(end)],'color','w')
    line([Delay Delay],[xaxis2(1) xaxis2(end)],'color','w')
    xlim([-.5 3]); ylim([-.5 3]);
    set(gca, 'TickDir', 'out');
    xlabel('Train time','fontsize',10); 
    ylabel('Test time','fontsize',10);
    title([cap ' High DC - Low DC'])
   
end
   

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
      time_separation_upper1 = time_separation_upper.young;  %iteration(100) x timeseparation
      time_separation_lower1 = time_separation_lower.young;
      time_separation_d_sh1  = time_separation_d_sh.young;   %niteration(100)xnshuffle x timeseparation
   elseif a==2
      decoding_accuracy1 = decoding_accuracy.upper.aged;
      decoding_accuracy2 = decoding_accuracy.lower.aged;
      time_separation_upper1 = time_separation_upper.aged;
      time_separation_lower1 = time_separation_lower.aged;
      time_separation_d_sh1  = time_separation_d_sh.aged;     
   elseif a==3
      decoding_accuracy1 = decoding_accuracy.upper.aaged;
      decoding_accuracy2 = decoding_accuracy.lower.aaged;
      time_separation_upper1 = time_separation_upper.aaged;
      time_separation_lower1 = time_separation_lower.aaged;
      time_separation_d_sh1  = time_separation_d_sh.aaged;    
   end

   % normal decoding value (along diagonal line)
   diag_decoding_accuracy1 = []; diag_decoding_accuracy2 = [];
   for t=1:size(decoding_accuracy1,1)
       diag_decoding_accuracy1 = [diag_decoding_accuracy1  squeeze(decoding_accuracy1(t,t,:))];
       diag_decoding_accuracy2 = [diag_decoding_accuracy2  squeeze(decoding_accuracy2(t,t,:))];
   end

   delay_bin = find(xaxis2>=0.5&xaxis2<=2.5);
   saxis = linspace(0,2,numel(delay_bin)); 
   

   %% time-series of decoding 
   subplot(3,3,a)
    color_upper = [0 0 1]; color_lower = [0 1 1]; 
    errorshade(xaxis2,mean(diag_decoding_accuracy1,1),std(diag_decoding_accuracy1,0,1)./sqrt(niteration-1), color_upper, color_upper+(w-color_upper)*.7); hold on
    errorshade(xaxis2,mean(diag_decoding_accuracy2,1),std(diag_decoding_accuracy2,0,1)./sqrt(niteration-1), color_lower, color_lower+(w-color_lower)*.7); hold on
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
   subplot(3,3,a+3)
   
   diag_decoding_accuracy1 = []; diag_decoding_accuracy2 = [];
   for t=1:size(decoding_accuracy1,1)
       diag_decoding_accuracy1 = [diag_decoding_accuracy1  squeeze(decoding_accuracy1(t,t,:))];
       diag_decoding_accuracy2 = [diag_decoding_accuracy2  squeeze(decoding_accuracy2(t,t,:))];
   end

   delay_bin = find(xaxis2>=0.5&xaxis2<=2.5);
   tmp1 = mean(diag_decoding_accuracy1(:,delay_bin),2);
   tmp2 = mean(diag_decoding_accuracy2(:,delay_bin),2);
   value = [tmp2 tmp1];

   thismean = mean(value,1); thissem = std(value,1)./sqrt(size(value,1)-1);
   errorbar(1:2, thismean, thissem, '-o', 'Color',ag2color{a},'LineWidth',2,'MarkerSize',5);hold on
   p = signrank(value(:,1),value(:,2));
   text(.3,.93, ['p =' num2str(p(1))] )
       
   set(gca, 'XTickLabel',{'Low DC', 'High DC'},'XTick',1:2);
   set(gca, 'TickDir', 'out');
   xlim([0 3]); ylim([.5,1])
   axis square
   box off

   ylabel('Decoding accuracy')
   title([num2age{a} ])

   %% cross temporal decoding
   subplot(3,3,a+6)
    errorshade(saxis,mean(time_separation_upper1,1),std(time_separation_upper1)./sqrt(niteration-1), color_upper, color_upper+(w-color_upper)*.7); hold on
    errorshade(saxis,mean(time_separation_lower1,1),std(time_separation_lower1)./sqrt(niteration-1), color_lower, color_lower+(w-color_lower)*.7); hold on
    
    alp = 0.05;
    p_c = alp/size(time_separation_upper1,2);
    p_time = [];
    for t=1:size(time_separation_upper1,2)
        [~,p] = ttest(time_separation_upper1(:,t),time_separation_lower1(:,t));
        p_time = [p_time p];
    end
    p_time = p_time< p_c;
    
    % Find the start and end of each segment
    d = diff([0 p_time 0]);
    start_idx = find(d == 1);
    end_idx = find(d == -1) - 1;
    % Plot each segment
    x = saxis;
    y = 1*ones(size(saxis));
    for i = 1:length(start_idx)
        idx = start_idx(i):end_idx(i);
        plot(x(idx), y(idx), '-','Color','k','LineWidth',2); hold on
    end
    if a==1
        text(1,0.95,['- p <', num2str(alp)])
    end
    
    dt_s = time_separation_upper1-time_separation_lower1; %niteration(100) x timeseparation
    dt_s = mean(dt_s,1);
    p_ts1 =[];
    for ts=1:size(dt_s,2)
        p_tmp = nnz(time_separation_d_sh1(:,ts)>dt_s(:,ts))/size(time_separation_d_sh1,1);
        p_tmp = min([p_tmp 1-p_tmp]);
        p_ts1 = [p_ts1  p_tmp];
    end
  
    if a==1
      p_ts.young = p_ts1;
    elseif a==2
      p_ts.aged  = p_ts1;
    elseif a==3
      p_ts.aaged = p_ts1;
    end

    ylim([.5 1.05])
    ylabel('Cross temporal decoding accuracy');
    xlabel('Time from diagonal(s)');
    axis square
    set(gca, 'TickDir', 'out');
end
   
    
end