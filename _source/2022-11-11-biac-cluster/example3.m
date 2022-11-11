function example3(sub, sess)

path_output = sprintf('example3_output/sub%02d_sess%d', sub, sess);
if ~exist(path_output, 'dir')    
    mkdir(path_output)
end

try
    if sub > 10
        error('some weird error')
    end

    % do some random operations so we have a better sense of time
    tic
    for i = 1:2000
        a = rand(1000);
    end
    time_spent = toc;

    % save output and record time spent
    fprintf('\nElapsed time is %f seconds.\n\n', time_spent)
    save(fullfile(path_output, 'output'), 'a', 'time_spent')

catch err
    % save error for debugging
    sprintf('error with sub%02d sess%d: %s', sub, sess, err.message)
    save(fullfile(path_output, 'error'), 'err')

end