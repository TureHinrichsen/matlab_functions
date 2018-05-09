function quickPlotTA(filename, varargin)
%QUICKPLOTTA Loads data that is in the standard TA format and plots a map
%   File has to be in the format [[], t; wl, dtt]
%   Arguments:
%       - filename:     Name (and path if needed) of file to be loaded
%       - varargin:     If 'log' it changes the x scale to log

data = load(filename);
wl = data(2:end,1);
t = data(1,2:end);
dtt = data(2:end,2:end);

figure
pcolor(t,wl,dtt);
shading interp

if strcmp(varargin,'log')
    set(gca,'XScale','log')
end

end
    