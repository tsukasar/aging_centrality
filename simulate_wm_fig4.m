function [SIe, SIl,degree, W, R, P] = simulate_wm_fig4(ag,session, tau, noise_level)

num2age ={'Young','Middle','Advanced'};
fname = 'Simulated neurons';

if nargin ==2
  tau = 0.3; % time constant
  noise_level = 0.9;
elseif nargin ==3
  noise_level = 0.9;
end
l_ratio = .3; r_ratio = l_ratio; 


if ag==1
    w_factor =0.7;
    learning_rate = 0.001; 
    
elseif ag==2
    w_factor =0.4; 
    learning_rate = 0.0001; 
elseif ag==3
    w_factor =0.3;
    learning_rate = 0.00001;
end
Wbias = 0;
Wini = 1;


% Parameters
N = 100; % number of neurons
T_input = 0.5; % duration of input in seconds
T_delay = 2; % delay period in seconds
dt = 0.01; % time step in seconds
timesteps_input = T_input / dt;
timesteps_delay = T_delay / dt;
total_timesteps = timesteps_input + timesteps_delay;

epochs = 1000; % number of learning epochs
num_trials = 100; % number of trials for averaging

% Initialize weights and inputs
W = w_factor * randn(N, N) * Wini + Wbias*ones(N,N); % random recurrent weights
weight_noise_level = 0;
%  function
syfunc = @(x) tanh(x); 


%% Training with gradient descent
for epoch = 1:epochs
    random_binary = randi([0, 1]);

    if random_binary == 1
        input_left  = [ones(N*l_ratio,1);  zeros(N*(1-l_ratio),1)]+ randn(N, 1) * noise_level; % 'Left' input pattern
        target_left  = input_left;
        [W, ~] = learn_network(W, input_left, target_left, N, total_timesteps, timesteps_input, dt, tau, learning_rate, weight_noise_level,w_factor);
    else
        input_right = [zeros(N*(1-r_ratio),1); ones(N*r_ratio,1)] + randn(N, 1) * noise_level; % Random initial 'Right' input pattern
        target_right = input_right;
        [W, ~] = learn_network(W, input_right, target_right, N, total_timesteps, timesteps_input, dt, tau, learning_rate, weight_noise_level,w_factor);
    end
end

%% Simulate final network dynamics for 'Left' input
activity_left_trials = zeros(N, total_timesteps, num_trials);
activity_right_trials = zeros(N, total_timesteps, num_trials);
delay_activity_left = zeros(N, num_trials);
Edelay_activity_left = zeros(N, num_trials);
Ldelay_activity_left = zeros(N, num_trials);
delay_activity_right = zeros(N, num_trials);
Edelay_activity_right = zeros(N, num_trials);
Ldelay_activity_right = zeros(N, num_trials);

delay_period_start = timesteps_input + 1;
delay_period_end = total_timesteps;
delay_period_half = round((delay_period_start + delay_period_end)/2);

for trial = 1:num_trials
    % Initialize orthogonal input patterns
    input_left  = [ones(N*l_ratio,1);  zeros(N*(1-l_ratio),1)]+ randn(N, 1) * noise_level; % 'Left' input pattern
    input_right = [zeros(N*(1-r_ratio),1); ones(N*r_ratio,1)] + randn(N, 1) * noise_level; % Random initial 'Right' input pattern

    % Simulate network dynamics for 'Left' input
    activity_left = simulate_network(input_left, W, N, total_timesteps, timesteps_input, dt, tau);
    activity_left_trials(:, :, trial) = activity_left;
    delay_activity_left(:, trial) = mean(activity_left(:, delay_period_start:delay_period_end), 2);
    Edelay_activity_left(:, trial) = mean(activity_left(:, delay_period_start:delay_period_half), 2);
    Ldelay_activity_left(:, trial) = mean(activity_left(:, delay_period_half+1:delay_period_end), 2);

    % Simulate network dynamics for 'Right' input
    activity_right = simulate_network(input_right, W, N, total_timesteps, timesteps_input, dt, tau);
    activity_right_trials(:, :, trial) = activity_right;
    delay_activity_right(:, trial) = mean(activity_right(:, delay_period_start:delay_period_end), 2);
    Edelay_activity_right(:, trial) = mean(activity_right(:, delay_period_start:delay_period_half), 2);
    Ldelay_activity_right(:, trial) = mean(activity_right(:, delay_period_half+1:delay_period_end), 2);
