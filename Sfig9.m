function Sfig9

rootdir = 'C:\aging_centrality\';
cd(rootdir)

tfname = 'sfig9_data.mat';
load(tfname)

num2age ={'Young','Middle','Advanced'};
ag2color = {[0 0 0],[1 0 1],[1 0 0]};


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

      %SI
      subplot(2,3,ag)
       value = T.SIavg(label,:);
       plot(1:2,value,'color',[.5 .5 .5]);hold on
       thismean = nanmean(value,1); thissem = nanstd(value,1)./sqrt(size(value,1)-1);
       e=errorbar(1:2, thismean, thissem, ['-o'], 'Color', ag2color{ag}, 'LineWidth',2,'MarkerSize',3);hold on
       e.CapSize = 0;
      
       set(gca, 'XTickLabel',{'Low DC', 'High DC'},'XTick',1:2);
       set(gca, 'TickDir', 'out');
       xlim([0 3]); ylim([0,0.6])
       box off
       ylabel(['|SI|avg'])
       title([num2age{ag}])


      %Sustained index 
      subplot(2,3,3+ag)
       value = T.SustainedIndex(label,:);
       plot(1:2,value,'color',[.5 .5 .5]);hold on
       thismean = nanmean(value,1); thissem = nanstd(value,1)./sqrt(size(value,1)-1);
       e=errorbar(1:2, thismean, thissem, ['-o'], 'Color', ag2color{ag}, 'LineWidth',2,'MarkerSize',3);hold on
       e.CapSize = 0;
       
       set(gca, 'XTickLabel',{'Low', 'High'},'XTick',1:2);
       set(gca, 'TickDir', 'out');
       xlim([0 3]); ylim([0,0.5])
       box off
       ylabel('Sustained index')
       title([num2age{ag}])

   end

   sgtitle('Relationship between delay accitivity and DC with significant SI')