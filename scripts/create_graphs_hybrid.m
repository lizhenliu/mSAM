%% Get Default options
options = getGraphOptions();
options.plot.colors = cubehelix(7, .5, -1.5, 3, 1);
options.export.do = true;
options.export.format = 'eps';
options.export.folder = 'C:\Data\Documents\PHD\papers\hybrid\images';
options.export.tables = 'C:\Data\Documents\PHD\papers\hybrid\tables';
options.plot.errorbar = false;
% options.plot.hi_error_fun = @(x) nanmean(x,2) + nanstd(x, [], 2);
% options.plot.lo_error_fun = @(x) nanmean(x,2) - nanstd(x, [], 2);
options.plot.y_fun = @(x) nanmean(x,2);
options.plot.x_fun = @(x) nanmean(x,2);
options.plot.fixedStyles = getFixedAlgoStyles();
options.plot.emphasize = {'CoCoA*'};
% options.plot.styles = {':', '-', '--', '-.', '-', '--'};
options.label.Y = 'Solution cost';
options.label.X = 'Running time (s)';

%% Graph coloring experiment
exp(1) = load('data\ijcai17\results_graphColoring_delaunayGraph_i100_d3_n200_t20160917T133421');
results = fixSleepyLaptop(exp(1).results);
options.export.name = 'graph_coloring';

% Convert from cells to matrix
results.CoCoA = results.CoCoA_UF;
results = rmfield(results,'CoCoA_UF');
resultsMat = prepareResults(results);

% Create figure
options.figure.number = 187;
options.axes.xmin = [];
options.axes.xmax = 5;
options.axes.ymin = [];
options.axes.ymax = [];
createResultGraph(resultsMat, 'times', 'costs', options);
createResultTable(results, options);

fprintf('In %d out of %d instances ACLS finds a better result with CoCoA instantiation\n', ...
    sum(resultsMat.CoCoA_ACLS.costs(end,:) < resultsMat.ACLS.costs(end,:)), ...
    size(resultsMat.CoCoA_ACLS.costs, 2));
fprintf('In %d out of %d instances ACLSUB finds a better result with CoCoA instantiation\n', ...
    sum(resultsMat.CoCoA_ACLSUB.costs(end,:) < resultsMat.ACLSUB.costs(end,:)), ...
    size(resultsMat.CoCoA_ACLSUB.costs, 2));
fprintf('In %d out of %d instances DSA finds a better result with CoCoA instantiation\n', ...
    sum(resultsMat.CoCoA_DSA.costs(end,:) < resultsMat.DSA.costs(end,:)), ...
    size(resultsMat.CoCoA_DSA.costs, 2));
fprintf('In %d out of %d instances MCSMGM finds a better result with CoCoA instantiation\n', ...
    sum(resultsMat.CoCoA_MCSMGM.costs(end,:) < resultsMat.MCSMGM.costs(end,:)), ...
    size(resultsMat.CoCoA_MCSMGM.costs, 2));
fprintf('In %d out of %d instances MGM2 finds a better result with CoCoA instantiation\n', ...
    sum(resultsMat.CoCoA_MGM2.costs(end,:) < resultsMat.MGM2.costs(end,:)), ...
    size(resultsMat.CoCoA_MGM2.costs, 2));

%% Graph coloring experiment
exp(2) = load('data\ijcai17\results_semirandom_scalefreeGraph_i100_d10_n200_t20160919T071243');
results = fixSleepyLaptop(exp(2).results);
options.export.name = 'semirandom';

% Convert from cells to matrix
results.CoCoA = results.CoCoA_UF;
results = rmfield(results,'CoCoA_UF');
results = rmfield(results,{'DSA', 'CoCoA_DSA'});
results = rmfield(results,{'MGM2', 'CoCoA_MGM2'});
results.Max_Sum = results.Max_Sum_ADVP;
results = rmfield(results,'Max_Sum_ADVP');
resultsMat = prepareResults(results);

% Create figure
options.figure.number = 188;
options.axes.xmin = [];
options.axes.xmax = 70;
options.axes.ymin = [];
options.axes.ymax = [];
createResultGraph(resultsMat, 'times', 'costs', options);
createResultTable(results, options);

% Display interesting result:
fprintf('In %d out of %d instances ACLS finds a better result with CoCoA instantiation\n', ...
    sum(resultsMat.CoCoA_ACLS.costs(end,:) < resultsMat.ACLS.costs(end,:)), ...
    size(resultsMat.CoCoA_ACLS.costs, 2));
fprintf('In %d out of %d instances ACLSUB finds a better result with CoCoA instantiation\n', ...
    sum(resultsMat.CoCoA_ACLSUB.costs(end,:) < resultsMat.ACLSUB.costs(end,:)), ...
    size(resultsMat.CoCoA_ACLSUB.costs, 2));
fprintf('In %d out of %d instances MCSMGM finds a better result with CoCoA instantiation\n', ...
    sum(resultsMat.CoCoA_MCSMGM.costs(end,:) < resultsMat.MCSMGM.costs(end,:)), ...
    size(resultsMat.CoCoA_MCSMGM.costs, 2));

%% Graph coloring experiment
exp(3) = load('data\hybrid+\results_graphColoring_randomGraph_i100_d4_n200_t20170209T085209');
results = fixSleepyLaptop(exp(3).results);
options.export.name = 'hybrid+';

if isfield(options.plot, 'fixedStyles')
    options.plot = rmfield(options.plot, 'fixedStyles');
end

createResultTable(results, options);

% Convert from cells to matrix
% results.CoCoA = results.CoCoA_UF;
results = rmfield(results, {'ACLS','ACLSUB','DSA','MCSMGM','MGM2'});
resultsMat = prepareResults(results);

% Create figure
options.figure.number = 189;
options.axes.xmin = [];
options.axes.xmax = 400;
options.axes.ymin = 20;
options.axes.ymax = 100;
options.label.X = 'Iterations';
createResultGraph(resultsMat, 'iterations', 'costs', options);
