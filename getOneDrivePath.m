function path = getOneDrivePath
%GETONEDRIVEPATH Returns path to my OneDrive folder on different computers

if exist('C:\Users\Ture\OneDrive - University Of Cambridge\','dir')
    path = 'C:\Users\Ture\OneDrive - University Of Cambridge\';
elseif exist('C:\Users\tfh26\OneDrive - University Of Cambridge\','dir')
    path = 'C:\Users\tfh26\OneDrive - University Of Cambridge\';
else
    error('OneDrive folder not found.')
end