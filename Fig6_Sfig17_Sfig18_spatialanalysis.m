function Fig6_Sfig17_Sfig18_spatialanalysis

rootdir = 'C:\aging_centrality\';
cd(rootdir)

tfname = 'fig6_distance_centrality.mat';
load(tfname)

num2age ={'Young','Middle','Advanced'};
age2color = {[0 0 0],[1 0 1],[1 0 0]};

num2agef = {'.yg','.a','.aa'};

%% Fig. 6
figure(	...  
                'Position',			[0 100 1450 1000],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10], ...
                'PaperSize',        [11 8.5] ...
      );hold on

for ag=1:3    

     %% local homogeneity
     subplot(2,3,1)
       disttmp = ['Ratio.all' num2agef{ag}]; 
       x = eval(disttmp);
       thishist = nanmean(x,1); 
       thissem  = nanstd(x,0,1)/sqrt(size(x,1)-1);
       xaxis = Dist_bin(2:end);
       e=errorbar(xaxis,thishist,thissem,['o'], 'Color',age2color{ag},'LineWidth',1.5,'MarkerSize',3 );hold on
       e.CapSize = 0;

       x = Dist_bin(1:end-1)'/1000;
       y = thishist';
       validIndices = ~isnan(y);
       x2 = x(validIndices);
       y2 = y(validIndices);
        % Define exponential function
       expEqn = @(b, c, x) y2(1) * exp(b * x + c);
       initialGuess = [-1, 0];
       fittedModel = fit(x2, y2, expEqn, 'Start', initialGuess);
       fb = fittedModel.b;
       fc = fittedModel.c;
       fit_hist = y2(1) * exp(fb * x2 + fc);
       plot(xaxis,fit_hist,'Color',age2color{ag},'LineWidth',1.5);hold on
       text(80,0.685-0.03*ag,['-' num2age{ag}],'Color',age2color{ag})

       if ag==3
        xlim([0 xaxis(end)+xaxis(1)]);
        axis square; box off
        set(gca, 'TickDir', 'out');
        xlabel('Distance (um)')
        ylabel('Local homogeneity of SI_H neuron');
       end


       subplot(2,3,2)
            disttmp = ['Ratio.sc.all' num2agef{ag}]; 
            x = eval(disttmp);
            thishist = nanmean(x,1); 
            thissem  = nanstd(x,0,1)/sqrt(size(x,1)-1);

            %shuffle data
            disttmp = ['Ratio.sc.all.sh' num2agef{ag} ]; 
            x_sh = eval(disttmp);  %iteration  x bin x session
            thishist_sh = squeeze(nanmedian(x_sh,3));  %iteration x bin
            top = prctile(thishist_sh,97.5,1);
            bot = prctile(thishist_sh,2.5,1);
      
            e=errorbar(ag,thishist,thissem, ['-o'],'Color',age2color{ag});hold on
            e.CapSize = 0;
            line([ag-0.3 ag+0.3],[top top],'LineStyle','-','Color',age2color{ag},'LineWidth',1);hold on
            line([ag-0.3 ag+0.3],[bot bot],'LineStyle','-','Color',age2color{ag},'LineWidth',1);hold on
            line([0 4],[0 0],'LineStyle','-','Color',[.5 .5 .5],'LineWidth',1);hold on

            if ag==3
                set(gca, 'XTickLabel',num2age,'XTick',1:3);
                ylim([-1.5 1]);
                xlim([0 4]);
                axis square
                box off
                set(gca, 'TickDir', 'out');
                ylabel('Spatial constant b');
            end


        %% distance
        subplot(2,3,ag+3)
            distHH = ['Dist_HHs' num2agef{ag}]; distHH = eval(distHH);
            distHL = ['Dist_HLs' num2agef{ag}]; distHL = eval(distHL);
            distLL = ['Dist_LLs' num2agef{ag}]; distLL = eval(distLL);
      
            thishist = [nanmean(distHH,1)   nanmean(distHL,1)   nanmean(distLL,1) ];
            thissem = [nanstd(distHH,0,1)/sqrt(size(distHH,1)-1)  nanstd(distHL,0,1)/sqrt(size(distHL,1)-1)  nanstd(distLL,0,1)/sqrt(size(distLL,1)-1)]; 

            xaxis = 1:size(thishist,2);
            e=errorbar(xaxis,thishist,thissem,['-o'], 'Color',age2color{ag},'LineWidth',1.5,'MarkerSize',5 );hold on
            e.CapSize = 0;
            set(gca, 'XTickLabel',{'SI_H-SI_H', 'SI_H-SI_L', 'SI_L-SI_L'},'XTick',xaxis, 'TickDir', 'out');
            xlim([0 xaxis(end)+1]);
            ylim([180 280]);
            axis square; box off
            ylabel('Distance (um)');
            title([num2age{ag}])

         sgtitle('Spatial organization of High SI neurons')

