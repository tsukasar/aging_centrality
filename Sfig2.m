function Sfig2

rootdir = 'C:\aging_centrality\';
cd(rootdir)

tfname = 'sfig2_data.mat';
load(tfname)

num2age ={'Young','Middle','Advanced'};
age2color = {[0 0 0],[1 0 1],[1 0 0]};
num2period = {'Sample','Early delay','Late delay','Feedback'};


%% Distribtion of |SI| for each task period 

   figure(	...  
                'Position',			[0 100 1450 1000],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10], ...
                'PaperSize',        [11 8.5] ...
      );hold on

   Dist_bin = linspace(-1,1,30);
    
   for ag=1:3 

      if ag==1
          label = SI.AgeGroup=='y';
      elseif ag==2
          label = SI.AgeGroup=='m';
      elseif ag==3
          label = SI.AgeGroup=='a';
      end

      SI_tmp = SI.period(label,:);
      SI_p_tmp = SI.pvalue(label,:);

      for p=1:size(SI_tmp,2)
        
       subplot(4,4,ag+4*(p-1))

        [bincounts,ind] = histc(SI_tmp(:,p),Dist_bin);hold on
        h1 =bar(Dist_bin,bincounts,'histc'); 
        set(h1,'EdgeColor','k','FaceColor','none');
        
        sig = SI_p_tmp(:,p)<0.025;
        [bincounts,ind] = histc(SI_tmp(sig,p),Dist_bin);hold on
        h2 =bar(Dist_bin,bincounts,'histc'); 
        set(h2,'EdgeColor','k','FaceColor','r');
        
        ratio_sig = 100*nnz(sig)/size(SI_p_tmp,1);
        text(-1,300,{'significant SI', [num2str(ratio_sig) '%']})
        xlim([-1 1]);
        if p==1
            ylim([0 600])
        elseif p==2
            ylim([0 600])
        elseif p==3
            ylim([0 500])
        elseif p==4
            ylim([0 500])
        end
        ylabel('#Neurons')
        xlabel('Selectivity index (SI)')
        
        title({num2age{ag},  num2period{p} })
        axis square
        box off


       subplot(4,4,4*p)

        tmp_value = abs(SI_tmp(sig,p));
        thishist = mean(tmp_value,1);
        thissem = std(tmp_value,0,1)./sqrt(size(tmp_value,1)-1);
        e=errorbar(ag,thishist,thissem,['o'], 'Color',age2color{ag},'LineWidth',1.5,'MarkerSize',3);hold on
        e.CapSize = 0;

        if ag==3
            set(gca, 'XTickLabel',num2age,'XTick',1:3);
            set(gca, 'TickDir', 'out');
            xlim([0 4])
         
            if p==1
                ylim([0.2 0.35])
            elseif p==2
                ylim([0.25 0.4])
            elseif p==3
                ylim([0.25 0.4])
            elseif p==4
                ylim([0.25 0.43])
            end
            
            ylabel('|SI|')
            title([num2period{p}])
            axis square; box off
        end
                
    
      end

    end
    sgtitle('Action-plan selectivity (SI) across task periods');
        
   