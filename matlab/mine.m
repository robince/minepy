function [minestats, M] = mine(x, y, alpha, c, est, bias, norm)
% MINE  Maximal Information-based Nonparametric Exploration
%   
%   Returns a struct containing MIC, MAS, MEV, MCN (eps=0) and
%   MCN_GENERAL (eps=1-MIC).
%
%   MINESTATS = MINE(X, Y, ALPHA, C, EST) computes the MINE statistics
%   between X and Y. X and Y must be row vectors of size n.
%   Alpha is the exponent in B(n) = n^alpha and must be in (0, 1.0].
%   Parameter c determines how many more clumps there will be than 
%   columns in every partition and must be > 0.
%   Est is a string defining the estimation method.
%   'mic_approx' is the original MIC estimate defined in 
%   Reshef et al. (2011)
%   'mic_e' is the estimator presented in Reshef et al. (2015) 
%   (arXiv:1505.02213v2)
%
%   MINESTATS = MINE(X, Y, ALPHA, C) computes the MINE statistics
%   between X and Y. Default value of EST is 'mic_approx'.
%
%   MINESTATS = MINE(X, Y, ALPHA) computes the MINE statistics
%   between X and Y. Default value of c is 15.
%
%   MINESTATS = MINE(X, Y) computes the MINE statistics 
%   between X and Y. Default value of alpha is 0.6 and default value 
%   of c is 15.
% 
%   Example:
%   >> x = linspace(0, 1, 1000);
%   >> y = sin(10 * pi * x) + x;
%   >> minestats = mine(x, y)
% 
%   minestats = 
%   
%           mic: 1
%           mas: 0.7261
%           mev: 1
%           mcn: 4.5850
%   mcn_general: 4.5850
%           tic: 67.661

if nargin<7
    norm = 'mic';
end
if nargin<6
    bias = 'none';
end
if nargin<5
    est = 'mic_approx';
end
if nargin<4
    c = 15;
end
if nargin<3
    alpha = 0.6;
end

if strcmpi(bias, 'none')
    b = 0;
else
    b = 1; % miller madow
end

if strcmpi(est, 'mic_approx')
    e = 0;
else
    e = 1; % MIC_E
end

if strcmpi(norm, 'mic')
    n = 0;
elseif strcmpi(norm, 'mi')
    n = 1; % NORM_MI
else
    n = 2; % NORM_MAXJOINTENT
end

if nargout==1
    A = mine_mex(x, y, alpha, c, e, b, n);
else
    [A, M] = mine_mex(x, y, alpha, c, e, b, n);
end
minestats.mic = A(1);
minestats.mas = A(2);
minestats.mev = A(3);
minestats.mcn = A(4);
minestats.mcn_general = A(5);
minestats.tic = A(6);
