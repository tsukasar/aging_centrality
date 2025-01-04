function Fig1_Fig5_behavior(mode_flag)

%mode_flag 1: bimodal task  2: unimodal task

rootdir = 'C:\aging_centrality\';
cd(rootdir)

if mode_flag==1  %bimodal task
    tmpfile  = 'fig1_behavior.mat';
elseif mode_flag==2 % unimodal task
    tmpfile = 'fig5_behavior.mat';
end
load(tmpfile)

ag2color = {'k','m','r'};
num2age ={'Young','Middle','Advanced'};


%% Bimodal
if mode_flag==1

    figure(	...  
                'Position',			[0 100 1050 1250],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 12], ...
                'PaperSize',        [11 8.5] ...
      );hold on
  
   subplot(1,3,1)
        y1 = L.Day2criterion;
        label = L.AgeGroup;
        x{1} = y1(label=='y')'; 
        x{2} = y1(label=='m')'; 
        x{3} = y1(label=='a')'; 

        for ag=1:3
            thismean1 = nanmean(x{ag}); thissem1 = nanstd(x{ag},0,1)./sqrt(size(x{ag},1)-1);
            b1 = bar(ag,thismean1,'BarWidth',0.4, 'FaceColor','none','EdgeColor',ag2color{ag},'LineWidth',1);hold on
            scatter(ag*ones(size(x{ag})),x{ag},'o','MarkerEdgeColor',ag2color{ag});hold on
        end
        set(gca, 'XTickLabel',num2age,'XTick',1:numel(num2age),'TickDir', 'out');
        xlim([0 4])
        ylim([0 80])
        box off
        axis square
        ylabel('Daily sessions to criterion')  


    subplot(1,3,2)
        y1 = T.CorrectRate;
        label = T.AgeGroup;
        x{1} = y1(label=='y')'; 
        x{2} = y1(label=='m')'; 
        x{3} = y1(label=='a')'; 
        
        for ag=1:3
            thismean1 = nanmean(x{ag}); thissem1 = nanstd(x{ag},0,1)./sqrt(size(x{ag},1)-1);
            b1 = bar(ag,thismean1,'BarWidth',0.4, 'FaceColor','none','EdgeColor',ag2color{ag},'LineWidth',1);hold on
            scatter(ag*ones(size(x{ag})),x{ag},'o','MarkerEdgeColor',ag2color{ag});hold on
        end
        set(gca, 'XTickLabel',num2age,'XTick',1:numel(num2age),'TickDir', 'out');
        ylim([50 100])
        xlim([0 4])
        box off
        axis square
        ylabel('Correct rate (%)')
        
      
    subplot(1,3,3)
        y1 = T.ResponseTime;
        x{1} = y1(label=='y')'; 
        x{2} = y1(label=='m')'; 
        x{3} = y1(label=='a')'; 

        for ag=1:3
            thismean1 = nanmean(x{ag}); thissem1 = nanstd(x{ag},0,1)./sqrt(size(x{ag},1)-1);
            b1 = bar(ag,thismean1,'BarWidth',0.4, 'FaceColor','none','EdgeColor',ag2color{ag},'LineWidth',1);hold on
            scatter(ag*ones(size(x{ag})),x{ag},'o','MarkerEdgeColor',ag2color{ag});hold on
        end
        set(gca, 'XTickLabel',num2age,'XTick',1:numel(num2age),'TickDir', 'out');
        ylim([0  0.7])
        xlim([0 4])
        box off
        axis square
        ylabel('Response time(s)')
       
    sgtitle('Bimodal task performance')
   
     
