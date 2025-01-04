function Sfig1

rootdir = 'C:\aging_centrality\';
cd(rootdir)

tfname = 'sfig1_data.mat';
load(tfname)

num2age ={'Young','Middle','Advanced'};
cmax =5;cmin =0;

Sample_Dur  = 0.5;
sDelay_Dur  = 2;  %transform all different deley lengths into this value
frameRate_unified = 15;
histLength_PCA = [.5 3];  %new time window for using PCA

histLength =[5 10];
xaxis = linspace(-histLength(1),histLength(2),223);
xaxis_pca = xaxis>-histLength_PCA(1)&xaxis<histLength_PCA(2);
nxaxis = xaxis(xaxis_pca);

AG = PSTH{:,1};
LHT = PSTH{:,2};
RHT = PSTH{:,3};


for ag=1:3
      if ag==1
          label = AG=='y';
      elseif ag==2
          label = AG=='m';
      elseif ag==3
          label = AG=='a';
      end
      
      LHTtmp = LHT(label,:); 
      RHTtmp = RHT(label,:);

      delay_ind = nxaxis>Sample_Dur&nxaxis<Sample_Dur+sDelay_Dur;
      l_activity = mean(LHTtmp(:,delay_ind),2);
      r_activity = mean(RHTtmp(:,delay_ind),2);

      [~,i_l]= sort(l_activity,'descend' );
      [~,i_r]= sort(r_activity,'descend' );
      LHTtmp_l = LHTtmp(i_l,:);
      RHTtmp_l = RHTtmp(i_l,:);

      LHTtmp_r = LHTtmp(i_r,:);
      RHTtmp_r = RHTtmp(i_r,:);


   figure(	...  
                'Position',			[0 100 1100 800  ],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 8  ], ...
                'PaperSize',        [11 8.5  ] ...
      );hold on

  subplot(2,2,1)

     imagesc(LHTtmp_l);
     xlabel('Time from sample (s)');
     ylabel('Neurons sorted by left');
     title('Left trials');
     clim([cmin cmax]);
     colorbar;
     hold on;

     t0 = find(nxaxis>=0,1,'first');
     ts = find(nxaxis>=Sample_Dur,1,'first');
     td = find(nxaxis>=Sample_Dur+sDelay_Dur,1,'first');
     t1 = find(nxaxis>=1,1,'first');
     t2 = find(nxaxis>=2,1,'first');

     plot([t0, t0], ylim, 'w--', 'LineWidth', 1); % Vertical line to indicate delay period start
     plot([ts, ts], ylim, 'w--', 'LineWidth', 1); % Vertical line to indicate delay period start
     plot([td, td], ylim, 'w--', 'LineWidth', 1); % Vertical line to indicate delay period start
     yticks(500:500:size(LHTtmp,1));
     index_positions = [t0, t1, t2,];  
     x_labels = {'0', '1', '2'};  % x-axis labels
     xticks(index_positions);
     xticklabels(x_labels);
     set(gca, 'TickDir', 'out'); box off

   subplot(2,2,2)
     imagesc(RHTtmp_l);
     xlabel('Time from sample (s)');
     title('Right trials');
     clim([cmin cmax]);
     colorbar;
     hold on;
     plot([t0, t0], ylim, 'w--', 'LineWidth', 1); % Vertical line to indicate delay period start
     plot([ts, ts], ylim, 'w--', 'LineWidth', 1); % Vertical line to indicate delay period start
     plot([td, td], ylim, 'w--', 'LineWidth', 1); % Vertical line to indicate delay period start
     yticks(500:500:size(LHTtmp,1));
     index_positions = [t0, t1, t2,];  
     x_labels = {'0', '1', '2'};  % x-axis labels
     xticks(index_positions);
     xticklabels(x_labels);
     set(gca, 'TickDir', 'out'); box off


   subplot(2,2,3)
     imagesc(LHTtmp_r);
     xlabel('Time from sample (s)');
     ylabel('Neurons sorted by right');
     title('Left trials');
     clim([cmin cmax]);
     colorbar;
     hold on;

     plot([t0, t0], ylim, 'w--', 'LineWidth', 1); % Vertical line to indicate delay period start
     plot([ts, ts], ylim, 'w--', 'LineWidth', 1); % Vertical line to indicate delay period start
     plot([td, td], ylim, 'w--', 'LineWidth', 1); % Vertical line to indicate delay period start
     yticks(500:500:size(LHTtmp,1));
     index_positions = [t0, t1, t2,];  
     x_labels = {'0', '1', '2'};  % x-axis labels
     xticks(index_positions);
     xticklabels(x_labels);
     set(gca, 'TickDir', 'out'); box off

    
   subplot(2,2,4)
     imagesc(RHTtmp_r);
     xlabel('Time from sample (s)');
     title('Right trials');
     clim([cmin cmax]);
     colorbar;
     hold on;
     plot([t0, t0], ylim, 'w--', 'LineWidth', 1); % Vertical line to indicate delay period start
     plot([ts, ts], ylim, 'w--', 'LineWidth', 1); % Vertical line to indicate delay period start
     plot([td, td], ylim, 'w--', 'LineWidth', 1); % Vertical line to indicate delay period start
     yticks(500:500:size(LHTtmp,1));
     index_positions = [t0, t1, t2,];  
     x_labels = {'0', '1', '2'};  % x-axis labels
     xticks(index_positions);
     xticklabels(x_labels);
     set(gca, 'TickDir', 'out'); box off

   sgtitle(num2age{ag})

end