end

%% Calculate average activities over trials
average_activity_left = mean(activity_left_trials, 3);
average_activity_right = mean(activity_right_trials, 3);

% Calculate mean activity during the sample period for the left trial
mean_activity_left = mean(average_activity_left(:, 1:timesteps_input), 2);

% Calculate mean activity during the sample period for the right trial
mean_activity_right = mean(average_activity_right(:, 1:timesteps_input), 2);

% Sort neurons based on mean activity during the sample period for the left trial
[~, sort_order_left] = sort(mean_activity_left, 'descend');

% Sort neurons based on mean activity during the sample period for the right trial
[~, sort_order_right] = sort(mean_activity_right, 'descend');

% Apply the sort order to both left and right trial activity matrices
activity_left_sorted_by_left = average_activity_left(sort_order_left, :);
activity_right_sorted_by_left = average_activity_right(sort_order_left, :);
activity_left_sorted_by_right = average_activity_left(sort_order_right, :);
activity_right_sorted_by_right = average_activity_right(sort_order_right, :);


%% Calculate SI for each neuron
SI = zeros(N, 1); SIe = zeros(N, 1); SIl = zeros(N, 1);
for neuron = 1:N
    % Concatenate left and right delay activities for the current neuron
    Edelay_activity_neuron = [Edelay_activity_left(neuron, :), Edelay_activity_right(neuron, :)];
    Ldelay_activity_neuron = [Ldelay_activity_left(neuron, :), Ldelay_activity_right(neuron, :)];

    labels = [ones(1, num_trials), zeros(1, num_trials)]; % 1 for 'Left', 0 for 'Right'
    
    % Calculate ROC curve and AUC using perfcurve
    [~, ~, ~, AUCe] = perfcurve(labels, Edelay_activity_neuron, 1);
    SIe(neuron) = 2 * (AUCe - 0.5);

    % Calculate ROC curve and AUC using perfcurve
    [~, ~, ~, AUCl] = perfcurve(labels, Ldelay_activity_neuron, 1);
    SIl(neuron) = 2 * (AUCl - 0.5);
end

% Plot the selectivity index (SI) for each neuron
figure;

tmp = W;
tmp(tmp<0)=0; 
tmp(isnan(tmp))=0;
tmp(logical(eye(size(tmp))))=0;
degree  = strengths_und(tmp);


     x1 = degree';
     y1 = (abs(SIe)+abs(SIl))/2; 
     mdl = fitlm(x1,y1);
            e = mdl.Coefficients.Estimate;
            [top_int, bot_int,xvals] = regression_line_ci(0.05,e,x1,y1);
            h2 = patch([xvals fliplr(xvals)],[bot_int fliplr(top_int)],[.9 .9 .9]);hold on
            set(h2,'EdgeColor','none');hold on
        
            [R, P] = corr(x1,y1, 'rows','complete','type','Pearson');
            [coeff,stats] = polyfit(x1,y1,1);
            [yfit,ci] = polyval(coeff,x1,stats);
            plot(x1,yfit,'k'); hold on

            scatter(x1,y1,20,'bo');hold on
            title(sprintf('R%s, P%s',num2str(R),num2str(P)))
            ylabel('|SI|avg'); xlabel('degree')
            axis square
            box off
            set(gca, 'TickDir', 'out');
           
   sgtitle([num2age{ag} ' session' num2str(session)])
   print(gcf,'-dpsc',fname,'-bestfit','-append')    

   close
    


%% Visualization
figure;

% Plot for 'Left' input sorted by left sample activity
subplot(2, 2, 1);
imagesc(activity_left_sorted_by_left);
xlabel('Time step');
ylabel('Neurons sorted by left');
title('Left trials');
colorbar;
hold on;
plot([timesteps_input, timesteps_input], ylim, 'r--', 'LineWidth', 2); % Vertical line to indicate delay period start
hold off;
time_axis = linspace(0, T_input + T_delay, total_timesteps);
set(gca, 'XTick', linspace(1, total_timesteps, 10), 'XTickLabel', round(linspace(0, T_input + T_delay, 10), 2));

