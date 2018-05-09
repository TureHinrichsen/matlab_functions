function axArray = breakXAxis(breakStart, breakStop, figHandle, axHandle)
%BREAKXAXIS Splits the x axis and removes a specific region
%   AXARRAY = BREAKXAXIS(BREAKSTART,BREAKSTOP) removes data between 
%   BREAKSTART and BREAKSTOP and contracts the x axis. BREAKSTART and
%   BREAKSTOP must be numbers. It creates four axes to return in AXARRAY: 
%       - AXARRAY(1) contains the data before the break and the bottom and
%       left ticks.
%       - AXARRAY(2) contains the top ticks before the break.
%       - AXARRAY(3) contains the data after the break and the bottom and
%       right ticks.
%       - AXARRAY(4) contains the top ticks after the break.
%
%   AXARRAY = BREAKXAXIS(BREAKSTART,BREAKSTOP,FIGHANDLE) also specifies 
%   which figure to modify. The default is the currently active figure.
%
%   AXARRAY = BREAKXAXIS(BREAKSTART,BREAKSTOP,FIGHANDLE,AXHANDLE) and 
%   AXARRAY = BREAKXAXIS(BREAKSTART,BREAKSTOP, [], AXHANDLE) also specifiy 
%   which axis to modify. The default is the currently active axis.


if nargin < 3 || isempty(figHandle)
    figHandle = gcf;
end
if nargin < 4 || isempty(axHandle)
    axHandle = gca;
end


% Create axes to store labels (so that they don't appear on all other axes)
labelAxes = copyobj(axHandle, figHandle);
oldPosition = axHandle.Position;
delete(axHandle.XLabel)
delete(axHandle.YLabel)

fractionBefore = (breakStart - axHandle.XLim(1)) / ...
         ((breakStart - axHandle.XLim(1)) + (axHandle.XLim(2) - breakStop));
fractionAfter = (axHandle.XLim(2) - breakStop) / ...
         ((breakStart - axHandle.XLim(1)) + (axHandle.XLim(2) - breakStop));
     
widthGap = 0.02 * axHandle.Position(3);
widthBefore = fractionBefore * axHandle.Position(3) - widthGap / 2;
widthAfter = fractionAfter * axHandle.Position(3) - widthGap / 2;

% Create axis before break
axBefore = copyobj(axHandle, figHandle);
axBefore.Position = oldPosition;
axBefore.Position(3) = widthBefore;
axBefore.XLim = [axHandle.XLim(1), breakStart];
axBefore.YLim = axHandle.YLim;
axBefore.Box = 'Off';
axBefore.XTick = axHandle.XTick(axHandle.XTick<breakStart);
axBefore.Units = 'Normalized';

% Add little line at break
axBeforeEnd = axBefore.Position(1) + axBefore.Position(3);
annotation('line',[axBeforeEnd-0.01, axBeforeEnd+0.01],...
    [axBefore.Position(2)-0.02, axBefore.Position(2)+0.02],...
    'LineWidth', axBefore.LineWidth)
% remove last XTick if necessary
if axBefore.XTick(end) == axBefore.XLim(2)
    axBefore.XTick(end) = [];
end
    
% Create copy of this axis to have additional x-axis on top
axBefore2 = copyobj(axBefore, figHandle);
axBefore2.Color = 'None';
axBefore2.XAxisLocation = 'Top';
axBefore2.XTickLabels = [];
axBefore2.YTick = [];

% Add little line at break
axBeforeEndY = axBefore2.Position(2) + axBefore2.Position(4);
annotation('line',[axBeforeEnd-0.01, axBeforeEnd+0.01],...
    [axBeforeEndY-0.02, axBeforeEndY+0.02],...
    'LineWidth', axBefore.LineWidth)

% Create axis after break
legHandle = findobj(figHandle, 'Type', 'Legend');
if isvalid(legHandle)
    axAfter = copyobj([legHandle, axHandle], figHandle);
    newLegend = axAfter(1);
    newLegend.Position = legHandle.Position;
    axAfter = axAfter(2);
else
    axAfter = copyobj(axHandle, figHandle);
end
axAfter.Position = oldPosition;
axAfter.Position(1) = axAfter.Position(1) + widthGap + widthBefore;
axAfter.Position(3) = widthAfter;
axAfter.Box = 'Off';
axAfter.YAxisLocation = 'Right';
axAfter.YTickLabels = [];
axAfter.XTick = axHandle.XTick(axHandle.XTick>breakStop);
axAfter.XLim = [breakStop, axHandle.XLim(2)];
axAfter.YLim = axHandle.YLim;

% Add little line at break
annotation('line',[axAfter.Position(1)-0.01, axAfter.Position(1)+0.01],...
    [axAfter.Position(2)-0.02, axAfter.Position(2)+0.02],...
    'LineWidth', axBefore.LineWidth)
% remove last XTick if necessary
if axAfter.XTick(1) == axAfter.XLim(1)
    axAfter.XTick(1) = [];
end

% Create second axis to have additional x-axis on top
axAfter2 = copyobj(axAfter, figHandle);
axAfter2.Color = 'None';
axAfter2.XAxisLocation = 'Top';
axAfter2.XTickLabels = [];

% Add little line at break
axAfterEndY = axAfter2.Position(2) + axAfter2.Position(4);
annotation('line',[axAfter2.Position(1)-0.01, axAfter2.Position(1)+0.01],...
    [axAfterEndY-0.02, axAfterEndY+0.02],...
    'LineWidth', axAfter2.LineWidth)

% Copy over labels and delete unecessary axes
labelAxes.XLabel.Units = 'Pixel';
% hLegend = findobj(figHandle, 'Type', 'Legend');
% if isvalid(hLegend)
%     legend(axAfter, hLegend.String, 'Position',hLegend.Position,...
%         'Box', hLegend.Box, 'Autoupdate', hLegend.AutoUpdate);
% end
copyobj(labelAxes.XLabel, axBefore)
copyobj(labelAxes.YLabel, axBefore)
delete(labelAxes)
delete(axHandle)



axArray = [axBefore, axBefore2, axAfter, axAfter2];
end