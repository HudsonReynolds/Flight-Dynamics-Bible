% mass spring
syms x(t) k

L = 1/2*diff(x,t)^2 - 1/2*k*x^2 %[output:8431d651]

q = {x};

eom = createEOM(L, q) %[output:598e140e]
%%
% pendulum
syms theta(t) m l g y

L = 1/2*m*diff(theta)^2*l^2 + m*g*l*cos(theta) %[output:82c3cbe8]

q = {theta};

eom = createEOM(L,q) %[output:90525b09]
%%
% inverted pendulum
syms M m x(t) I theta(t) l g

L = 1/2*((M+m)*diff(x)^2+I*diff(theta)^2) + m*l*cos(theta)*diff(theta)*diff(x) - m*g*l*cos(theta) %[output:1b351546]

q = {x, theta} %[output:1755af5a]

eom = createEOM(L,q) %[output:3335c7e8]
%%
syms r(t) theta(t) phi(t) mu J2 R0 t

q = {r,theta,phi} %[output:07413f7d]

L = 1/2*(diff(r,t)^2 + r^2*diff(theta,t)^2 + r^2*sin(theta)^2*diff(phi,t)^2) + mu/r - mu*J2*R0^2 / (2*r^3) * (3*cos(theta)^2 - 1) %[output:6f0b53f0]

eom = createEOM(L,q) %[output:70f2d44c]

eomLatex = createEOM_DotNotation(eom, q) %[output:4850cc4b]




%%
% double pendulum
syms m l theta(t) phi(t) g omega alpha

assume(l > 0);
assume(m > 0);

L = 1/2*m*l^2*(2*diff(theta)^2+diff(phi)^2+2*diff(theta)*diff(phi)*cos(theta-phi))+m*g*l*(2*cos(theta)+cos(phi))

q = {theta, phi}

eom = createEOM(L,q)
% Compute simplified symbolic expression %[task:01ce]
simplifiedExpr = simplify(eom,"Steps",6400) %[task:01ce]

syms theta_ddot phi_ddot theta_dot phi_dot %phi theta

equations = subs(simplifiedExpr, [diff(theta(t),t,2), diff(phi(t),t,2), ...
    diff(theta(t), t, 1), diff(phi(t), t, 1)],[theta_ddot phi_ddot theta_dot phi_dot])

syms theta phi

equations = [2*g*sin(theta) + 2*l*theta_ddot == l*phi_dot^2*sin(phi - theta) - l*phi_ddot*cos(phi - theta); l*sin(phi - theta)*theta_dot^2 + g*sin(phi) + l*phi_ddot == l*theta_ddot*(2*sin(phi/2 - theta/2)^2 - 1)]

sol = solve(equations == [0; 0], [theta_ddot, phi_ddot])

theta = simplify(sol.theta_ddot, "Steps", 6400)
phi = simplify(sol.phi_ddot, "Steps", 6400)

%%
function eom = createEOM(L, q)
% createEOM  Generate Euler–Lagrange equations
%
% L: symbolic Lagrangian
% q: vector of generalized coordinates (symbolic functions of t)


% create a time variable
syms t

% for each generalized coordinate, create an EOM

for idx = 1:length(q)

    % Generalized velocity
    qd = diff(q{idx}, t);

    % Euler–Lagrange equations
    eom(idx) = diff(diff(L, qd), t) - diff(L, q{idx}) == 0;

end