end




%% SFig. 17
figure(	...  
                'Position',			[0 100 1450 1000],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10], ...
                'PaperSize',        [11 8.5] ...
      );hold on

for ag=1:3    

     %% local homogeneity
     subplot(2,3,1)
       disttmp = ['Ratio.dc' num2agef{ag}]; 
       x = eval(disttmp);
       thishist = nanmean(x,1); 
       thissem  = nanstd(x,0,1)/sqrt(size(x,1));
       xaxis = Dist_bin(2:end);
       e=errorbar(xaxis,thishist,thissem,['o'], 'Color',age2color{ag},'LineWidth',1.5,'MarkerSize',3 );hold on
       e.CapSize = 0;

       x = Dist_bin(1:end-1)'/1000;
       y = thishist';
       validIndices = ~isnan(y);
       x2 = x(validIndices);
       y2 = y(validIndices);
        % Define exponential function
       expEqn = @(b, c, x) y2(1) * exp(b * x + c);
       initialGuess = [-1, 0];
       fittedModel = fit(x2, y2, expEqn, 'Start', initialGuess);
       fb = fittedModel.b;
       fc = fittedModel.c;
       fit_hist = y2(1) * exp(fb * x2 + fc);
       plot(xaxis,fit_hist,'Color',age2color{ag},'LineWidth',1.5);hold on
       text(350,0.75-0.05*ag,['-' num2age{ag}],'Color',age2color{ag})

       if ag==3
        xlim([0 xaxis(end)+xaxis(1)]);
        axis square; box off
        set(gca, 'TickDir', 'out');
        xlabel('Distance (um)')
        ylabel('Local homogeneity of High DC neurons');
       end


       subplot(2,3,2)
            disttmp = ['Ratio.sc.dc' num2agef{ag}]; 
            x = eval(disttmp);
            thishist = nanmean(x,1); 
            thissem  = nanstd(x,0,1)/sqrt(size(x,1)-1);

            %shuffle data
            disttmp = ['Ratio.sc.all.sh' num2agef{ag} ]; 
            x_sh = eval(disttmp);  %iteration  x bin x session
            thishist_sh = squeeze(nanmedian(x_sh,3));  %iteration x bin
            top = prctile(thishist_sh,97.5,1);
            bot = prctile(thishist_sh,2.5,1);
      
            e=errorbar(ag,thishist,thissem, ['-o'],'Color',age2color{ag});hold on
            e.CapSize = 0;
            line([ag-0.3 ag+0.3],[top top],'LineStyle','-','Color',age2color{ag},'LineWidth',1);hold on
            line([ag-0.3 ag+0.3],[bot bot],'LineStyle','-','Color',age2color{ag},'LineWidth',1);hold on
            line([0 4],[0 0],'LineStyle','-','Color',[.5 .5 .5],'LineWidth',1);hold on

            if ag==3
                set(gca, 'XTickLabel',num2age,'XTick',1:3);
                ylim([-5 1]);
                xlim([0 4]);
                axis square
                box off
                set(gca, 'TickDir', 'out');
                ylabel('Spatial constant b');
            end

        %% distance
        subplot(2,3,ag+3)
            distHH = ['Dist_HH' num2agef{ag}]; distHH = eval(distHH);
            distHL = ['Dist_HL' num2agef{ag}]; distHL = eval(distHL);
            distLL = ['Dist_LL' num2agef{ag}]; distLL = eval(distLL);
       
            thishist = [nanmean(distHH,1)   nanmean(distHL,1)   nanmean(distLL,1) ];
            thissem = [nanstd(distHH,0,1)/sqrt(size(distHH,1)-1)  nanstd(distHL,0,1)/sqrt(size(distHL,1)-1)  nanstd(distLL,0,1)/sqrt(size(distLL,1)-1)]; 

            xaxis = 1:size(thishist,2);
            e=errorbar(xaxis,thishist,thissem,['-o'], 'Color',age2color{ag},'LineWidth',1.5,'MarkerSize',5 );hold on
            e.CapSize = 0;
            set(gca, 'XTickLabel',{'High-High', 'High-Low', 'Low-Low'},'XTick',xaxis, 'TickDir', 'out');
            xlim([0 xaxis(end)+1]);
            ylim([140 280]);
            axis square;box off
            set(gca, 'TickDir', 'out');
            ylabel('Distance (um)');
            title([num2age{ag}])

        sgtitle('Spatial organization of High DC neurons')
