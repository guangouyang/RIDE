



%load the sample data (/w RT) for a single subject from a face recognition task
for sec_load_data = 1:1
%if you don't want to open the data manually you can use this script;
% load('xxx\RIDE_call\example\samp_face.mat');
end



%configuration of parameters and run RIDE

for section = 1:1

cfg = [];%initialization
cfg.samp_interval = 2;
cfg.epoch_twd = [-100,1000];%time window for the epoched data (relative to stimulus)
cfg.comp.name = {'s','c','r'};%component names
cfg.comp.twd = {[0,500],[100,900],[-300,300]}; %time windows for extracting components, for 's' and 'c' it is raltive to stimulus, for 'r' it is relative to RT
cfg.comp.latency = {0,'unknown',rt};%latency for each RIDE component



cfg = RIDE_cfg(cfg);%standardize 

results = RIDE_call(data,cfg); %run RIDE

end




%Plot the time courses of RIDE results
for section = 1:1

chan_index  = find(strcmpi({chanlocs.labels},'Pz'));%select which channel to plot


%plot erp and RIDE components superimposed together
figure;RIDE_plot(results,{'erp','s','c','r'},chan_index);

%you can also plot some of them:
figure;RIDE_plot(results,{'erp','s','c'},chan_index);

%or plot the ERP and reconstructed ERP superimposed

figure;RIDE_plot(results,{'erp','erp_new'},chan_index);


%if R component is plotted with others, the waveform is located at the
%median RT, the time axis shows values relative to stimulus
%if R component is plotted with only itself, the time axis shows values
%relative to RT, in this case, 0 means the response time
figure;RIDE_plot(results,{'r'},chan_index);

end



%Plot all the time courses for all electrodes together
for section = 1:1

    %set the time axis first
    t_axis = linspace(cfg.epoch_twd(1),cfg.epoch_twd(2),size(data,1));
    
    %plot ERP
    figure;plot(t_axis, results.erp);    axis tight;xlabel('time after stimulus (ms)');ylabel('potential (\muV)');
    %you can simply change ERP to S
    figure;plot(t_axis, results.s);    axis tight;xlabel('time after stimulus (ms)');ylabel('potential (\muV)');
    
    %if you want to plot R relative to reaction time
    %set the time axis first
    t_axis = linspace(cfg.epoch_twd(1),cfg.epoch_twd(2),size(data,1)) - mean(rt);
    figure;plot(t_axis, results.r);    axis tight;xlabel('time after stimulus (ms)');ylabel('potential (\muV)');

end


%plot the topographies

for section = 1:1
t = 500;%the time point to plot, in millisecond

t1 = round((t-cfg.epoch_twd(1))/cfg.samp_interval);%covert t to sampling point

c_range = [-15,15];%specify the color range
figure;subplot(1,4,1);topoplot(results.erp(t1,:),chanlocs);text(0,1,'erp');caxis(c_range);
subplot(1,4,2);topoplot(results.s(t1,:),chanlocs);text(0,1,'s');caxis(c_range);
subplot(1,4,3);topoplot(results.c(t1,:),chanlocs);text(0,1,'c');caxis(c_range);
subplot(1,4,4);topoplot(results.r(t1,:),chanlocs);text(0,1,'r');caxis(c_range);
end

%plot the topography evolution
for section = 1:1
    twd = [100,900];%the time window to be plotted
    n = 10; %how many topos to be shown
    comp = {'erp','s','c','r'};
    
    c_range = [-15,15];%specify the color range

    
    temp = [];twd_s = round((twd-cfg.epoch_twd(1))/cfg.samp_interval);%convert the sampling point
    for j = 1:length(comp)
        eval(['temp{j} = results.',comp{j},'(twd_s(1):twd_s(2),:);']);
    end
    t_points = round(linspace(twd(1),twd(2),n));
    figure;topos_scr(temp,t_points,comp,chanlocs,'maplimits',c_range);
        
    
end



%plot the latency of c versus latency of r

for section = 1:1
    figure;plot(results.latency_c*cfg.samp_interval,results.latency_r*cfg.samp_interval,'.');
    xlabel('single trial latency of C (ms)');
    ylabel('single trial RT (ms)');
    
    title(['the correlation is ',num2str(corr(results.latency_c(:),results.latency_r(:)))]);
end
    


%plot the single trial ERP or RIDE component

for section = 1:1
    
    %plot single trial ERP
    chan_index = find(strcmpi({chanlocs.labels},'Pz'));
    
    t_axis = linspace(cfg.epoch_twd(1),cfg.epoch_twd(2),size(data,1));%time axis;
    
    temp = single_trial_RIDE(data,results,'erp',chan_index);
    figure;imagesc(t_axis,1:size(data,3),temp');
    xlabel('time after stimulus (ms)');
    ylabel('trial index');
    
    %plot single trial S
    chan_index = find(strcmpi({chanlocs.labels},'O1'));
    
    t_axis = linspace(cfg.epoch_twd(1),cfg.epoch_twd(2),size(data,1));%time axis;
    
    temp = single_trial_RIDE(data,results,'s',chan_index);
    figure;imagesc(t_axis,1:size(data,3),temp');xlabel('time after stimulus (ms)');ylabel('trial index');
    
    %sort by the accending order of amplitude
    figure;imagesc(t_axis,1:size(data,3),temp(:,accending_index(results.amp_s(:,chan_index)))');
    xlabel('time after stimulus (ms)');ylabel('trial index');
    
    
    %plot single trial C
    chan_index = find(strcmpi({chanlocs.labels},'Pz'));
    
    t_axis = linspace(cfg.epoch_twd(1),cfg.epoch_twd(2),size(data,1));%time axis;
    
    temp = single_trial_RIDE(data,results,'c',chan_index);
    figure;imagesc(t_axis,1:size(data,3),temp');xlabel('time after stimulus (ms)');ylabel('trial index');
    
    %sort by the accending order of C latency
    figure;imagesc(t_axis,1:size(data,3),temp(:,accending_index(results.latency_c))');
    xlabel('time after stimulus (ms)');ylabel('trial index');
    
    
    
end


%you can play with other separation scheme, for example, only separate S
%and R:
for section = 1:1
    cfg = [];%initialization
    cfg.samp_interval = 2;
    cfg.epoch_twd = [-100,1000];
    cfg.comp.name = {'s','r'};
    cfg.comp.twd = {[0,500],[-300,300]};
    cfg.comp.latency = {0,rt};


    cfg.re_samp = 8;


    cfg = RIDE_cfg(cfg);

    results = RIDE_call(data,cfg);

end



%finally apply RIDE to all subjects and all conditions and then do the statistics