
    samp_interval = 2;twd = [-100,1000];
    t = linspace(twd(1),twd(2),550); 
    chan_index = find(strcmp('Pz',{chanlocs.labels}));
    c = [-6,20];w=100;
    twd0 = [351,550];twd1=twd0;
    twd1 = fix((twd1-twd(1))/samp_interval);twd1 = twd1(1):twd1(2);
    
    figure;subplot(1,2,1);
    plot(t,mean(erp_pu(:,chan_index,:),3),'k');
    axis([t(1),t(end),c(1),c(end)]);
    hold on;imagesc(linspace(twd0(1),twd0(2),w),linspace(c(1),c(2),w),zeros(w,w));alpha(0.4);
    hold on;plot(t,mean(erp_uu(:,chan_index,:),3),'r');title('original ERP');
    [p1,p2,p3,p4] = ttest(mean(erp_pu(twd1,chan_index,:)),mean(erp_uu(twd1,chan_index,:)));
    text(100,-2,{['t=',num2str(p4.tstat)];['p=',num2str(p2)]});
    
    
    subplot(1,2,2);plot(t,mean(erp_new_pu(:,chan_index,:),3),'k');axis([t(1),t(end),c(1),c(end)]);
    hold on;plot(t,mean(erp_new_uu(:,chan_index,:),3),'r');title('reconstructed ERP');
    hold on;imagesc(linspace(twd0(1),twd0(2),w),linspace(c(1),c(2),w),zeros(w,w));alpha(0.4);
    [p1,p2,p3,p4] = ttest(mean(erp_new_pu(twd1,chan_index,:)),mean(erp_new_uu(twd1,chan_index,:)));
    text(100,-2,{['t=',num2str(p4.tstat)];['p=',num2str(p2)]});
    
    legend({'primed','unprimed'});