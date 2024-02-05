% Define the parameter sets
w_0_values = [10, 0];
J_values = [100, 0.01];
A_values = [0, 100];
b_values = [10, 0.1];
freq_values = [0.1, 100];
fixed_step_solvers = {'ode1', 'ode4'};
variable_step_solvers = {'ode45', 'ode23tb'};
time_steps = [0.001, 0.1, 1];
simTime = 25;

% Load the model
modelName = 'P1_pt1_2_Variable';
load_system(modelName);

% Define output structure for results
results = struct();

% Main simulation loop
for w_0 = w_0_values
    for J = J_values
        for A = A_values
            for b = b_values
                for freq = freq_values
                    for ts = time_steps
                        for solver = fixed_step_solvers
                            % Set parameters
                            set_param(modelName, 'Solver', solver, 'FixedStep', num2str(ts), 'StopTime', num2str(simTime));

                            % Set initial conditions and parameters
                            assignin('base', 'J', J);
                            assignin('base', 'b', b);
                            assignin('base', 'A', A);
                            % ... other parameters

                            % Start measuring CPU time
                            tic;

                            % Run the simulation
                            simOut = sim(modelName);

                            % Stop measuring CPU time
                            cpuTime = toc;

                            % Extract simulation results
                            t = simOut.tout;
                            w = simOut.get('w');
                            w_dot = simOut.get('w_dot');

                            % Calculate maximum error
                            % ... error calculation logic here

                            % Store results
                            resultKey = sprintf('w0_%d_J_%g_A_%g_b_%g_freq_%g_ts_%g_solver_%s', w_0, J, A, b, freq, ts, solver);
                            results.(resultKey) = struct('t', t, 'w', w, 'w_dot', w_dot, 'cpuTime', cpuTime);

                            % Plotting logic here
                            % ... plotting logic
                        end
                    end
                    for solver = variable_step_solvers
                        % Set variable-step solver parameters
                        % ... same as above, without FixedStep
                    end
                end
            end
        end
    end
end

% Close the model without saving
close_system(modelName, 0);
