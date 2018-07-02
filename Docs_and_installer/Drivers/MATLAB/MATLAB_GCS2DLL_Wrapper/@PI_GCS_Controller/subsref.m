function varargout = subsref(c, S)
% function subsref(c, S)

% This code is provided by Physik Instrumente(PI) GmbH&Co.KG
% You may alter it corresponding to your needs
% Comments and Corrections are very welcome
% Please contact us by mailing to support-software@pi.ws

par = '';
for n = 1:length(S)
    switch S(n).type
        case '.'
            fun = S(n).subs;
        case '()'
            par = S(n).subs;
    end
end
%  disp(['fun: ',fun,'; par = ',par]);
switch(upper(fun))
    case('ACTUALPOSITION')
%         disp(['qPOS(',par,')']);
        varargout{1} = qPOS(c,char(par));
    case('TARGETPOSITION')
%         disp(['qMOV(',par,')']);
        varargout{1} = qMOV(c,char(par));
    case('IDENTIFICATION')
%         disp(['qMOV(',par,')']);
        varargout{1} = c.IDN;
    case('SERVO')
%         disp(['qMOV(',par,')']);
        varargout{1} = qSVO(c,char(par));

    otherwise
        outsize = nargout;
        if((outsize == 0)&&(~isempty([...
                regexp(fun,'q[A-Z]..'),...
                regexp(fun,'Is[A-Z]..*'),...
                regexp(fun,'Get[A-Z]..*'),...
                regexp(fun,'Enumerate..*'),...
                regexp(fun,'Receive[A-Z]..*')])))
            outsize = 1;
        end
        if(outsize == 1)
                           
            switch(length(par))
                case 0
                    varargout{1} = feval(fun,c);
                case 1
                    varargout{1} = feval(fun,c,par{1});
                case 2
                    varargout{1} = feval(fun,c,par{1},par{2});
                case 3
                    varargout{1} = feval(fun,c,par{1},par{2},par{3});
                case 4
                    varargout{1} = feval(fun,c,par{1},par{2},par{3},par{4});
                case 5
                    varargout{1} = feval(fun,c,par{1},par{2},par{3},par{4},par{5});
            end
        elseif(outsize == 2)
            switch(length(par))
                case 0
                    [varargout{1},varargout{2}] = feval(fun,c);
                case 1
                    [varargout{1},varargout{2}] = feval(fun,c,par{1});
                case 2
                    [varargout{1},varargout{2}] = feval(fun,c,par{1},par{2});
                case 3
                    [varargout{1},varargout{2}] = feval(fun,c,par{1},par{2},par{3});
                case 4
                    [varargout{1},varargout{2}] = feval(fun,c,par{1},par{2},par{3},par{4});
                case 5
                    [varargout{1},varargout{2}] = feval(fun,c,par{1},par{2},par{3},par{4},par{5});
            end

        elseif(outsize == 0)
            switch(length(par))
                case 0
                    feval(fun,c);
                case 1
                    feval(fun,c,par{1});
                case 2
                    feval(fun,c,par{1},par{2});
                case 3
                    feval(fun,c,par{1},par{2},par{3});
                case 4
                    feval(fun,c,par{1},par{2},par{3},par{4});
                case 5
                    feval(fun,c,par{1},par{2},par{3},par{4},par{5});
            end
        end
end
% keyboard;