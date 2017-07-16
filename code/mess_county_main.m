% mess_county_main - this entry file specify the data path and analysis
% parameters
% @author: Yu-Ru Lin (yuruliny@gmail.com)
% @date: Jun 8, 2012
% @history:
%  [2012.06.08] call mess_county.m with opts
%  [2017.05.10] modify previous version for R&P

function mess_county_main()
% specify the dependency path for the Econometrics Toolbox
% the toolbox can be downloaded at: http://www.spatial-econometrics.com/
addpath(genpath('jplv7')); 

% default options
opts = struct( ...
    'verbose', 1, ...
    'datapath', '../data/messdata_temporal', ...
    'state', '', ...
    'party', '', ...
    'ystart', 2000, ...
    'yend', 2010 ...
) ;

% generate results for all models specified in the paper
% set opts.party to be one of {'','R','D'} for results w.r.t. all, Rep, and Dem parties 
opts.ystart = 2000; opts.yend = 2008; opts.party = '';
mess_county(opts);

