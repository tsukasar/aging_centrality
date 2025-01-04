function Fig5_neural_analyses

rootdir = 'C:\aging_centrality\';
cd(rootdir)
load('fig5_neuraldata.mat')

ag2color = {[0 0 0],[1 0 1],[1 0 0]};
w =[1 1 1];
num2age ={'Young','Middle','Advanced'};
qxaxis =1:4;

label = CrossmodalIndex.AgeGroup;
tmp  = CrossmodalIndex.quartile;
tmp2 = CrossmodalIndex.LowHigh;

figure(	...  
                'Position',			[0 100 1450 1000],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10] ...
 );hold on
    
for ag=1:3
   subplot(2,4,ag)
            if ag==1
                y  = tmp(label=='y',:);
            elseif ag==2
                y  = tmp(label=='m',:);
            elseif ag==3
                y  = tmp(label=='a',:);
            end 

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
            ylim([-0.01 0.08]); xlim([0 5])
            text(0.2,0.07,sprintf(' R=%s, P=%s',num2str(R),num2str(P)))
            title(num2age{ag})
            
            ylabel('Crossmodal index'); xlabel('Centrality quartile');
            axis square; box off
       
       
       subplot(2,4,ag+4)
            if ag==1
                value  = tmp2(label=='y',:);
            elseif ag==2
                value  = tmp2(label=='m',:);
            elseif ag==3
                value  = tmp2(label=='a',:);
            end 

            plot(1:2,value,'color',[.5 .5 .5]);hold on
            thismean = nanmean(value,1); thissem = nanstd(value,1)./sqrt(size(value,1)-1);
            e=errorbar(1:2, thismean, thissem, ['-o'], 'Color', ag2color{ag}, 'LineWidth',2,'MarkerSize',5);hold on
            e.CapSize = 0;
            
            set(gca, 'XTickLabel',{'Low DC','High DC'},'XTick',1:2);
            set(gca, 'TickDir', 'out');
            xlim([0 3]); ylim([-0.05,0.25])
            axis square; box off
            ylabel('Crossmodal index')
            title(num2age{ag})


       subplot(2,4,8)
            dvalue1 = value(:,2)-value(:,1);
            thismean1 = median(dvalue1,1);
            b1 = bar(ag,thismean1,'FaceColor','none','EdgeColor','k','LineWidth',1);hold on
            scatter(zeros(size(dvalue1))+ag,dvalue1,'.', 'MarkerEdgeColor',ag2color{ag});hold on

            if ag==3
                set(gca, 'XTickLabel',num2age,'XTick',1:3);
                set(gca, 'TickDir', 'out');
                xlim([0 4]); ylim([-0.05,0.15])
                axis square; box off
                ylabel('d Crossmodal index')
                title('d Crossmodal index')
            end


end