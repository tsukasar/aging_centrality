function Sfig6_lick_effect_bimodal

rootdir = 'C:\aging_centrality\';
cd(rootdir)

tfname = 'sfig6_data.mat';
load(tfname)

num2age ={'Young','Middle','Advanced'};
ag2color = {[0 0 0],[1 0 1],[1 0 0]};

   %% summary -only degree d(high-low)
   figure(	...  
                'Position',			[0 100 1450 1000],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10], ...
                'PaperSize',        [11 8.5] ...
      );hold on
    

     %|SI|avg
     subplot(1,3,1)
       tmp = T.dSIavg;
       for ag=1:3
          if ag==1
            label = T.AgeGroup=='y';
          elseif ag==2
            label = T.AgeGroup=='m';
          elseif ag==3
            label = T.AgeGroup=='a';
          end

          dvalue1 = tmp(label);
          thismean1 = median(dvalue1,1); 
          b1 = bar(ag,thismean1,'FaceColor','none','EdgeColor','k','LineWidth',1);hold on
          scatter(zeros(size(dvalue1))+ag,dvalue1,'.','MarkerEdgeColor',ag2color{ag});hold on
          if ag==3
            set(gca, 'XTickLabel',num2age,'XTick',1:3);
            set(gca, 'TickDir', 'out');
            xlim([0 4]); ylim([-0.2,0.15])
            axis square; box off
            ylabel('d|SI|avg')
            title('d|SI|avg(High - Low DC)')
          end
       end

      %Sustained index
      subplot(1,3,2)
       tmp = T.dSustained_index;
       for ag=1:3
          if ag==1
            label = T.AgeGroup=='y';
          elseif ag==2
            label = T.AgeGroup=='m';
          elseif ag==3
            label = T.AgeGroup=='a';
          end

          dvalue1 = tmp(label);
          thismean1 = median(dvalue1,1); 
          b1 = bar(ag,thismean1,'FaceColor','none','EdgeColor','k','LineWidth',1);hold on
          scatter(zeros(size(dvalue1))+ag,dvalue1,'.','MarkerEdgeColor',ag2color{ag});hold on
          if ag==3
            set(gca, 'XTickLabel',num2age,'XTick',1:3);
            set(gca, 'TickDir', 'out');
            xlim([0 4]); ylim([-0.15,0.15])
            axis square; box off
            ylabel('dSustained index')
            title('dSustained index (High - Low DC)')
          end
       end


      %Ratio sustained (%sig SI both early and late)
      subplot(1,3,3)
       tmp = T.dRatio_sustained;
       for ag=1:3
          if ag==1
            label = T.AgeGroup=='y';
          elseif ag==2
            label = T.AgeGroup=='m';
          elseif ag==3
            label = T.AgeGroup=='a';
          end

          dvalue1 = tmp(label);
          thismean1 = median(dvalue1,1); 
          b1 = bar(ag,thismean1,'FaceColor','none','EdgeColor','k','LineWidth',1);hold on
          scatter(zeros(size(dvalue1))+ag,dvalue1,'.','MarkerEdgeColor',ag2color{ag});hold on
          if ag==3
            set(gca, 'XTickLabel',num2age,'XTick',1:3);
            set(gca, 'TickDir', 'out');
            xlim([0 4]); ylim([-0.2,0.3])
            axis square; box off
            ylabel('dRatio sustained')
            title('dRatio sustained (High - Low DC)')
          end
       end

       sgtitle('DC based on resting state excluding peri-licking period')