%% unimodal
elseif mode_flag==2
   
    figure(	...  
                'Position',			[0 100 1050 1250],	...
                'PaperOrientation', 'portrait', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 12], ...
                'PaperSize',        [11 8.5] ...
     );hold on
  
    d_min=30; d_max=100;
    
    subplot(2,3,1)
        y1 = T.CorrectRate_bimodal;
        label = T.AgeGroup;
        x{1} = y1(label=='y')'; 
        x{2} = y1(label=='m')'; 
        x{3} = y1(label=='a')'; 

        for ag=1:3
            thismean1 = nanmean(x{ag}); thissem1 = nanstd(x{ag},0,1)./sqrt(size(x{ag},1)-1);
            b1 = bar(ag,thismean1,'FaceColor','none','EdgeColor',ag2color{ag},'LineWidth',1);hold on
            scatter(ag*ones(size(x{ag})),x{ag},'o','MarkerEdgeColor',ag2color{ag});hold on
        end
        set(gca, 'XTickLabel',num2age,'XTick',1:numel(num2age),'TickDir', 'out');
        ylim([d_min d_max])
        box off
        axis square
        ylabel('Correct rate(%)')
        title('Bimodal')
        

    subplot(2,3,2)
        y1 = T.CorrectRate_tactile;
        x{1} = y1(label=='y')'; 
        x{2} = y1(label=='m')'; 
        x{3} = y1(label=='a')'; 

        for ag=1:3
            thismean1 = nanmean(x{ag}); thissem1 = nanstd(x{ag},0,1)./sqrt(size(x{ag},1)-1);
            b1 = bar(ag,thismean1,'FaceColor','none','EdgeColor',ag2color{ag},'LineWidth',1);hold on
            scatter(ag*ones(size(x{ag})),x{ag},'o','MarkerEdgeColor',ag2color{ag});hold on
        end
        set(gca, 'XTickLabel',num2age,'XTick',1:numel(num2age),'TickDir', 'out');
        ylim([d_min d_max])
        box off
        axis square
        ylabel('Correct rate(%)')
        title('Tactile')
      

    subplot(2,3,3)
        y1 = T.CorrectRate_auditory;
        x{1} = y1(label=='y')'; 
        x{2} = y1(label=='m')'; 
        x{3} = y1(label=='a')'; 

        for ag=1:3
            thismean1 = nanmean(x{ag}); thissem1 = nanstd(x{ag},0,1)./sqrt(size(x{ag},1)-1);
            b1 = bar(ag,thismean1,'FaceColor','none','EdgeColor',ag2color{ag},'LineWidth',1);hold on
            scatter(ag*ones(size(x{ag})),x{ag},'o','MarkerEdgeColor',ag2color{ag});hold on
        end
        set(gca, 'XTickLabel',num2age,'XTick',1:numel(num2age),'TickDir', 'out');
        ylim([d_min d_max])
        box off
        axis square
        ylabel('Correct rate(%)')
        title('Auditory')

       
    %% Reaction time    

    d_min=0; d_max=1.3;
      
    subplot(2,3,4)
        y1 = T.ResponseTime_bimodal;
        x{1} = y1(label=='y')'; 
        x{2} = y1(label=='m')'; 
        x{3} = y1(label=='a')'; 

        for ag=1:3
            thismean1 = nanmean(x{ag}); thissem1 = nanstd(x{ag},0,1)./sqrt(size(x{ag},1)-1);
            b1 = bar(ag,thismean1,'FaceColor','none','EdgeColor',ag2color{ag},'LineWidth',1);hold on
            scatter(ag*ones(size(x{ag})),x{ag},'o','MarkerEdgeColor',ag2color{ag});hold on
        end
        set(gca, 'XTickLabel',num2age,'XTick',1:numel(num2age),'TickDir', 'out');
        ylim([d_min d_max])
        box off
        axis square
        ylabel('Response time(s)')
        title('Bimodal')

        
    subplot(2,3,5)
        y1 = T.ResponseTime_tactile;
        x{1} = y1(label=='y')'; 
        x{2} = y1(label=='m')'; 
        x{3} = y1(label=='a')'; 

        for ag=1:3
            thismean1 = nanmean(x{ag}); thissem1 = nanstd(x{ag},0,1)./sqrt(size(x{ag},1)-1);
            b1 = bar(ag,thismean1,'FaceColor','none','EdgeColor',ag2color{ag},'LineWidth',1);hold on
            scatter(ag*ones(size(x{ag})),x{ag},'o','MarkerEdgeColor',ag2color{ag});hold on
        end
        set(gca, 'XTickLabel',num2age,'XTick',1:numel(num2age),'TickDir', 'out');
        ylim([d_min d_max])
        box off
        axis square
        ylabel('Response time(s)')
        title('Tactile')


     subplot(2,3,6)
        y1 = T.ResponseTime_auditory;
       
        x{1} = y1(label=='y')'; 
        x{2} = y1(label=='m')'; 
        x{3} = y1(label=='a')'; 

        for ag=1:3
            thismean1 = nanmean(x{ag}); thissem1 = nanstd(x{ag},0,1)./sqrt(size(x{ag},1)-1);
            b1 = bar(ag,thismean1,'FaceColor','none','EdgeColor',ag2color{ag},'LineWidth',1);hold on
            scatter(ag*ones(size(x{ag})),x{ag},'o','MarkerEdgeColor',ag2color{ag});hold on
        end
        set(gca, 'XTickLabel',num2age,'XTick',1:numel(num2age),'TickDir', 'out');
        ylim([d_min d_max])
        box off
        axis square
        ylabel('Response time(s)')
        title('Auditory')

    sgtitle('Unimodal task performance')
   
end