function Fig2_Sfig4

rootdir = 'C:\aging_centrality\';
cd(rootdir)

ag2color = {[0 0 0],[1 0 1],[1 0 0]};
w =[1 1 1];
num2age ={'Young','Middle','Advanced'};

load('fig2_sfig4_data.mat')

label = T.AgeGroup;


figure(	...  
                'Position',			[0 100 1450 1000],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10], ...
                'PaperSize',        [11 8.5] ...
  );hold on

   for ag=1:3
       
        if ag==1
             r1 = T.R_DCvsSIavg(label=='y');
             p1 = T.P_DCvsSIavg(label=='y');
        elseif ag==2
             r1 = T.R_DCvsSIavg(label=='m');
             p1 = T.P_DCvsSIavg(label=='m');
        elseif ag==3
             r1 = T.R_DCvsSIavg(label=='a');
             p1 = T.P_DCvsSIavg(label=='a');
        end

        subplot(1,3,ag)

         r1s = r1(p1<0.05);
         histogram(r1, 'BinWidth',0.05, 'BinLimits', [-0.6 0.6], 'FaceColor','w','FaceAlpha',0.1,'EdgeColor','k');hold on
         histogram(r1s,'BinWidth',0.05, 'BinLimits', [-0.6 0.6], 'FaceColor','r','FaceAlpha',0.1,'EdgeColor','r');hold on
         line([median(r1) median(r1)], [0 6],'Color','b' )
         line([0 0], [0 6],'Color','k' )

         axis square
         xlabel('Correlation')
         ylabel('# of sessions')
         title(num2age{ag})
         axis square
         box off
         set(gca, 'TickDir', 'out');

   end
   sgtitle('Correlation Degree centrality vs.|SI|avg')
   

%% Distribution of normalized DC

figure;hold on

pts = 0:0.01:1;
Norm_degree = Normalized_DC_fit{:,2};
label = Normalized_DC_fit{:,1};
for ag=3:-1:1
        if ag==1
             tmp = Norm_degree(label=='y',:);
        elseif ag==2
             tmp = Norm_degree(label=='m',:);
        elseif ag==3
             tmp = Norm_degree(label=='a',:);
        end
        
        dcolor = ag2color{ag};
        errorshade(pts,mean(tmp,1),std(tmp)./sqrt(size(tmp,1)-1), dcolor, dcolor+(w-dcolor)*.7); hold on
end

for ag=3:-1:1
        if ag==1
             tmp = Norm_degree(label=='y',:);
             tmpg = Normalized_DC{Normalized_DC{:,1}=='y',2};
        elseif ag==2
             tmp = Norm_degree(label=='m',:);
             tmpg = Normalized_DC{Normalized_DC{:,1}=='m',2};
        elseif ag==3
             tmp = Norm_degree(label=='a',:);
             tmpg = Normalized_DC{Normalized_DC{:,1}=='a',2};
        end
        dcolor = ag2color{ag};
        plot(pts,mean(tmp,1), 'Color',dcolor,'Linewidth',2); hold on

        
        line([mean(tmpg)-std(tmpg) mean(tmpg)+std(tmpg)],-0.01*(ag-1)+[0.1 0.1], 'Color',dcolor,'Linewidth',2);hold on
        plot(mean(tmpg),0.1-0.01*(ag-1), 'o','Color',dcolor); hold on
end

