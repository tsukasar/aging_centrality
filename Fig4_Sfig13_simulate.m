function Fig4_Sfig13_simulate

rootdir = 'C:\aging_centrality\';
cd(rootdir)

num2age ={'Young','Middle','Advanced'};
num2agef = {'.yg','.a','.aa'};
age2color = {[0 0 0],[1 0 1],[1 0 0]};
w=[1 1 1];
pts = 0:0.01:1;

tfname = 'fig4_SI_graph_simulate.mat';

if isempty(ls(tfname))

SI.dg.yg=[];SI.dg.a=[];SI.dg.aa=[];
D.yg = []; D.a = []; D.aa = [];
D.fit.yg =[]; D.fit.a =[]; D.fit.aa =[];
D.Corr.yg = [];D.Corr.a = [];D.Corr.aa = [];

for ag=1:numel(num2age)
  num2age{ag}
    
  for s=1:20
    disp(['session#' num2str(s)])
    [SIe, SIl,degree, W, R, P] = simulate_wm_fig4(ag,s);
    degree_upper = degree>=median(degree);
    degree_lower = degree<median(degree);
    
    tmp = W;
    tmp(tmp<0)=0; 
    tmp(isnan(tmp))=0;
    tmp(logical(eye(size(tmp))))=0;

    max_degree = size(tmp,1)-1;
    norm_degree = degree'/max_degree;
    [f,xi] = ksdensity(norm_degree,pts,'BoundaryCorrection','reflection','Bandwidth',0.05);
    f = f / sum(f);

    SI_index = [(abs(SIe)+abs(SIl))/2  SIe.*SIl];
    SI_degree = [mean(SI_index(degree_lower,1),1)  mean(SI_index(degree_upper,1),1)      mean(SI_index(degree_lower,2),1)  mean(SI_index(degree_upper,2),1)  ];


    if ag==1
         SI.dg.yg = [SI.dg.yg; SI_degree];
         D.yg   = [D.yg ;  norm_degree];
         D.fit.yg = [D.fit.yg; f];
         D.Corr.yg = [D.Corr.yg; [R P]];
    elseif ag==2
         SI.dg.a  = [SI.dg.a;  SI_degree];
         D.a   = [D.a ;  norm_degree];
         D.fit.a = [D.fit.a; f];
         D.Corr.a = [D.Corr.a; [R P]];
    elseif ag==3
         SI.dg.aa = [SI.dg.aa; SI_degree];
         D.aa   = [D.aa ;  norm_degree];
         D.fit.aa = [D.fit.aa; f];
         D.Corr.aa = [D.Corr.aa; [R P]];
    end
  end

end

cd(rootdir)
save(tfname, 'SI','D')

end

