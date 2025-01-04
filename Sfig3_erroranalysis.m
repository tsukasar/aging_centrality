function Sfig3_erroranalysis

rootdir = 'C:\aging_centrality\';
cd(rootdir)

tfname = 'sfig3_data.mat';
load(tfname)

num2age ={'Young','Middle','Advanced'};
ag2color = {[0 0 0],[1 0 1],[1 0 0]};

figure;hold on

  for ag=1:3
      if ag==1
          label = T.AgeGroup=='y';
      elseif ag==2
          label = T.AgeGroup=='m';
      elseif ag==3
          label = T.AgeGroup=='a';
      end

      dHT_delay = T.Correct_selectivity(label);
      dFA_delay = T.Incorrect_selectivity(label);

      thismean = mean(dHT_delay,1); thissem = nanstd(dHT_delay,1)./sqrt(size(dHT_delay,1));
      thismean2 = mean(dFA_delay,1); thissem2 = nanstd(dFA_delay,1)./sqrt(size(dFA_delay,1));

      e=errorbar([0 1]+2*ag-1, [thismean thismean2], [thissem thissem2],['-o'], 'Color',ag2color{ag}, 'LineWidth',1.5,'MarkerSize',2);hold on
      e.CapSize = 0;
      text(2*ag-0.8, 0.48, num2age{ag})
      if ag==3
        set(gca, 'XTickLabel',{'Correct','Incorrect','Correct','Incorrect', 'Correct','Incorrect'},'XTick',1:6);
        set(gca, 'TickDir', 'out');
        xlim([0 7]); ylim([-0.05,0.5])
        box off
        ylabel('dZ-scored dF/F (left vs. right)')
        title('Action selectivity of delay activity in correct and incorrect trials')
      end

  end
      

end



