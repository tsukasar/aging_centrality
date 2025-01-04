function Fig1_neuraldata


rootdir = 'C:\aging_centrality\';
cd(rootdir)

load fig1_neuraldata.mat  Spike_bin_resting Spike_bin_task  SpkcorrMat DC SIavg
Binsize = 100; % 100-ms bin size
tmp = [Spike_bin_resting Spike_bin_task];
line1 = size(Spike_bin_resting,2);
line2 = size(Spike_bin_resting,2)+size(Spike_bin_task,2);

%% raster plot
figure(	...  
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 1 80 30], ...
                'PaperSize',        [11 8.5] ...
      );hold on


imagesc(tmp); colormap(flipud(gray)); %colorbar; caxis([0 .1]); %colormap  gray; colorbar;%jet; hot  
line([line1 line1],[1 size(tmp,1)],'color','b')
line([line2 line2],[1 size(tmp,1)],'color','b')
clim([0 .0001]);

% Add horizontal scale bar
scaleBarLength = 5*60*1000/Binsize; % 5 min scale bar in x-axis units
scaleBarXStart = 0; % Starting x-coordinate of the scale bar
scaleBarY = - 5; % y-coordinate of the scale bar, near the bottom
line([scaleBarXStart, scaleBarXStart + scaleBarLength], ...
     [scaleBarY, scaleBarY], 'color', 'k', 'LineWidth', 2); % Horizontal scale bar
% Add text below the scale bar
textX = scaleBarXStart + scaleBarLength / 2; % Center of the scale bar
textY = scaleBarY - 2; % Slightly below the scale bar
text(textX, textY, '5 min', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10);

ylabel('Neurons')
set(gca, 'XTick', []);
set(gcf, 'Position', [0 100 1000 300])
set(gca, 'TickDir', 'out');
box off
       

%% RSFC matrix and correlation plot

figure(	...  
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 1 80 30], ...
                'PaperSize',        [11 8.5] ...
      );hold on

subplot(1,2,1)
    nROI = size(SpkcorrMat,1);
    imagesc(1:nROI,1:nROI,SpkcorrMat); colormap(flipud(gray)); colorbar %colormap  gray; colorbar;%jet; hot  caxis([0 .5]); 
    axis square
    set(gca, 'TickDir', 'out');
    xlabel('Neurons')
    title('RSFC matrix')

subplot(1,2,2)
    x1 = DC;
    y1 = SIavg; 
             
    mdl = fitlm(x1,y1);
    e = mdl.Coefficients.Estimate;
    [top_int, bot_int,xvals] = regression_line_ci(0.05,e,x1,y1);
    h2 = patch([xvals fliplr(xvals)],[bot_int fliplr(top_int)],[.9 .9 .9]);hold on
    set(h2,'EdgeColor','none');hold on
        
    [R, P] = corr(x1,y1, 'rows','complete','type','Pearson');
    [coeff,stats] = polyfit(x1,y1,1);
    [yfit,~] = polyval(coeff,x1,stats);
    plot(x1,yfit,'k'); hold on

    scatter(x1,y1,20,'bo');hold on
    title(sprintf('R=%s, P=%s',num2str(R),num2str(P)))
    ylabel('|SI|avg'); xlabel('Degree centrality')
    xlim([10 max(x1)+2]); ylim([0 min([1 max(y1)+0.2])])
    axis square
    box off
    set(gca, 'TickDir', 'out');

end