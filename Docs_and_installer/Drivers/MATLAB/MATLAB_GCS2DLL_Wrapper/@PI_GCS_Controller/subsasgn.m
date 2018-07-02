function val = subsasgn(c, S,val)
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
switch(upper(fun))
    case('ACTUALPOSITION')
        if(length(par)<1)
            error(sprintf('No axis given for %s command',fun));
        end
        POS(c,char(par),val);
    case('SERVO')
        if(length(par)<1)
            error(sprintf('No axis given for %s command',fun));
        end
        SVO(c,char(par),val);
    case('TARGETPOSITION')
        if(length(par)<1)
            error(sprintf('No axis given for %s command',fun));
        end
        MOV(c,char(par),val);
    case('VELOCITY')
        if(length(par)<1)
            error(sprintf('No axis given for %s command',fun));
        end
        VEL(c,char(par),val);
    case('RELATIVETARGET')
        if(length(par)<1)
            error(sprintf('No axis given for %s command',fun));
        end
        MVR(c,char(par),val);
    case('RECORDTABLERATE')
        RTR(c,val);
    otherwise

        switch(length(par))
            case 0
                feval(fun,c,val);
            case 1
                feval(fun,c,par{1},val);
            case 2
                feval(fun,c,par{1},par{2},val);
            case 3
                feval(fun,c,par{1},par{2},par{3},val);
            case 4
                feval(fun,c,par{1},par{2},par{3},par{4},val);
            case 5
                feval(fun,c,par{1},par{2},par{3},par{4},par{5},val);
        end
    
end
val = c;