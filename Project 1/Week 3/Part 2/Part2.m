J1 = 100;
B1 = 1;
J2 = 1;
B2 = 1;
A = [1, 100];

%Option 1%
k = [10, 100, 1000];

% Fixed Step %
dT = [0.1, 1];
solver = ["ode1", "ode4"];

figIndex= 1;

% Initialize CPU time storage
cpuTimesOption1 = []; % For storing CPU times of Option 1 simulations
cpuTimesOption2 = []; % For storing CPU times of Option 2 simulations

%-------------------------------Option 1----------------------------------%

for dT_index = 1:2
    for solver_index = 1:2
        for A_index = 1:2
            for k_index = 1:3

                currentdT = dT(dT_index);
                currentSolver = solver(solver_index);
                a = A(A_index);
                K = k(k_index);

                % Start timing this simulation
                tic;
                simout = sim('Option1.slx', 'Solver', currentSolver, 'FixedStep', string(currentdT));
                % End timing and store the CPU time
                cpuTimesOption1(end+1) = toc;

                W = simout.get('w').signals.values;
                T = simout.get('tout');

                figure(figIndex);
                plot(T, W);
                titleStr = sprintf('Option 1 | Shaft Speed vs Time\nA=%s, Solver=%s,\nk=%s, dT=%s', ...
                           num2str(a), currentSolver, num2str(K), num2str(currentdT));
                title(titleStr, 'FontSize', 10);
                xlabel('Time (s)');
                ylabel('Shaft Speed (rad/s)')
                grid on;

                figIndex = figIndex + 1;

            end
        end
    end
end

currentSolver = 'ode45';

for A_index = 1:2
    for k_index = 1:3

        a = A(A_index);
        K = k(k_index);
        
        % Start timing this simulation
        tic;
        simout = sim('Option1_Variable.slx', 'Solver', currentSolver);
        % End timing and store the CPU time
        cpuTimesOption1(end+1) = toc;

        W = simout.get('w').signals.values;
        T = simout.get('tout');

        figure(figIndex);
        plot(T, W);
        titleStr = sprintf('Option 1 | Shaft Speed vs Time\nA=%s, Solver=%s,\nk=%s', ...
               num2str(a), currentSolver, num2str(K));
        title(titleStr, 'FontSize', 10);
        xlabel('Time (s)');
        ylabel('Shaft Speed (rad/s)')
        grid on;

        figIndex = figIndex + 1;

    end
end

%-------------------------------Option 1----------------------------------%

%-------------------------------Option 2----------------------------------%

Bc = B1 + B2;
Jc = J1 + J2;

for dT_index = 1:2
    for solver_index = 1:2
        for A_index = 1:2

            currentdT = dT(dT_index);
            currentSolver = solver(solver_index);
            a = A(A_index);
            
            % Start timing this simulation
            tic;
            simout = sim('Option2.slx', 'Solver', currentSolver, 'FixedStep', string(currentdT));
            % End timing and store the CPU time
            cpuTimesOption2(end+1) = toc;

            W = simout.get('w').signals.values;
            T = simout.get('tout');

            figure(figIndex);
            plot(T, W);
            titleStr = sprintf('Option 2 | Shaft Speed vs Time\nA=%s, Solver=%s, dT=%s', ...
                       num2str(a), currentSolver, num2str(currentdT));
            title(titleStr, 'FontSize', 10);
            xlabel('Time (s)');
            ylabel('Shaft Speed (rad/s)')
            grid on;

            figIndex = figIndex + 1;

        end
    end
end

currentSolver = 'ode45';

for A_index = 1:2

    a = A(A_index);
    
    % Start timing this simulation
    tic;
    simout = sim('Option2_Variable.slx', 'Solver', currentSolver);
    % End timing and store the CPU time
    cpuTimesOption2(end+1) = toc;

    W = simout.get('w').signals.values;
    T = simout.get('tout');

    figure(figIndex);
    plot(T, W);
    titleStr = sprintf('Option 2 | Shaft Speed vs Time\nA=%s, Solver=%s,', ...
           num2str(a), currentSolver);
    title(titleStr, 'FontSize', 10);
    xlabel('Time (s)');
    ylabel('Shaft Speed (rad/s)')
    grid on;

    figIndex = figIndex + 1;

end

%-------------------------------Option 2----------------------------------%

% Display CPU times for Option 1 and Option 2
disp('CPU Times for Option 1 simulations:');
disp(cpuTimesOption1);

disp('CPU Times for Option 2 simulations:');
disp(cpuTimesOption2);