eom = eom.';
end
%%
function eomLatex = createEOM_DotNotation(L, q)
    syms t
    N = length(q);
    eom = sym(zeros(N, 1));
    
    % Step 1: Compute Euler-Lagrange Equations
    for idx = 1:N
        qd = diff(q{idx}, t);
        eom(idx) = diff(diff(L, qd), t) - diff(L, q{idx}) == 0;
    end

    % Step 2: Pure Symbolic Substitution to Avoid Regex Parsing
    for idx = 1:N
        % Get base variable name (e.g., 'r', 'theta')
        baseStr = strtok(char(q{idx}), '(');
        
        % Create symbolic dummy variables for dots
        q_sym    = sym(baseStr);
        q_dot    = sym([baseStr '_dot']);
        q_ddot   = sym([baseStr '_ddot']);
        
        % Replace derivative expressions symbolically
        eom = subs(eom, diff(q{idx}, t, 2), q_ddot);
        eom = subs(eom, diff(q{idx}, t, 1), q_dot);
        eom = subs(eom, q{idx}, q_sym);
    end
    
    % Step 3: Convert to LaTeX and replace temporary dummy string tokens
    eomLatex = cell(N, 1);
    for idx = 1:N
        strL = latex(eom(idx));
        strL = strrep(strL, '{\ddot{', '\ddot{');
        strL = regexprep(strL, '(\\mathrm\{|\text\{)?(\w+)_ddot\}?', '\\ddot{$2}');
        strL = regexprep(strL, '(\\mathrm\{|\text\{)?(\w+)_dot\}?', '\\dot{$2}');
        eomLatex{idx} = strL;
    end
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":42.1}
%---
%[task:01ce]
%   data: {"appState":"{\"Version\":\"1.0\",\"Expression\":\"eom\",\"Method\":\"simplify\",\"SimplifyEffort\":\"6400\",\"RewriteTarget\":\"sincos\",\"ExpandArithmeticOnly\":false,\"ExpandIgnoreAnalyticConstraints\":false,\"CombineTarget\":\"Operators only\",\"CombineItems\":[\"Operators only\",\"atan\",\"exp\",\"gamma\",\"int\",\"log\",\"sincos\",\"sinhcosh\"],\"CombineIgnoreAnalyticConstraints\":false,\"SimplifyFractionExpand\":false,\"DisplayExpression\":false,\"DisplaySimplified\":true}","autorun":"1","collapsed":"0","outputs":"simplifiedExpr","run":"section","taskClassDefFile":"matlab.internal.symbolic.task.Simplify","uniqueId":"symbolic\/SimplifySymbolicExpression","variablesMap":"{\"simplifiedExpr\":\"simplifiedExpr\"}","view":"controls-and-code"}
%---
%[output:8431d651]
%   data: {"dataType":"symbolic","outputData":{"name":"L(t)","value":"\\frac{{{\\left(\\frac{\\partial }{\\partial t}\\;x\\left(t\\right)\\right)}}^2 }{2}-\\frac{k\\,{x\\left(t\\right)}^2 }{2}"}}
%---
%[output:598e140e]
%   data: {"dataType":"symbolic","outputData":{"name":"eom","value":"\\frac{\\partial^2 }{\\partial t^2 }\\;x\\left(t\\right)+k\\,x\\left(t\\right)=0"}}
%---
%[output:82c3cbe8]
%   data: {"dataType":"symbolic","outputData":{"name":"L(t)","value":"\\frac{m\\,l^2 \\,{{\\left(\\frac{\\partial }{\\partial t}\\;\\theta \\left(t\\right)\\right)}}^2 }{2}+g\\,m\\,\\cos \\left(\\theta \\left(t\\right)\\right)\\,l"}}
%---
%[output:90525b09]
%   data: {"dataType":"symbolic","outputData":{"name":"eom","value":"m\\,l^2 \\,\\frac{\\partial^2 }{\\partial t^2 }\\;\\theta \\left(t\\right)+g\\,m\\,\\sin \\left(\\theta \\left(t\\right)\\right)\\,l=0"}}
%---
%[output:1b351546]
%   data: {"dataType":"symbolic","outputData":{"name":"L(t)","value":"\\frac{{\\left(M+m\\right)}\\,{{\\left(\\frac{\\partial }{\\partial t}\\;x\\left(t\\right)\\right)}}^2 }{2}+\\frac{\\textrm{I}\\,{{\\left(\\frac{\\partial }{\\partial t}\\;\\theta \\left(t\\right)\\right)}}^2 }{2}-g\\,l\\,m\\,\\cos \\left(\\theta \\left(t\\right)\\right)+l\\,m\\,\\cos \\left(\\theta \\left(t\\right)\\right)\\,\\frac{\\partial }{\\partial t}\\;x\\left(t\\right)\\,\\frac{\\partial }{\\partial t}\\;\\theta \\left(t\\right)"}}
%---
%[output:1755af5a]
%   data: {"dataType":"tabular","outputData":{"columns":2,"header":"1×2 cell array","name":"q","rows":1,"type":"cell","value":[["1×1 symfun","1×1 symfun"]]}}
%---
%[output:3335c7e8]
%   data: {"dataType":"symbolic","outputData":{"name":"eom","value":"\\begin{array}{l}\n\\left(\\begin{array}{c}\n{\\left(M+m\\right)}\\,\\sigma_1 -l\\,m\\,\\sin \\left(\\theta \\left(t\\right)\\right)\\,{{\\left(\\frac{\\partial }{\\partial t}\\;\\theta \\left(t\\right)\\right)}}^2 +l\\,m\\,\\cos \\left(\\theta \\left(t\\right)\\right)\\,\\sigma_2 =0\\\\\n\\textrm{I}\\,\\sigma_2 +l\\,m\\,\\cos \\left(\\theta \\left(t\\right)\\right)\\,\\sigma_1 -g\\,l\\,m\\,\\sin \\left(\\theta \\left(t\\right)\\right)=0\n\\end{array}\\right)\\\\\n\\mathrm{}\\\\\n\\textrm{where}\\\\\n\\mathrm{}\\\\\n\\;\\;\\sigma_1 =\\frac{\\partial^2 }{\\partial t^2 }\\;x\\left(t\\right)\\\\\n\\mathrm{}\\\\\n\\;\\;\\sigma_2 =\\frac{\\partial^2 }{\\partial t^2 }\\;\\theta \\left(t\\right)\n\\end{array}"}}
%---
%[output:07413f7d]
%   data: {"dataType":"tabular","outputData":{"columns":3,"header":"1×3 cell array","name":"q","rows":1,"type":"cell","value":[["1×1 symfun","1×1 symfun","1×1 symfun"]]}}
%---
%[output:6f0b53f0]
%   data: {"dataType":"symbolic","outputData":{"name":"L(t)","value":"\\frac{\\mu }{r\\left(t\\right)}+\\frac{{{\\left(\\frac{\\partial }{\\partial t}\\;r\\left(t\\right)\\right)}}^2 }{2}+\\frac{{r\\left(t\\right)}^2 \\,{{\\left(\\frac{\\partial }{\\partial t}\\;\\theta \\left(t\\right)\\right)}}^2 }{2}+\\frac{{\\sin \\left(\\theta \\left(t\\right)\\right)}^2 \\,{r\\left(t\\right)}^2 \\,{{\\left(\\frac{\\partial }{\\partial t}\\;\\phi \\left(t\\right)\\right)}}^2 }{2}-\\frac{J_2 \\,{R_0 }^2 \\,\\mu \\,{\\left(3\\,{\\cos \\left(\\theta \\left(t\\right)\\right)}^2 -1\\right)}}{2\\,{r\\left(t\\right)}^3 }"}}
%---
%[output:70f2d44c]
%   data: {"dataType":"symbolic","outputData":{"name":"eom","value":"\\begin{array}{l}\n\\left(\\begin{array}{c}\n\\frac{\\mu }{{r\\left(t\\right)}^2 }-r\\left(t\\right)\\,{{\\left(\\frac{\\partial }{\\partial t}\\;\\theta \\left(t\\right)\\right)}}^2 -\\sigma_1 \\,r\\left(t\\right)\\,\\sigma_2 +\\frac{\\partial^2 }{\\partial t^2 }\\;r\\left(t\\right)-\\frac{3\\,J_2 \\,{R_0 }^2 \\,\\mu \\,{\\left(3\\,{\\cos \\left(\\theta \\left(t\\right)\\right)}^2 -1\\right)}}{2\\,{r\\left(t\\right)}^4 }=0\\\\\n{r\\left(t\\right)}^2 \\,\\frac{\\partial^2 }{\\partial t^2 }\\;\\theta \\left(t\\right)+2\\,r\\left(t\\right)\\,\\frac{\\partial }{\\partial t}\\;\\theta \\left(t\\right)\\,\\frac{\\partial }{\\partial t}\\;r\\left(t\\right)-\\cos \\left(\\theta \\left(t\\right)\\right)\\,\\sin \\left(\\theta \\left(t\\right)\\right)\\,{r\\left(t\\right)}^2 \\,\\sigma_2 -\\frac{3\\,J_2 \\,{R_0 }^2 \\,\\mu \\,\\cos \\left(\\theta \\left(t\\right)\\right)\\,\\sin \\left(\\theta \\left(t\\right)\\right)}{{r\\left(t\\right)}^3 }=0\\\\\n\\sigma_1 \\,{r\\left(t\\right)}^2 \\,\\frac{\\partial^2 }{\\partial t^2 }\\;\\phi \\left(t\\right)+2\\,\\sigma_1 \\,r\\left(t\\right)\\,\\frac{\\partial }{\\partial t}\\;r\\left(t\\right)\\,\\frac{\\partial }{\\partial t}\\;\\phi \\left(t\\right)+2\\,\\cos \\left(\\theta \\left(t\\right)\\right)\\,\\sin \\left(\\theta \\left(t\\right)\\right)\\,{r\\left(t\\right)}^2 \\,\\frac{\\partial }{\\partial t}\\;\\theta \\left(t\\right)\\,\\frac{\\partial }{\\partial t}\\;\\phi \\left(t\\right)=0\n\\end{array}\\right)\\\\\n\\mathrm{}\\\\\n\\textrm{where}\\\\\n\\mathrm{}\\\\\n\\;\\;\\sigma_1 ={\\sin \\left(\\theta \\left(t\\right)\\right)}^2 \\\\\n\\mathrm{}\\\\\n\\;\\;\\sigma_2 ={{\\left(\\frac{\\partial }{\\partial t}\\;\\phi \\left(t\\right)\\right)}}^2 \n\\end{array}"}}
%---
%[output:4850cc4b]
%   data: {"dataType":"error","outputData":{"errorType":"runtime","text":"Unable to perform assignment because the left and right sides have a different number of elements.\n\nError in <a href=\"matlab:matlab.lang.internal.introspective.errorDocCallback('sym\/privsubsasgn', '\/Applications\/MATLAB_R2025b.app\/toolbox\/symbolic\/symbolic\/@sym\/sym.m', 1183)\" style=\"font-weight:bold\">sym\/privsubsasgn<\/a> (<a href=\"matlab: opentoline('\/Applications\/MATLAB_R2025b.app\/toolbox\/symbolic\/symbolic\/@sym\/sym.m',1183,0)\">line 1183<\/a>)\n                L_tilde2 = builtin('subsasgn',L_tilde,struct('type','()','subs',{varargin}),R_tilde);\n                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\nError in <a href=\"matlab:matlab.lang.internal.introspective.errorDocCallback('sym\/subsasgn', '\/Applications\/MATLAB_R2025b.app\/toolbox\/symbolic\/symbolic\/@sym\/sym.m', 1030)\" style=\"font-weight:bold\">indexing<\/a> (<a href=\"matlab: opentoline('\/Applications\/MATLAB_R2025b.app\/toolbox\/symbolic\/symbolic\/@sym\/sym.m',1030,0)\">line 1030<\/a>)\n                C = privsubsasgn(L,R,inds{:});\n                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\nError in <a href=\"matlab:matlab.lang.internal.introspective.errorDocCallback('Lagrangian>createEOM_DotNotation', '\/Users\/hudson\/Documents\/GitHub\/Flight-Dynamics-Bible\/Scripts\/Example Problems\/Lagrangian.m', 104)\" style=\"font-weight:bold\">Lagrangian>createEOM_DotNotation<\/a> (<a href=\"matlab: opentoline('\/Users\/hudson\/Documents\/GitHub\/Flight-Dynamics-Bible\/Scripts\/Example Problems\/Lagrangian.m',104,0)\">line 104<\/a>)\n        eom(idx) = diff(diff(L, qd), t) - diff(L, q{idx}) == 0;\n        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"}}
%---