xlim([0 0.6])
title('Norm degree distribution')
set(gca, 'TickDir', 'out');
axis square; box off 


 %% |SI|avg vs. DC quartile
 qxaxis = 1:4;
 figure(	...  
                'Position',			[0 100 1450 1000],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10], ...
                'PaperSize',        [11 8.5] ...
  );hold on
       
  SIavg = [T.SIavg_q1  T.SIavg_q2  T.SIavg_q3  T.SIavg_q4];  %|SI|avg
  SIx   = [T.SelectivityIndex_q1  T.SelectivityIndex_q2  T.SelectivityIndex_q3  T.SelectivityIndex_q4];  %SelectivityIndex

  for ag=1:3
         
      if ag==1
          si  = SIavg(label=='y',:);
          six = SIx(label=='y',:);
      elseif ag==2
          si  = SIavg(label=='m',:);
          six = SIx(label=='m',:);
      elseif ag==3
          si  = SIavg(label=='a',:);
          six = SIx(label=='a',:);
      end

      subplot(2,3,ag)
            x1 = qxaxis; x1=repmat(x1,size(si,1),1);
            x1=x1(:); y1=si(:);
            mdl = fitlm(x1,y1);
            e = mdl.Coefficients.Estimate;
            [top_int, bot_int,xvals] = regression_line_ci(0.05,e,x1,y1);
            h2 = patch([xvals fliplr(xvals)],[bot_int fliplr(top_int)],[.9 .9 .9]);hold on
            set(h2,'EdgeColor','none');hold on
      
            [R, P] = corr(x1,y1, 'rows','complete','type','Pearson');
            [coeff,stats] = polyfit(x1,y1,1);
            [yfit,ci] = polyval(coeff,x1,stats);
            plot(x1,yfit,'b'); hold on

            thishist = mean(si,1);
            thissem  = std(si,0,1)/sqrt(size(si,1)-1);
            for q=qxaxis
                e=errorbar(q,thishist(q),thissem(q),['o'], 'Color',ag2color{ag},'LineWidth',1.5,'MarkerSize',5 );hold on
                e.CapSize = 0;
            end

            set(gca, 'XTickLabel',{'25', '50', '75', '100'},'XTick',qxaxis);
            set(gca, 'TickDir', 'out');
            ylim([.1 0.3]); xlim([0 5])
            text(0,0.27,sprintf(' R=%s, P=%s',num2str(R),num2str(P)))
            title(num2age{ag}) 
            ylabel('|SI|avg'); xlabel('Centrality quartile');
            axis square
            box off

       subplot(2,3,ag+3)      
            x1 = qxaxis; x1=repmat(x1,size(six,1),1);
            x1=x1(:); y1=six(:);
            mdl = fitlm(x1,y1);
            e = mdl.Coefficients.Estimate;
            [top_int, bot_int,xvals] = regression_line_ci(0.05,e,x1,y1);
            h2 = patch([xvals fliplr(xvals)],[bot_int fliplr(top_int)],[.9 .9 .9]);hold on
            set(h2,'EdgeColor','none');hold on
      
            [R, P] = corr(x1,y1, 'rows','complete','type','Pearson');
            [coeff,stats] = polyfit(x1,y1,1);
            [yfit,ci] = polyval(coeff,x1,stats);
            plot(x1,yfit,'b'); hold on

            thishist = mean(six,1);
            thissem  = std(six,0,1)/sqrt(size(six,1)-1);
            for q=qxaxis
                e=errorbar(q,thishist(q),thissem(q),['o'], 'Color',ag2color{ag},'LineWidth',1.5,'MarkerSize',5 );hold on
                e.CapSize = 0;
            end

            set(gca, 'XTickLabel',{'25', '50', '75', '100'},'XTick',qxaxis);
            set(gca, 'TickDir', 'out');
            ylim([0 0.15]); xlim([0 5])
            text(0,0.13,sprintf(' R=%s, P=%s',num2str(R),num2str(P)))
            title(num2age{ag}) 
            ylabel('Sustained index'); xlabel('Centrality quartile');
            axis square
            box off
  end


   

   %% 
   figure(	...  
                'Position',			[0 100 1450 1000],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10], ...
                'PaperSize',        [11 8.5] ...
      );hold on
    
   SI  = [T.SIavg_LowDC  T.SIavg_HighDC];
   SIX = [T.SustainedIndex_LowDC  T.SustainedIndex_HighDC];
   RS  = [T.Ratio_sustained_LowDC T.Ratio_sustained_HighDC];

   for ag=1:3
       if ag==1
          si  = SI(label=='y',:);
          six = SIX(label=='y',:);
          rs  = RS(label=='y',:);
      elseif ag==2
          si  = SI(label=='m',:);
          six = SIX(label=='m',:);
          rs  = RS(label=='m',:);
      elseif ag==3
          si  = SI(label=='a',:);
          six = SIX(label=='a',:);
          rs  = RS(label=='a',:);
       end


      %|SI|avg
      subplot(3,3,ag)
       value = si;
       plot(1:2,value,'color',[.5 .5 .5]);hold on
       thismean = mean(value,1); thissem = std(value,1)./sqrt(size(value,1)-1);
       e=errorbar(1:2, thismean, thissem, ['-o'], 'Color', ag2color{ag}, 'LineWidth',2,'MarkerSize',3);hold on
       e.CapSize = 0;
     
       set(gca, 'XTickLabel',{'Low DC', 'High DC'},'XTick',1:2);
       set(gca, 'TickDir', 'out');
       xlim([0 3]); ylim([0,0.5])
       box off
       ylabel('|SI|avg')
       title([num2age{ag}])


      %Sustained index
      subplot(3,3,3+ag)
       value = six;
       plot(1:2,value,'color',[.5 .5 .5]);hold on
       thismean = mean(value,1); thissem = std(value,1)./sqrt(size(value,1)-1);
       e=errorbar(1:2, thismean, thissem, ['-o'], 'Color', ag2color{ag}, 'LineWidth',2,'MarkerSize',3);hold on
       e.CapSize = 0;
      
       set(gca, 'XTickLabel',{'Low DC', 'High DC'},'XTick',1:2);
       set(gca, 'TickDir', 'out');
       xlim([0 3]); ylim([0,0.31])
       box off
       ylabel('Sustained index')   


      %Ratio sustained (%sig SI both early and late)
      subplot(3,3,6+ag)
       value = rs;
       plot(1:2,value,'color',[.5 .5 .5]);hold on
       thismean = mean(value,1); thissem = std(value,1)./sqrt(size(value,1)-1);
       e=errorbar(1:2, thismean, thissem, ['-o'], 'Color', ag2color{ag}, 'LineWidth',2,'MarkerSize',3);hold on
       e.CapSize = 0;
       
       set(gca, 'XTickLabel',{'Low DC', 'High DC'},'XTick',1:2);
       set(gca, 'TickDir', 'out');
       xlim([0 3]); ylim([0,0.9])
       box off
       ylabel('Ratio sustained')

   end
       

  
   %% summary -only degree d(high-low)
   figure(	...  
                'Position',			[0 100 1450 1000],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10], ...
                'PaperSize',        [11 8.5] ...
      );hold on
    
    for ag=1:3
       if ag==1
          si  = SI(label=='y',:);
          six = SIX(label=='y',:);
          rs  = RS(label=='y',:);
      elseif ag==2
          si  = SI(label=='m',:);
          six = SIX(label=='m',:);
          rs  = RS(label=='m',:);
      elseif ag==3
          si  = SI(label=='a',:);
          six = SIX(label=='a',:);
          rs  = RS(label=='a',:);
      end


      %|SI|avg
      subplot(1,3,1)
       dvalue1= si(:,2)-si(:,1);
       scatter(zeros(size(dvalue1))+ag,dvalue1, '.','MarkerEdgeColor',ag2color{ag});hold on
       thismean1 = median(dvalue1,1);
       b1 = bar(ag,thismean1,'FaceColor','none','EdgeColor','k','LineWidth',1);hold on

       if ag==3
        set(gca, 'XTickLabel',num2age,'XTick',1:3);
        set(gca, 'TickDir', 'out');
        xlim([0 4]); ylim([-0.1,0.2])
        axis square
        box off
        ylabel('d|SI|avg')
        title('d|SI|avg')
       end


      %Sustained index (SI early x SI late)
      subplot(1,3,2)
       dvalue1= six(:,2)-six(:,1);
       scatter(zeros(size(dvalue1))+ag,dvalue1, '.','MarkerEdgeColor',ag2color{ag});hold on
       thismean1 = median(dvalue1,1);
       b1 = bar(ag,thismean1,'FaceColor','none','EdgeColor','k','LineWidth',1);hold on

       if ag==3
        set(gca, 'XTickLabel',num2age,'XTick',1:3);
        set(gca, 'TickDir', 'out');
        xlim([0 4]); ylim([-0.11,0.15])
        axis square
        box off
        ylabel('dSustained index')
        title('dSustained index')
       end


      %Ratio sustained
      subplot(1,3,3)
       dvalue1= rs(:,2)-rs(:,1);
       scatter(zeros(size(dvalue1))+ag,dvalue1, '.','MarkerEdgeColor',ag2color{ag});hold on
       thismean1 = median(dvalue1,1); thissem1 = std(dvalue1,1)./sqrt(size(dvalue1,1)-1);
       b1 = bar(ag,thismean1,'FaceColor','none','EdgeColor','k','LineWidth',1);hold on

       if ag==3
        set(gca, 'XTickLabel',num2age,'XTick',1:3);
        set(gca, 'TickDir', 'out');
        xlim([0 4]); ylim([-0.25,0.4])
        axis square
        box off
        ylabel('dRatio sustained')
        title('dRatio sustained')
       end

    end