end
        


%% SFig. 18
figure(	...  
                'Position',			[0 100 1000 1450],	...
                'PaperOrientation', 'portrait', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10], ...
                'PaperSize',        [11 8.5] ...
      );hold on

for ag=1:3    

      %% local homogeneity (SI-L neurons)
     subplot(3,2,1)
       disttmp = ['Ratio_low.all' num2agef{ag}]; 
       x = eval(disttmp);
       thishist = nanmean(x,1); 
       thissem  = nanstd(x,0,1)/sqrt(size(x,1));
       xaxis = Dist_bin(2:end);
       e=errorbar(xaxis,thishist,thissem,['o'], 'Color',age2color{ag},'LineWidth',1.5,'MarkerSize',3 );hold on
       e.CapSize = 0;

       x = Dist_bin(1:end-1)'/1000;
       y = thishist';
       validIndices = ~isnan(y);
       x2 = x(validIndices);
       y2 = y(validIndices);
        % Define exponential function
       expEqn = @(b, c, x) y2(1) * exp(b * x + c);
       initialGuess = [-1, 0];
       fittedModel = fit(x2, y2, expEqn, 'Start', initialGuess);
       fb = fittedModel.b;
       fc = fittedModel.c;
       fit_hist = y2(1) * exp(fb * x2 + fc);
       plot(xaxis,fit_hist,'Color',age2color{ag},'LineWidth',1.5);hold on
       text(10,0.75-0.05*ag,['-' num2age{ag}],'Color',age2color{ag})

       if ag==3
        xlim([0 xaxis(end)+xaxis(1)]);
        axis square; box off
        set(gca, 'TickDir', 'out');
        xlabel('Distance (um)')
        ylabel('Local homogeneity');
        title('Local homogeneity of SI_L neuron');
       end


       subplot(3,2,2)
            disttmp = ['Ratio_low.sc.all' num2agef{ag}]; 
            x = eval(disttmp);
            thishist = nanmean(x,1); 
            thissem  = nanstd(x,0,1)/sqrt(size(x,1));

            %shuffle data
            disttmp = ['Ratio.sc.all.sh' num2agef{ag} ]; 
            x_sh = eval(disttmp);  %iteration  x bin x session
            thishist_sh = squeeze(nanmedian(x_sh,3));  %iteration x bin
            top = prctile(thishist_sh,97.5,1);
            bot = prctile(thishist_sh,2.5,1);
      
            e=errorbar(ag,thishist,thissem, ['-o'],'Color',age2color{ag});hold on
            e.CapSize = 0;
            line([ag-0.3 ag+0.3],[top top],'LineStyle','-','Color',age2color{ag},'LineWidth',1);hold on
            line([ag-0.3 ag+0.3],[bot bot],'LineStyle','-','Color',age2color{ag},'LineWidth',1);hold on
            line([0 4],[0 0],'LineStyle','-','Color',[.5 .5 .5],'LineWidth',1);hold on

            if ag==3
                set(gca, 'XTickLabel',num2age,'XTick',1:3);
                ylim([-1.5 1]);
                xlim([0 4]);
                axis square
                box off
                set(gca, 'TickDir', 'out');
                ylabel('Spatial constant b');
            end



     %% local homogeneity (same selectivity)
     subplot(3,2,3)
       disttmp = ['Ratio.same' num2agef{ag}]; 
       x = eval(disttmp);
       thishist = nanmean(x,1); 
       thissem  = nanstd(x,0,1)/sqrt(size(x,1));
       xaxis = Dist_bin(2:end);
       e=errorbar(xaxis,thishist,thissem,['o'], 'Color',age2color{ag},'LineWidth',1.5,'MarkerSize',3 );hold on
       e.CapSize = 0;

       x = Dist_bin(1:end-1)'/1000;
       y = thishist';
       validIndices = ~isnan(y);
       x2 = x(validIndices);
       y2 = y(validIndices);
        % Define exponential function
       expEqn = @(b, c, x) y2(1) * exp(b * x + c);
       initialGuess = [-1, 0];
       fittedModel = fit(x2, y2, expEqn, 'Start', initialGuess);
       fb = fittedModel.b;
       fc = fittedModel.c;
       fit_hist = y2(1) * exp(fb * x2 + fc);
       plot(xaxis,fit_hist,'Color',age2color{ag},'LineWidth',1.5);hold on

       if ag==3
        xlim([0 xaxis(end)+xaxis(1)]);
        axis square; box off
        set(gca, 'TickDir', 'out');
        xlabel('Distance (um)')
        ylabel('Local homogeneity');
        title('SI_H neurons with same selectivity');
       end


       subplot(3,2,4)
            disttmp = ['Ratio.sc.same' num2agef{ag}]; 
            x = eval(disttmp);
            thishist = nanmean(x,1); 
            thissem  = nanstd(x,0,1)/sqrt(size(x,1));

            %shuffle data
            disttmp = ['Ratio.sc.same.sh' num2agef{ag} ]; 
            x_sh = eval(disttmp);  %iteration  x bin x session
            thishist_sh = squeeze(nanmedian(x_sh,3));  %iteration x bin
            top = prctile(thishist_sh,97.5,1);
            bot = prctile(thishist_sh,2.5,1);
      
            e=errorbar(ag,thishist,thissem, ['-o'],'Color',age2color{ag});hold on
            e.CapSize = 0;
            line([ag-0.3 ag+0.3],[top top],'LineStyle','-','Color',age2color{ag},'LineWidth',1);hold on
            line([ag-0.3 ag+0.3],[bot bot],'LineStyle','-','Color',age2color{ag},'LineWidth',1);hold on
            line([0 4],[0 0],'LineStyle','-','Color',[.5 .5 .5],'LineWidth',1);hold on

            if ag==3
                set(gca, 'XTickLabel',num2age,'XTick',1:3);
                ylim([-1.5 1]);
                xlim([0 4]);
                axis square
                box off
                set(gca, 'TickDir', 'out');
                ylabel('Spatial constant b');
            end


     %% local homogeneity (opposite selectivity)
     subplot(3,2,5)
       disttmp = ['Ratio.diff' num2agef{ag}]; 
       x = eval(disttmp);
       thishist = nanmean(x,1); 
       thissem  = nanstd(x,0,1)/sqrt(size(x,1));
       xaxis = Dist_bin(2:end);
       e=errorbar(xaxis,thishist,thissem,['o'], 'Color',age2color{ag},'LineWidth',1.5,'MarkerSize',3 );hold on
       e.CapSize = 0;

       x = Dist_bin(1:end-1)'/1000;
       y = thishist';
       validIndices = ~isnan(y);
       x2 = x(validIndices);
       y2 = y(validIndices);
        % Define exponential function
       expEqn = @(b, c, x) y2(1) * exp(b * x + c);
       initialGuess = [-1, 0];
       fittedModel = fit(x2, y2, expEqn, 'Start', initialGuess);
       fb = fittedModel.b;
       fc = fittedModel.c;
       fit_hist = y2(1) * exp(fb * x2 + fc);
       plot(xaxis,fit_hist,'Color',age2color{ag},'LineWidth',1.5);hold on

       if ag==3
        xlim([0 xaxis(end)+xaxis(1)]);
        axis square; box off
        set(gca, 'TickDir', 'out');
        xlabel('Distance (um)')
        ylabel('Local homogeneity');
        title('SI_H neurons with opposite selectivity');
       end


       subplot(3,2,6)
            disttmp = ['Ratio.sc.diff' num2agef{ag}]; 
            x = eval(disttmp);
            thishist = nanmean(x,1); 
            thissem  = nanstd(x,0,1)/sqrt(size(x,1));

            %shuffle data
            disttmp = ['Ratio.sc.diff.sh' num2agef{ag} ]; 
            x_sh = eval(disttmp);  %iteration  x bin x session
            thishist_sh = squeeze(nanmedian(x_sh,3));  %iteration x bin
            top = prctile(thishist_sh,97.5,1);
            bot = prctile(thishist_sh,2.5,1);
      
            e=errorbar(ag,thishist,thissem, ['-o'],'Color',age2color{ag});hold on
            e.CapSize = 0;
            line([ag-0.3 ag+0.3],[top top],'LineStyle','-','Color',age2color{ag},'LineWidth',1);hold on
            line([ag-0.3 ag+0.3],[bot bot],'LineStyle','-','Color',age2color{ag},'LineWidth',1);hold on
            line([0 4],[0 0],'LineStyle','-','Color',[.5 .5 .5],'LineWidth',1);hold on

            if ag==3
                set(gca, 'XTickLabel',num2age,'XTick',1:3);
                ylim([-1.5 1]);
                xlim([0 4]);
                axis square
                box off
                set(gca, 'TickDir', 'out');
                ylabel('Spatial constant b');
            end


end       





end