cd(rootdir)
load(tfname)


 %% Comparision High DC vs. Low DC
   figure(	...  
                'Position',			[0 100 1450 1000],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10], ...
                'PaperSize',        [11 8.5] ...
      );hold on
    
   for ag=1:3
       if ag==1     
           SI_degree = SI.dg.yg;     
       elseif ag==2
           SI_degree = SI.dg.a;
       elseif ag==3
           SI_degree = SI.dg.aa;
       end
       tmp = SI_degree; %SI_index:  1.|SIe|(low) 2.|SIe|(high)   3.|SIl|(low) 4.|SIl|(high)   5.%Sig SIe&SIl(low) 6.%Sig SIe&SIl(high)  7.SIexSIl(low) 8.SIexSIl(high)  

      %SI
      subplot(2,3,ag)
       value = SI_degree(:,1:2);  
       plot(1:2,value,'color',[.5 .5 .5]);hold on
       thismean = mean(value,1); thissem = std(value,1)./sqrt(size(value,1)-1);
       e=errorbar(1:2, thismean, thissem, ['-o'], 'Color', age2color{ag}, 'LineWidth',2,'MarkerSize',3);hold on
       e.CapSize = 0;
       
       set(gca, 'XTickLabel',{'Low DC', 'High DC'},'XTick',1:2);
       set(gca, 'TickDir', 'out');
       xlim([0 3]); ylim([0,0.7])
       box off
       ylabel('|SI|avg')
       title([num2age{ag}])


      %Sustained index (SIe x SIl)
      subplot(2,3,3+ag)
       value = SI_degree(:,3:4);  
       plot(1:2,value,'color',[.5 .5 .5]);hold on
       thismean = mean(value,1); thissem = std(value,1)./sqrt(size(value,1)-1);
       e=errorbar(1:2, thismean, thissem, ['-o'], 'Color', age2color{ag}, 'LineWidth',2,'MarkerSize',3);hold on
       e.CapSize = 0;
       
       set(gca, 'XTickLabel',{'Low DC', 'High DC'},'XTick',1:2);
       set(gca, 'TickDir', 'out');
       xlim([0 3]); ylim([-0.1,0.5])
       box off
       ylabel('Sustained index')      
   end
       
  
   %% d(high-low)
   figure(	...  
                'Position',			[0 100 1450 1000],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10], ...
                'PaperSize',        [11 8.5] ...
      );hold on
    
      SI_degree1 = SI.dg.yg;
      SI_degree2 = SI.dg.a;
      SI_degree3 = SI.dg.aa;

      %SI
      subplot(1,2,1)
       value1 = SI_degree1(:,1:2);   %averaging early and late
       dvalue1= value1(:,2)-value1(:,1);

       value2 = SI_degree2(:,1:2);   %averaging early and late
       dvalue2= value2(:,2)-value2(:,1);

       value3 = SI_degree3(:,1:2);   %averaging early and late
       dvalue3= value3(:,2)-value3(:,1);

       scatter(zeros(size(dvalue1))+1,dvalue1,'k.');hold on
       scatter(zeros(size(dvalue2))+2,dvalue2,'m.');hold on
       scatter(zeros(size(dvalue3))+3,dvalue3,'r.');hold on

       thismean1 = mean(dvalue1,1);
       b1 = bar(1,thismean1,'FaceColor','none','EdgeColor','k','LineWidth',1);hold on
       
       thismean2 = mean(dvalue2,1);
       b2 = bar(2,thismean2,'FaceColor','none','EdgeColor','k','LineWidth',1);hold on
     
       thismean3 = mean(dvalue3,1);
       b3 = bar(3,thismean3,'FaceColor','none','EdgeColor','k','LineWidth',1);hold on
       
       set(gca, 'XTickLabel',num2age,'XTick',1:3, 'TickDir', 'out');
       xlim([0 4]); ylim([-0.1,0.2])
       axis square
       box off
       ylabel('d|SI|avg')
       title('d|SI|avg')


      %Sustained index (SIe x SIl)
      subplot(1,2,2)
       value1 = SI_degree1(:,3:4);
       dvalue1= value1(:,2)-value1(:,1);

       value2 = SI_degree2(:,3:4);
       dvalue2= value2(:,2)-value2(:,1);

       value3 = SI_degree3(:,3:4);
       dvalue3= value3(:,2)-value3(:,1);

       scatter(zeros(size(dvalue1))+1,dvalue1,'k.');hold on
       scatter(zeros(size(dvalue2))+2,dvalue2,'m.');hold on
       scatter(zeros(size(dvalue3))+3,dvalue3,'r.');hold on

       thismean1 = median(dvalue1,1);
       b1 = bar(1,thismean1,'FaceColor','none','EdgeColor','k','LineWidth',1);hold on
      
       thismean2 = median(dvalue2,1);
       b2 = bar(2,thismean2,'FaceColor','none','EdgeColor','k','LineWidth',1);hold on
       
       thismean3 = median(dvalue3,1);
       b3 = bar(3,thismean3,'FaceColor','none','EdgeColor','k','LineWidth',1);hold on
      
       set(gca, 'XTickLabel',num2age,'XTick',1:3, 'TickDir', 'out');
       xlim([0 4]); ylim([-0.1,0.15])
       axis square
       box off
       ylabel('d(sustained index)')
       title('d(SI early x SI late)')


%% variance of DC
for ag=1:3
    eval(sprintf('group%s = D%s;',num2str(ag),num2agef{ag}) ); 
end

%% plot fitted degree distribution 
figure(	...  
                'Position',			[0 100 1450 1000],	...
                'PaperOrientation', 'landscape', ...
	            'PaperUnit',		'inches',	...
                'PaperPosition',   [0 3 11 10], ...
                'PaperSize',        [11 8.5] ...
      );hold on

for ag=1:3
    subplot(1,4,ag)
    stmp = ['D.Corr' num2agef{ag}];
    stmp = eval(stmp);

    r1 = stmp(:,1);      
    p1 = stmp(:,2); 
    r1s = r1(p1<0.05);
    histogram(r1, 'BinWidth',0.05, 'BinLimits', [-0.6 0.6], 'FaceColor','w','FaceAlpha',0.1,'EdgeColor','k');hold on
    histogram(r1s,'BinWidth',0.05, 'BinLimits', [-0.6 0.6], 'FaceColor','r','FaceAlpha',0.1,'EdgeColor','r');hold on
    line([median(r1) median(r1)], [0 6],'Color','b' )
    line([0 0], [0 6],'Color','k' )

    xlabel('Correlation DC vs.|SI|avg')
    ylabel('# of sessions')
    title(num2age{ag})
    axis square;box off
    set(gca, 'TickDir', 'out');
end


%Degree distribution
subplot(1,4,ag+1)

for ag=3:-1:1
        stmp = ['D.fit'   num2agef{ag}];
        tmp = eval(stmp);
        dcolor = age2color{ag};
        errorshade(pts,nanmean(tmp,1),nanstd(tmp)./sqrt(size(tmp,1)), dcolor, dcolor+(w-dcolor)*.7); hold on
end

for ag=3:-1:1
        stmp = ['D.fit'   num2agef{ag}];
        tmp = eval(stmp);
        dcolor = age2color{ag};
        plot(pts,nanmean(tmp,1), 'Color',dcolor,'Linewidth',2); hold on

        tmpg = eval(sprintf('group%s;',num2str(ag)) ); 
        line([mean(tmpg)-std(tmpg) mean(tmpg)+std(tmpg)],-0.01*(ag-1)+[0.1 0.1], 'Color',dcolor,'Linewidth',2);hold on
        plot(mean(tmpg),0.1-0.01*(ag-1), 'o','Color',dcolor); hold on
end

xlim([0 0.4])
xlabel('Normalized degree')
ylabel('Frequency')
set(gca, 'TickDir', 'out');
axis square; box off 
