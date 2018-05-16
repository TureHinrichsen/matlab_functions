function zeroline = addZeroline(axesHandle)
% ADDZEROLINE  Adds a line at y = 0 to the plot
%   ADDZEROLINE() adds it to the currently active axes.
%   ADDZEROLINE(AXESHANDLE) adds it to the axes specified.
%
% This switches "Autoupdate" of the legend to "off" to prevent the
% zeroline from appearing in the legend. It is best used after all lines
% are added to the plot.

if nargin < 1
    axesHandle = gca;
end

axes(axesHandle);       % Make axes that has been handed over the current axes

if ~isempty(findobj(axesHandle, 'Type', 'Legend'))
    hLegend = findobj(axesHandle, 'Type', 'Legend');
    hLegend.AutoUpdate = 'off';
elseif ~isempty(findobj(gcf, 'Type', 'Legend'))
    hLegend = findobj(gcf, 'Type', 'Legend');
    if length(hLegend) > 1
        offCell = cell(size(hLegend));
        offCell(:) = {'off'};
        [hLegend.AutoUpdate] = offCell{:};
    else
        hLegend.AutoUpdate = 'off';
    end
end

zeroline = refline(0, 0);
zeroline.Color = 'k';
zeroline.LineWidth = axesHandle.LineWidth;
uistack(zeroline, 'bottom')