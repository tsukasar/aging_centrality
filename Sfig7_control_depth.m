function Sfig7_control_depth

rootdir = 'C:\aging_centrality\';
cd(rootdir)

tfname = 'sfig7_data.mat';
load(tfname)

num2age ={'Young','Middle','Advanced'};
ag2color = {[0 0 0],[1 0 1],[1 0 0]};
qxaxis = 1:4;


figure(	...  
                'Position',			[0 100 1450 1000],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10], ...
                'PaperSize',        [11 8.5] ...
 );hold on


for ag=1:3

         %|SI|avg
         subplot(2,3,ag)
            tmp = SIavg.quartile;
            if ag==1
                label = SIavg.AgeGroup=='y';
            elseif ag==2
                label = SIavg.AgeGroup=='m';
            elseif ag==3
                label = SIavg.AgeGroup=='a';
            end

            y = tmp(label,:);
            x1 = qxaxis; x1=repmat(x1,size(y,1),1);
            x1=x1(:); y1=y(:);
            mdl = fitlm(x1,y1);
            e = mdl.Coefficients.Estimate;
            [top_int, bot_int,xvals] = regression_line_ci(0.05,e,x1,y1);
            h2 = patch([xvals fliplr(xvals)],[bot_int fliplr(top_int)],[.9 .9 .9]);hold on
            set(h2,'EdgeColor','none');hold on
      
            [R, P] = corr(x1,y1, 'rows','complete','type','Pearson');
            [coeff,stats] = polyfit(x1,y1,1);
            [yfit,ci] = polyval(coeff,x1,stats);
            plot(x1,yfit,'b'); hold on

            thishist = mean(y,1);
            thissem  = std(y,0,1)/sqrt(size(y,1));
            for q=qxaxis
                e=errorbar(q,thishist(q),thissem(q),['o'], 'Color',ag2color{ag},'LineWidth',1.5,'MarkerSize',5 );hold on
                e.CapSize = 0;
            end

            set(gca, 'XTickLabel',{'1', '2', '3', '4'},'XTick',qxaxis);
            set(gca, 'TickDir', 'out');
            ylim([.1 0.31]); xlim([0 5])
            
            text(0.5, 0.3,[sprintf(' R=%s, P=%s',num2str(R),num2str(P))])
            title(num2age{ag})
            ylabel('|SI|avg'); xlabel('Centrality quartile');
            axis square; box off


         %Sustained index
         subplot(2,3,ag+3)
            tmp = SustainedIndex.quartile;
            y = tmp(label,:);
            x1 = qxaxis; x1=repmat(x1,size(y,1),1);
            x1=x1(:); y1=y(:);
            mdl = fitlm(x1,y1);
            e = mdl.Coefficients.Estimate;
            [top_int, bot_int,xvals] = regression_line_ci(0.05,e,x1,y1);
            h2 = patch([xvals fliplr(xvals)],[bot_int fliplr(top_int)],[.9 .9 .9]);hold on
            set(h2,'EdgeColor','none');hold on
      
            [R, P] = corr(x1,y1, 'rows','complete','type','Pearson');
            [coeff,stats] = polyfit(x1,y1,1);
            [yfit,ci] = polyval(coeff,x1,stats);
            plot(x1,yfit,'b'); hold on

            thishist = mean(y,1);
            thissem  = std(y,0,1)/sqrt(size(y,1));
            for q=qxaxis
                e=errorbar(q,thishist(q),thissem(q),['o'], 'Color',ag2color{ag},'LineWidth',1.5,'MarkerSize',5 );hold on
                e.CapSize = 0;
            end
            set(gca, 'XTickLabel',{'1', '2', '3', '4'},'XTick',1:4);
            set(gca, 'TickDir', 'out');
            ylim([0 0.15]); xlim([0 5])
            text(0.5, 0.14,[sprintf(' R=%s, P=%s',num2str(R),num2str(P))])
            title(num2age{ag})
            ylabel('Sustained index'); xlabel('Centrality quartile');
            axis square
            box off
end
