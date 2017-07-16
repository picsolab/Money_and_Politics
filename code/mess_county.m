% mess_county: use mess functions for county estimate
% @author: Yu-Ru Lin (yuruliny@gmail.com)
% @date: Mar 7, 2012


% run for entire US
function mess_county()
datapath = opts.datapath; % '../data/messdata'
party = opts.party;

% bayes parameters
do_bayes = 0;
prior.novi = 1;
% prior.rmin = 0; prior.rmax = 1; prior.rval = 4;
ndraw = 1100; nomit=100;
ctrl_vs = 1; %controlling for voteshare
ifilename = sprintf('%s/county%s-trTRUElogw.csv',datapath,party)

    function [data,Wc,Ws,W] = load_data(state)
        if nargin <1, state=''; end
        ifilename = sprintf('%s/county%s%s-trTRUElogw.csv',datapath,state,party)
        data = csvread(ifilename,1,1);        
        size(data)%,input('.')

        ifilename = sprintf('%s/county%s%s-idwt-trTRUElogw.csv',datapath,state,party)
        Ws = spconvert(dlmread(ifilename, ' ', 2,0));
        [m,n] = size(Ws) 
        %spy(Ws),input('.')
        m = max([m,n]);
        if (Ws(m,m)==0) Ws(m,m)=0; end
        mm = max([m,size(data,1)]);
        if (m<mm) Ws(mm,mm)=0; end
        Ws = Ws - diag(diag(Ws));

        ifilename = sprintf('%s/county%s%s-flow-trTRUElogw.csv',datapath,state,party)
        Wc = spconvert(dlmread(ifilename, ' ', 2,0));
        [m,n] = size(Wc); %spy(Wc),input('.')
        m = max([m,n]);
        if (Wc(m,m)==0) Wc(m,m)=0; end
        Wc = max(Wc,Wc'); %Wc = Wc + Wc';
        WC = Wc;
        Wc = Wc - diag(diag(Wc)); WC=Wc;
        % standardize the weight matrix
        Wc = normw(Wc);
        size(Wc),%input('.')
        
        xc = data(:,6); % latitude coordinates of the homes
        yc = data(:,7); % longitude coordinates of the homes
        % xy2cont() is a spatial econometrics toolbox function
        [j1 W j2] = xy2cont(xc,yc); % constructs a 1st-order contiguity
        % W = W - diag(diag(W));
        size(W),%spy(W),input('.')
        %WC = Wc; 
        %j1=(W>0);
        Wc = WC .* (Ws); Wc = normw(Wc);
        % W = Ws;
        if strcmp(state,'')==1, W = Ws; end       
    end % load_data
    function [perf,params,yhat] = get_model_result(result,vnames,ofilename,y)
        prt(result,vnames); % print result using prt() toolbox function
        % ofilename = sprintf('%s.%s.out',ifilename,modelname); 
        fid = fopen(ofilename,'w');
        prt(result,vnames,fid); fclose(fid);
        % compute mean absolute prediction error
        if strcmp(result.meth,'sac_g')==1 %do_bayes
        result.lam = result.lambda;
        bout = [result.beta
                result.rho
                result.lambda];
            tmp1 = std(result.bdraw);
            tmp2 = std(result.pdraw);
            tmp3 = std(result.ldraw);
            bstd = [tmp1'
                    tmp2
                    tmp3];  
        if strcmp(result.tflag,'tstat')
         tstat = bout./bstd;
         % find t-stat marginal probabilities
         result.tout = tdis_prb(tstat,result.nobs);
         result.tstat = bout./bstd; % trick for printing below
        else % find plevels
         draws = [result.bdraw result.pdraw result.ldraw];
         for i=1:result.nvar+2;
         if bout(i,1) > 0
         cnt = find(draws(:,i) > 0);
         tout(i,1) = 1 - (length(cnt)/(result.ndraw-result.nomit));
         else
         cnt = find(draws(:,i) < 0);
         tout(i,1) = 1 - (length(cnt)/(result.ndraw-result.nomit));
         end; % end of if - else
         end; % end of for loop
         result.tstat = bstd; %% NOTE; print bstd instead of tstat
         result.tout = tout;
        end; %tstat    
        else
          if strcmp(result.meth,'sem')==1
            bout = [result.beta
                    result.rho];    
          elseif strcmp(result.meth,'sac')==1
            bout = [result.beta
                    result.rho
                    result.lam];                
            result.yhat = y-result.resid;
          end %sac
          tout = norm_prb(result.tstat); % find asymptotic z
                                         % (normal) probabilities
          result.tout = tout;
        end % not sac_g
        mae = mean(abs(y - result.yhat));
        fprintf(1,'mean absolute prediction error = %8.4f,%8.4f \n', mae,result.sige*length(y));
        perf = [result.rsqr,result.rbar,result.sige,mae];
        params = [bout result.tstat tout];  % matrix to be printed
        yhat = result.yhat;
    end % get_model_result
    function output_table_file(tab,tabcnames,tabrnames,ofilename)
        fid = fopen(ofilename,'w');
        clear in;
        if strcmp(tabcnames,'')==0,
        in.cnames = tabcnames;
        end
        if strcmp(tabrnames,'')==0,
        in.rnames = tabrnames;
        end
        in.rflag = 0;
        c = length(tabcnames);
        if c>1, in.fmt = strvcat(repmat('%6.4f',[c,1]));
        else in.fmt = '%12.4f'; end
        % mprint(tab,in);
        in.fid = fid;
        mprint(tab,in);
        fclose(fid);    
    end % output_table_file

    function [tabs] = output_tables(tabs,ii,j,perf,params,yhat)
        tabs{1}(:,j) = perf; %[result.rsqr,result.rbar,result.sige,mae];
        %tmp = [bout result.tstat tout];  % matrix to be printed
        % size(tabs{2}),size(params)
        tabs{2}(ii,j) = params(:,1);
        tabs{3}(ii,j) = params(:,3);
        tabs{4}(:,j) = yhat;    
    end % output_tables
    function [tabs] = output_byState_tables(tabs,i,jj,sidx,perf,params,y,yhat,state,modelname)
        tabs{1}(i,8:9) = perf(2:3); %[result.rsqr,result.rbar,result.sige,mae];
        %tmp = [bout result.tstat tout];  % matrix to be printed
        % size(tabs{2}),size(params)
        tabs{1}(i,jj) = params(:,1);
        tabs{2}(i,jj) = params(:,3);
        tabs{3}(sidx,1) = yhat;    
        tabout = [y yhat];
        tabcnames = ''; tabrnames = '';
        ofilename = sprintf('%s-%s.tab3-%s.csv',ifilename,state,modelname);
        output_table_file(tabout,tabcnames,tabrnames,ofilename);
    end % output_tables
    
    function run_all_states()
        [data,Wc,Ws,W] = load_data;
        y = data(:,1);
        n = length(y);
        if ctrl_vs
          k = 7; % num of predictors
        else
          k = 8; % num of predictors
        end

        x = zeros(n,k); % an explanatory variables matrix
        x(:,1) = ones(n,1); % an intercept term
        % x(:,2:3) = data(:,2:3);

        % create 4 tables for performance, parameter mean/z-prob, yhat
        vnames = strvcat('mpc','constant','ec20','iflow','oflow','lambda','rho');
        if ctrl_vs,
          % [2017-05-11] remove pd20 (affluence density) to address VIF concern
          vnames = strvcat('mpc','constant','inc', ...
                                       'pd','vs','ec20', ...
                           'iflow','oflow','lambda','rho');
          x(:,2:5) = data(:,[10 9 2:3]);
        else
          vnames = strvcat('mpc','constant','inc','pd','ec20','pd20','iflow','oflow','lambda','rho');
          x(:,2:5) = data(:,[10 9 2:3]);
        end

        %tabrnames = strvcat('Model','R2','adjustR2','sigma2','loglik','MAE');
        tabrnames = strvcat('Model','R2','adjustR2','sigma2','MAE');
        tabcnames = strvcat('M1','M2','M3.1','M3.2','M2a','M3a','M3a.1');
        tabout = zeros(4,7);

        if ctrl_vs
          tab2rnames = strvcat('Model','constant','inc','pd','vs','ec20', ...
                               'iflow','oflow','lambda','rho');
        else
          tab2rnames = strvcat('Model','constant','inc','pd','ec20', ...
                               'pd20','iflow','oflow','lambda','rho');
        end
        if ctrl_vs,
          tab2out = zeros(9,7); %coef
          tab3out = zeros(9,7); %z-prob
        else
          tab2out = zeros(9,7); %coef
          tab3out = zeros(9,7); %z-prob
        end

        tab4cnames = strvcat('M1','M2','M3.1','y','lat','lon');
        tab4rnames = strvcat('Model',num2str((1:n)'));
        tab4out = zeros(n,10); %yhat

        xc = data(:,6); % latitude coordinates of the homes
        yc = data(:,7); % longitude coordinates of the homes
        tab4out(:,4:6) = [y,xc,yc];
        tabs = {tabout,tab2out,tab3out,tab4out};

        %%% model M3.1 %%%
        modelname = 'semM3.1'
        if ctrl_vs,
          x(:,2:7) = data(:,[10 9 11 2 4:5]);
          vnames = strvcat('mpc','constant','inc','pd','vs','ec20','iflow','oflow');
        else
          x(:,2:7) = data(:,[10 9 2:5]);
          vnames = strvcat('mpc','constant','inc','pd','ec20','pd20','iflow','oflow');
        end
        prt(moran(y,x,W))
        result = sem(y,x,W); 
        ofilename = sprintf('%s.%s.out',ifilename,modelname); 
        [perf,params,yhat] = get_model_result(result,vnames, ...
                                                     ofilename,y);
        if ctrl_vs,
          tabs = output_tables(tabs,1:8,3,perf,params,yhat);
        else
          tabs = output_tables(tabs,1:8,3,perf,params,yhat);
        end

        %%% model M2 %%%
        modelname = 'semM2'
        if ctrl_vs,
          x = x(:,1:5);
          vnames = strvcat('mpc','constant','inc','pd','vs','ec20');
        else
          x = x(:,1:5);
          vnames = strvcat('mpc','constant','inc','pd','ec20', ...
                           'pd20');
        end
        prt(moran(y,x,W))
        result = sem(y,x,W); 
        ofilename = sprintf('%s.%s.out',ifilename,modelname);
        [perf,params,yhat] = get_model_result(result,vnames, ...
                                                     ofilename,y);
        if ctrl_vs,
          tabs = output_tables(tabs,[1:5 8],2,perf,params,yhat);
        else
          tabs = output_tables(tabs,[1:5 8],2,perf,params,yhat);
        end


        %%% model M1 %%%
        modelname = 'semM1'
        if ctrl_vs
          x = x(:,1:5); vnames = strvcat('mpc','constant','inc', ...
                                         'pd','vs','ec20'); k=2;
        else
          x = x(:,1:4); vnames = strvcat('mpc','constant','inc', ...
                                         'pd','ec20'); k=2;
        end
        prt(moran(y,x,W))
        result = sem(y,x,W); % sar() is a toolbox function
        ofilename = sprintf('%s.%s.out',ifilename,modelname);
        [perf,params] = get_model_result(result,vnames,ofilename, ...
                                                y);
        if ctrl_vs
          tabs = output_tables(tabs,[1:5 8],1,perf,params,yhat);
        else
          tabs = output_tables(tabs,[1:4 8],1,perf,params,yhat);
        end

        % tabs{1},tabs{2},tabs{3}
        ofilename = sprintf('%s.tab1a-r.csv',ifilename);
        output_table_file(tabs{1},tabcnames,tabrnames,ofilename);

        ofilename = sprintf('%s.tab2a-r.csv',ifilename);
        output_table_file(tabs{2},tabcnames,tab2rnames,ofilename);

    end % run_all_states

    run_all_states();




end %mess_county






