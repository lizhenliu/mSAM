%#ok<*SAGROW>
superclear
warning('off', 'MATLAB:legend:PlotEmpty');
warning('off', 'MATLAB:legend:IgnoringExtraEntries');

%% Overall experiment settings
settings.numExps = 1; % i.e. number of problems generated
settings.nMaxIterations = [];
settings.nStableIterations = 100;
settings.nagents = 10;
settings.ncolors = 3;
settings.visualizeProgress = true;
% settings.makeRandomConstraintCosts = true;

%% Create the experiment options
options.ncolors = uint16(settings.ncolors);
options.constraint.type = 'nl.coenvl.sam.constraints.InequalityConstraint';
% options.constraint.arguments = {1};
% options.constraint.type = 'nl.coenvl.sam.constraints.CostMatrixConstraint';
% options.constraint.arguments = {[[1 0 3];[3 1 0];[0 3 1]], [[1 0 3];[3 1 0];[0 3 1]]};
% options.constraint.type = 'nl.coenvl.sam.constraints.SemiRandomConstraint';
% options.constraint.type = 'nl.coenvl.sam.constraints.RandomConstraint';
% 
% options.graphType = @scalefreeGraph;
% options.graph.maxLinks = uint16(4);
% options.graph.initialsize = uint16(10);

% options.graphType = @randomGraph;
% options.graph.density = 0.1;

options.graphType = @delaunayGraph;
options.graph.sampleMethod = 'poisson';

% options.graphType = @nGridGraph;
% options.graph.nDims = uint16(3);
% options.graph.doWrap = '';

options.graph.nAgents = uint16(settings.nagents);

options.nStableIterations = uint16(settings.nStableIterations);
options.nMaxIterations = uint16(settings.nMaxIterations);
options.maxTime = 180;
options.waitTime = .01;

solvers = {};

% solvers(end+1).name = 'CoCoA_simple';
% solvers(end).initSolverType = 'nl.coenvl.sam.solvers.CoCoSolver';
% solvers(end).iterSolverType = '';
% 
% solvers(end+1).name = 'CoCoA';
% solvers(end).initSolverType = 'nl.coenvl.sam.solvers.CoCoASolver';
% solvers(end).iterSolverType = '';
% 
% solvers(end+1).name = 'ACLS';
% solvers(end).initSolverType = '';
% solvers(end).iterSolverType = 'nl.coenvl.sam.solvers.ACLSSolver';
% 
% solvers(end+1).name = 'CoCoA - ACLS';
% solvers(end).initSolverType = 'nl.coenvl.sam.solvers.CoCoASolver';
% solvers(end).iterSolverType = 'nl.coenvl.sam.solvers.ACLSSolver';
% 
% solvers(end+1).name = 'CoCoA - ACLSUB';
% solvers(end).initSolverType = 'nl.coenvl.sam.solvers.CoCoASolver';
% solvers(end).iterSolverType = 'nl.coenvl.sam.solvers.ACLSUBSolver';

% solvers(end+1).name = 'DSA';
% solvers(end).initSolverType = '';
% solvers(end).iterSolverType = 'nl.coenvl.sam.solvers.DSASolver';

% solvers(end+1).name = 'CoCoA - DSA';
% solvers(end).initSolverType = 'nl.coenvl.sam.solvers.CoCoASolver';
% solvers(end).iterSolverType = 'nl.coenvl.sam.solvers.DSASolver';

% solvers(end+1).name = 'MCSMGM';
% solvers(end).initSolverType = '';
% solvers(end).iterSolverType = 'nl.coenvl.sam.solvers.MCSMGMSolver';
% 
% solvers(end+1).name = 'CoCoA - MCSMGM';
% solvers(end).initSolverType = 'nl.coenvl.sam.solvers.CoCoASolver';
% solvers(end).iterSolverType = 'nl.coenvl.sam.solvers.MCSMGMSolver';

solvers(end+1).name = 'MGM2';
solvers(end).initSolverType = '';
solvers(end).iterSolverType = 'nl.coenvl.sam.solvers.MGM2Solver';


