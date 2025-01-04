function Fig5_decoding_unimodal

rootdir = 'C:\aging_centrality\';
cd(rootdir)

dec_filename='fig5_decoding_unimodal.mat';
load(dec_filename)

num2age ={'Young','Middle','Advanced'};

%% Parameter setting
%SVM parameters
nshuffle = 500;
niteration=100;

%% stat figure
figure(	...  
                'Position',			[0 100 1050 1250],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 12], ...
                'PaperSize',        [11 8.5] ...
      );hold on

for a=group_analyze 

   if a==1
      decoding_accuracy_period1 = decoding_accuracy_period.upper.young;
      decoding_accuracy_period2 = decoding_accuracy_period.lower.young;
      decoding_accuracy_period_shfl1 = decoding_accuracy_period_shfl.upper.young;
      decoding_accuracy_period_shfl2 = decoding_accuracy_period_shfl.lower.young;
   elseif a==2
      decoding_accuracy_period1 = decoding_accuracy_period.upper.aged;
      decoding_accuracy_period2 = decoding_accuracy_period.lower.aged;
      decoding_accuracy_period_shfl1 = decoding_accuracy_period_shfl.upper.aged;
      decoding_accuracy_period_shfl2 = decoding_accuracy_period_shfl.lower.aged;
   elseif a==3
      decoding_accuracy_period1 = decoding_accuracy_period.upper.aaged;
      decoding_accuracy_period2 = decoding_accuracy_period.lower.aaged;
      decoding_accuracy_period_shfl1 = decoding_accuracy_period_shfl.upper.aaged;
      decoding_accuracy_period_shfl2 = decoding_accuracy_period_shfl.lower.aaged;
   end
   
 subplot(1,3,a)
   
   %High DC
   %normal decoding(X to X)
   x2x_h = (decoding_accuracy_period1.A2A + decoding_accuracy_period1.T2T)/2;
   x2x_h = mean(x2x_h(:,3:4),2);
   %swap decoding(X to Y)
   x2y_h = (decoding_accuracy_period1.A2T + decoding_accuracy_period1.T2A)/2;
   x2y_h = mean(x2y_h(:,3:4),2);
   tmp = [x2x_h x2y_h];
   deccolor_h = [1 0 0];
   errorbar(1:2,mean(tmp,1),std(tmp)./sqrt(size(tmp,1)-1),'-','Color', deccolor_h,'LineWidth',1,'Marker','.','MarkerSize',15);hold on

   %shuffled data
   x2xs_h = (decoding_accuracy_period_shfl1.A2A + decoding_accuracy_period_shfl1.T2T)/2;
   x2xs_h = mean(x2xs_h(:,3:4),2);
   tmp2 = 0;
   for n=1:niteration
       tmp2 =tmp2 + x2xs_h([1:nshuffle]+nshuffle*(n-1));
   end
   tmp2= tmp2/niteration;
   p_lines_x2x = prctile(tmp2,[2.5 97.5],1);
   
   x2ys_h = (decoding_accuracy_period_shfl1.A2T + decoding_accuracy_period_shfl1.T2A)/2;
   x2ys_h = mean(x2ys_h(:,3:4),2);
   tmp2 = 0;
   for n=1:niteration
       tmp2 =tmp2 + x2ys_h([1:nshuffle]+nshuffle*(n-1));
   end
   tmp2= tmp2/niteration;
   p_lines_x2y = prctile(tmp2,[2.5 97.5],1);
   plot([.8 1.2],[p_lines_x2x(1,:) p_lines_x2x(1,:)],'--','color',deccolor_h); hold on   
   plot([.8 1.2],[p_lines_x2x(2,:) p_lines_x2x(2,:)],'--','color',deccolor_h); hold on   
   plot([1.8 2.2],[p_lines_x2y(1,:) p_lines_x2y(1,:)],'--','color',deccolor_h); hold on 
   plot([1.8 2.2],[p_lines_x2y(2,:) p_lines_x2y(2,:)],'--','color',deccolor_h); hold on 


   %Low DC
   %XX decoding(X to X)
   x2x_l = (decoding_accuracy_period2.A2A + decoding_accuracy_period2.T2T)/2;
   x2x_l = mean(x2x_l(:,3:4),2);
   %XY decoding(X to Y)
   x2y_l = (decoding_accuracy_period2.A2T + decoding_accuracy_period2.T2A)/2;
   x2y_l = mean(x2y_l(:,3:4),2);
   tmp = [x2x_l x2y_l];
   deccolor_l = [0 0 1];
   errorbar(3:4,mean(tmp,1),std(tmp)./sqrt(size(tmp,1)-1),'-','Color', deccolor_l,'LineWidth',1,'Marker','.','MarkerSize',15);hold on

  
   %shuffled data
   x2xs_l = (decoding_accuracy_period_shfl2.A2A + decoding_accuracy_period_shfl2.T2T)/2;
   x2xs_l = mean(x2xs_l(:,3:4),2);
   tmp2 = 0;
   for n=1:niteration
       tmp2 =tmp2 + x2xs_l([1:nshuffle]+nshuffle*(n-1));
   end
   tmp2= tmp2/niteration;
   p_lines_x2x = prctile(tmp2,[2.5 97.5],1);

   x2ys_l = (decoding_accuracy_period_shfl2.A2T + decoding_accuracy_period_shfl2.T2A)/2;
   x2ys_l = mean(x2ys_l(:,3:4),2);
   tmp2 = 0;
   for n=1:niteration
       tmp2 =tmp2 + x2ys_l([1:nshuffle]+nshuffle*(n-1),:);
   end
   tmp2= tmp2/niteration;
   p_lines_x2y = prctile(tmp2,[2.5 97.5],1);

   plot([2.8 3.2],[p_lines_x2x(1,:) p_lines_x2x(1,:)],'--','color',deccolor_l); hold on   
   plot([2.8 3.2],[p_lines_x2x(2,:) p_lines_x2x(2,:)],'--','color',deccolor_l); hold on   
   plot([3.8 4.2],[p_lines_x2y(1,:) p_lines_x2y(1,:)],'--','color',deccolor_l); hold on 
   plot([3.8 4.2],[p_lines_x2y(2,:) p_lines_x2y(2,:)],'--','color',deccolor_l); hold on 

   set(gca, 'XTickLabel',{'XX(HighDC)','XY(HighDC)','XX(LowDC)','XY(LowDC)'}, 'XTick',1:4);hold on
   set(gca, 'TickLabelInterpreter', 'tex');  % Use 'latex' for advanced formatting
   set(gca, 'TickDir', 'out');
   xlim([0 5]); ylim([0.4 1])
   title(num2age{a})
   axis square; box off
   
   sgtitle('Decoding accuracy in unimodal task')

end