% Plot for 'Right' input sorted by left sample activity
subplot(2, 2, 2);
imagesc(activity_right_sorted_by_left);
xlabel('Time step');
ylabel('Neurons sorted by left');
title('Right trials');
colorbar;
hold on;
plot([timesteps_input, timesteps_input], ylim, 'r--', 'LineWidth', 2); % Vertical line to indicate delay period start
hold off;
set(gca, 'XTick', linspace(1, total_timesteps, 10), 'XTickLabel', round(linspace(0, T_input + T_delay, 10), 2));

% Plot for 'Left' input sorted by right sample activity
subplot(2, 2, 3);
imagesc(activity_left_sorted_by_right);
xlabel('Time step');
ylabel('Neurons sorted by right');
title('Left trials');
colorbar;
hold on;
plot([timesteps_input, timesteps_input], ylim, 'r--', 'LineWidth', 2); % Vertical line to indicate delay period start
hold off;
set(gca, 'XTick', linspace(1, total_timesteps, 10), 'XTickLabel', round(linspace(0, T_input + T_delay, 10), 2));

% Plot for 'Right' input sorted by right sample activity
subplot(2, 2, 4);
imagesc(activity_right_sorted_by_right);
xlabel('Time step');
ylabel('Neurons sorted by right');
title('Right trials');
colorbar;
hold on;
plot([timesteps_input, timesteps_input], ylim, 'r--', 'LineWidth', 2); % Vertical line to indicate delay period start
hold off;
set(gca, 'XTick', linspace(1, total_timesteps, 10), 'XTickLabel', round(linspace(0, T_input + T_delay, 10), 2));
sgtitle([num2age{ag} ' session' num2str(session)])
   print(gcf,'-dpsc',fname,'-bestfit','-append')    
close

% Plot weight matrix
tmp = W;
tmp(tmp<0)=0; 
tmp(isnan(tmp))=0;
tmp(logical(eye(size(tmp))))=0;

figure;
imagesc(1:N,1:N,tmp); colormap(flipud(gray)); colorbar %colormap  gray; colorbar;%jet; hot  caxis([0 .5]); 
            axis square
            set(gca, 'TickDir', 'out');
            xlabel('Neurons')

ylabel('Neurons');
colorbar;
sgtitle([num2age{ag} ' session' num2str(session) ' Weight matrix'])
   print(gcf,'-dpsc',fname,'-bestfit','-append')    
close



%% Function to simulate network dynamics and apply learning rule with sigmoid activation
    function [W, activity] = learn_network(W, input_pattern, target_pattern, N, total_timesteps, timesteps_input, dt, tau, learning_rate, weight_noise_level, w_factor)
    activity = zeros(N, total_timesteps);
    input_signal = zeros(N, total_timesteps);
    input_signal(:, 1:timesteps_input) = repmat(input_pattern, 1, timesteps_input);
    for t = 2:total_timesteps
        if t <= timesteps_input
            input_current = input_signal(:, t);
        else
            input_current = zeros(N, 1);
        end
        activity(:, t) = activity(:, t-1) + (dt/tau) * (-activity(:, t-1) + syfunc(W * (activity(:, t-1)) + input_current) );

        % Apply gradient descent learning rule
        if t == total_timesteps
            err = activity(:, t) - target_pattern; % error at the end of delay period
            dW = -learning_rate * (err * (activity(:, t-1))'); % weight update
            % Add noise to weight updates
            dW = dW + weight_noise_level * randn(size(dW));
            W = W + dW;
            
            % Normalize weights to ensure stability
            W = w_factor* W / max(abs(W(:)));
        end
    end
end


%% Function to simulate network dynamics without learning with sigmoid activation
function activity = simulate_network(input_pattern, W, N, total_timesteps, timesteps_input, dt, tau)
    activity = zeros(N, total_timesteps);
    input_signal = zeros(N, total_timesteps);
    input_signal(:, 1:timesteps_input) = repmat(input_pattern, 1, timesteps_input);
    for t = 2:total_timesteps
        if t <= timesteps_input
            input_current = input_signal(:, t);
        else
            input_current = zeros(N, 1);
        end
        activity(:, t) = activity(:, t-1) + (dt/tau) * (-activity(:, t-1) + syfunc(W * (activity(:, t-1)) + input_current) );
    end
end


end