solvers(end+1).name = 'ACLS_MGM2';
solvers(end).initSolverType = 'nl.coenvl.sam.solvers.ACLSSolver';
solvers(end).iterSolverType = 'nl.coenvl.sam.solvers.MGM2Solver';


% solvers(end+1).name = 'CoCoA - MGM2';
% solvers(end).initSolverType = 'nl.coenvl.sam.solvers.CoCoASolver';
% solvers(end).iterSolverType = 'nl.coenvl.sam.solvers.MGM2Solver';

% solvers(end+1).name = 'Max-Sum_ADVP';
% solvers(end).initSolverType = '';
% solvers(end).iterSolverType = 'nl.coenvl.sam.solvers.MaxSumADVPVariableSolver';
% 
% solvers(end+1).name = 'CoCoA - Max-Sum_ADVP';
% solvers(end).initSolverType = 'nl.coenvl.sam.solvers.CoCoASolver';
% solvers(end).iterSolverType = 'nl.coenvl.sam.solvers.MaxSumADVPVariableSolver';


%%
C = strsplit(options.constraint.type, '.');
expname = sprintf('exp_%s_%s_i%d_d%d_n%d_t%s', C{end}, func2str(options.graphType), settings.numExps, options.ncolors, settings.nagents, datestr(now,30));

% Do the experiment
clear handles;
for e = 1:settings.numExps
    edges = feval(options.graphType, options.graph);
    
    if isfield(settings, 'makeRandomConstraintCosts') && settings.makeRandomConstraintCosts
        constraintCosts = randi(10, options.ncolors, options.ncolors, numel(edges));
        options.constraint.arguments = arrayfun(@(x) constraintCosts(:,:,x), 1:numel(edges), 'UniformOutput', false);
    else
        options.constraint.arguments = {};
    end
    
    for a = 1:numel(solvers)
        solvername = solvers(a).name;
        options.initSolverType = solvers(a).initSolverType;
        options.iterSolverType = solvers(a).iterSolverType;

%         try
            fprintf('Performing experiment with %s (%d/%d)\n', solvername, e, settings.numExps);
            exp = doMultiSolverExperiment(edges, options);
            fprintf('Finished in t = %0.1f seconds\n', exp.time);
%         catch err
%             warning('Timeout or error occured:');
%             disp(err);
%             
%             exp.time = nan;
%             exp.allcost = nan;
%             exp.allevals = nan;
%             exp.allmsgs = nan;
%             exp.iterations = nan;
%             exp.alltimes = nan;
%         end
        
        solverfield = matlab.lang.makeValidName(solvername);
        results.(solverfield).solver = solvers(a);
        results.(solverfield).costs{e} = exp.allcost; 
        results.(solverfield).evals{e} = exp.allevals;
        results.(solverfield).msgs{e} = exp.allmsgs;
        results.(solverfield).times{e} = exp.alltimes;
        results.(solverfield).iterations(e) = exp.iterations;
        
        if settings.visualizeProgress
            visualizeProgress(exp, solverfield);
        end
    end
end

%% Save results

save(fullfile('data', sprintf('%s_results.mat', expname)), 'settings', 'options', 'solvers', 'results');

%% Create graph

graphoptions = getGraphOptions();
graphoptions.figure.number = 188;
graphoptions.figure.height = 12;
graphoptions.axes.yscale = 'linear'; % True for most situations
graphoptions.axes.xscale = 'linear';
graphoptions.axes.ymin = [];
graphoptions.axes.xmax = 100;
graphoptions.export.do = true;
graphoptions.export.format = 'eps';
graphoptions.export.name = expname;
graphoptions.label.Y = 'Solution Cost';
% graphoptions.label.X = 'Time';
graphoptions.plot.errorbar = false;
graphoptions.plot.emphasize = {}; %'CoCoA';
graphoptions.legend.box = 'off';
% graphoptions.legend.orientation = 'Horizontal';
% graphoptions.plot.x_fun = @(x) 1:max(x);
% graphoptions.plot.range = 1:1600;
resultsMat = prepareResults(results); %, graphoptions.plot.range);
createResultGraph(resultsMat, 'times', 'costs', graphoptions);
createResultTable(results)

