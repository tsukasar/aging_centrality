function Sfig5_SI_vs_network_metrics

rootdir = 'C:\aging_centrality\';
cd(rootdir)

tfname = 'sfig5_data.mat';
load(tfname)

num2age ={'Young','Middle','Advanced'};
ag2color = {[0 0 0],[1 0 1],[1 0 0]};


%% Core-periphery division
 figure(	...  
                'Position',			[0 100 1450 1000],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10], ...
                'PaperSize',        [11 8.5] ...
      );hold on

   for ag=1:3
      if ag==1
          label = T.AgeGroup=='y';
      elseif ag==2
          label = T.AgeGroup=='m';
      elseif ag==3
          label = T.AgeGroup=='a';
      end

      subplot(1,4,ag)
       value = [T.Peri(label) T.Core(label)];
       plot(1:2,value,'color',[.5 .5 .5]);hold on
       thismean = mean(value,1); thissem = std(value,1)./sqrt(size(value,1)-1);
       e=errorbar(1:2, thismean, thissem, ['-o'], 'Color', ag2color{ag}, 'LineWidth',2,'MarkerSize',5);hold on
       e.CapSize = 0;
       
       set(gca, 'XTickLabel',{ 'Peri','Core'},'XTick',1:2);
       set(gca, 'TickDir', 'out');
       xlim([0 3]); ylim([0,0.5])
       axis square
       box off
       ylabel(['|SI|avg'])
       title([num2age{ag}])


     subplot(1,4,4)
       dvalue1 = value(:,2)-value(:,1);
       thismean1 = median(dvalue1,1);
       b1 = bar(ag,thismean1,'FaceColor','none','EdgeColor','k','LineWidth',1);hold on
       scatter(zeros(size(dvalue1))+ag,dvalue1,'.', 'MarkerEdgeColor',ag2color{ag});hold on

       if ag==3
        set(gca, 'XTickLabel',num2age,'XTick',1:3);
        set(gca, 'TickDir', 'out');
        xlim([0 4]); ylim([-0.1,0.2])
        axis square; box off
        ylabel('d(|SI|avg(Core-Peri)')
        title('d(|SI|avg(Core-Peri)')
       end

   end
   sgtitle('Core-periphery division')
       

 %% Clustering coefficient
 figure(	...  
                'Position',			[0 100 1450 1000],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10], ...
                'PaperSize',        [11 8.5] ...
      );hold on

   for ag=1:3
      if ag==1
          label = T.AgeGroup=='y';
      elseif ag==2
          label = T.AgeGroup=='m';
      elseif ag==3
          label = T.AgeGroup=='a';
      end

      subplot(1,4,ag)
       value = [T.Clustering_low(label) T.Clustering_high(label)];
       plot(1:2,value,'color',[.5 .5 .5]);hold on
       thismean = nanmean(value,1); thissem = nanstd(value,1)./sqrt(size(value,1)-1);
       e=errorbar(1:2, thismean, thissem, ['-o'], 'Color', ag2color{ag}, 'LineWidth',2,'MarkerSize',5);hold on
       e.CapSize = 0;
       
       set(gca, 'XTickLabel',{ 'Low','High'},'XTick',1:2);
       set(gca, 'TickDir', 'out');
       xlim([0 3]); ylim([0,0.5])
       axis square
       box off
       ylabel(['|SI|avg'])
       title([num2age{ag}])


     subplot(1,4,4)
       dvalue1 = value(:,2)-value(:,1);
       thismean1 = nanmedian(dvalue1,1);
       b1 = bar(ag,thismean1,'FaceColor','none','EdgeColor','k','LineWidth',1);hold on
       scatter(zeros(size(dvalue1))+ag,dvalue1,'.', 'MarkerEdgeColor',ag2color{ag});hold on

       if ag==3
        set(gca, 'XTickLabel',num2age,'XTick',1:3);
        set(gca, 'TickDir', 'out');
        xlim([0 4]); ylim([-0.1,0.2])
        axis square; box off
        ylabel('d(|SI|avg(High-Low)')
        title('d(|SI|avg(High-Low)')
       end

   end
   sgtitle('Clustering coefficient')


    %% Betweenness centrality
 figure(	...  
                'Position',			[0 100 1450 1000],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10], ...
                'PaperSize',        [11 8.5] ...
      );hold on

   for ag=1:3
      if ag==1
          label = T.AgeGroup=='y';
      elseif ag==2
          label = T.AgeGroup=='m';
      elseif ag==3
          label = T.AgeGroup=='a';
      end

      subplot(1,4,ag)
       value = [T.Betweenness_low(label) T.Betweenness_high(label)];
       plot(1:2,value,'color',[.5 .5 .5]);hold on
       thismean = nanmean(value,1); thissem = nanstd(value,1)./sqrt(size(value,1)-1);
       e=errorbar(1:2, thismean, thissem, ['-o'], 'Color', ag2color{ag}, 'LineWidth',2,'MarkerSize',5);hold on
       e.CapSize = 0;
       
       set(gca, 'XTickLabel',{ 'Low','High'},'XTick',1:2);
       set(gca, 'TickDir', 'out');
       xlim([0 3]); ylim([0,0.5])
       axis square
       box off
       ylabel(['|SI|avg'])
       title([num2age{ag}])


     subplot(1,4,4)
       dvalue1 = value(:,2)-value(:,1);
       thismean1 = nanmedian(dvalue1,1);
       b1 = bar(ag,thismean1,'FaceColor','none','EdgeColor','k','LineWidth',1);hold on
       scatter(zeros(size(dvalue1))+ag,dvalue1,'.', 'MarkerEdgeColor',ag2color{ag});hold on

       if ag==3
        set(gca, 'XTickLabel',num2age,'XTick',1:3);
        set(gca, 'TickDir', 'out');
        xlim([0 4]); ylim([-0.13,0.28])
        axis square; box off
        ylabel('d(|SI|avg(High-Low)')
        title('d(|SI|avg(High-Low)')
       end

   end
   sgtitle('Betweenness centrality')