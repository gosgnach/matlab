% Clears command window.
clc;
disp('Initializing/Reseting Data');

% resets the GUI handles sttucture back to the defaultHandles structure
% initialized in the opening fuction of the GUI.
handles = defaultHandles;

% -------------------------------------------------------------------------
% Gets additonal user settings data from the root and sets them as fields
% in the handles sttucture.
% -------------------------------------------------------------------------
% Time data set for cell, root 1, and root 2.
handles.time            = getappdata(0, 'time');

% Electric potentials for the cell.
handles.cell            = getappdata(0, 'cell');

% Electric potentials for root 1.
handles.root1           = getappdata(0, 'root1');

% Electric potentials for root 2
handles.root2           = getappdata(0, 'root2');

% Electric potentials for root 3.
handles.root3           = getappdata(0, 'root3');

% Moving average span setting for both root data sets.
handles.span            = getappdata(0, 'span');

% Downsampling factor setting for both root data sets.
handles.factor          = getappdata(0, 'factor');

% Filter order setting that can be defined in the file import window.
handles.filtOrder       = getappdata(0, 'filtOrder');

% Sampling frequency setting that can be set in the file import window.
handles.sampFrequency   = getappdata(0, 'sampFrequency');

% Passband frequenct setting that can be set in the file import window.
handles.passFrequency   = getappdata(0, 'passFrequency');

% Spike threshold setting for the cell data set.
handles.cellSpike       = getappdata(0, 'cellSpike');

% Trough threshold setting for the cell data set.
handles.cellTrough      = getappdata(0, 'cellTrough');

% Burst threshold setting for the cell data set.
handles.cellBurst       = getappdata(0, 'cellBurst');

% Spike threshold setting for the root 1 data set.
handles.spike           = getappdata(0, 'spike');

% Trough threshold setting for the root 1 data set.
handles.trough          = getappdata(0, 'trough');

% Burst threshold setting for the root 1 data set.
handles.burst           = getappdata(0, 'burst');

% Deletion percentage setting for the root 1 data set.
handles.percent         = getappdata(0, 'percent');

% Spike threshold setting for the root 2 data set.
handles.spike2          = getappdata(0, 'spike2');

% Trough threshold setting for the root 2 data set.
handles.trough2         = getappdata(0, 'trough2');

% Burst threshold setting for the root 2 data set.
handles.burst2          = getappdata(0, 'burst2');

% Deletion percentage setting for the root 2 data set.
handles.percent2        = getappdata(0, 'percent2');

% Spike threshold setting for the root 3 data set.
handles.spike3          = getappdata(0, 'spike3');

% Trough threshold setting for the root 3 data set.
handles.trough3         = getappdata(0, 'trough3');

% Burst threshold setting for the root 3 data set.
handles.burst3          = getappdata(0, 'burst3');

% Deletion percentage setting for the root 3 data set.
handles.percent3        = getappdata(0, 'percent3');

% -------------------------------------------------------------------------
% Resets all edit boxes to blank.
% -------------------------------------------------------------------------
set(handles.baseline1_edit,     'String', '');
set(handles.thresh_root1_edit,  'String', '');
set(handles.root1_count_edit,   'String', '');
set(handles.root1_avg_dur_edit, 'String', '');
set(handles.root1_avg_per_edit, 'String', '');
set(handles.root1_avg_amp_edit, 'String', '');
set(handles.thresh_root2_edit,  'String', '');
set(handles.baseline2_edit,     'String', '');
set(handles.root2_count_edit,   'String', '');
set(handles.root2_avg_dur_edit, 'String', '');
set(handles.root2_avg_per_edit, 'String', '');
set(handles.root2_avg_amp_edit, 'String', '');
set(handles.root1_count_edit,   'String', '');
set(handles.root2_count_edit,   'String', '');
set(handles.baseline3_edit,     'String', '');
set(handles.thresh_root3_edit,  'String', '');
set(handles.root3_count_edit,   'String', '');
set(handles.root3_avg_dur_edit, 'String', '');
set(handles.root3_avg_per_edit, 'String', '');
set(handles.root3_avg_amp_edit, 'String', '');
set(handles.thresh_cell_edit,   'String', '');
set(handles.cell_count_edit,    'String', '');
set(handles.cell_avg_per_edit,  'String', '');
set(handles.cell_avg_dur_edit,  'String', '');
set(handles.onset_diff_edit,    'String', '');
set(handles.offset_diff_edit,   'String', '');
set(handles.instructions_edit,  'String', '');

% Getting parameters for initializing the signal analysis objects.
threshold1 = str2double(get(handles.thresh_root1_edit, 'String'));
threshold2 = str2double(get(handles.thresh_root2_edit, 'String'));
threshold3 = str2double(get(handles.thresh_root3_edit, 'String'));
span = getappdata(0, 'span');
factor = getappdata(0, 'factor');

% Plotting data begins.
disp('Plotting Data...')

% Links the cell, root 1, and root 2 axes together in the x axis so the
% move together while zooming in and panning.
warning OFF;
ax(1) = handles.axes2; % cell data on axes 2.
ax(2) = handles.axes3; % root 1 data on axes 3.
ax(4) = handles.axes4; % root 2 data on axes 4.
ax(5) = handles.axes5; % root 3 data on axes 5.
linkaxes(ax, 'x');

% Creates the cell data object and plots the cell data if exists.
axes(handles.axes3);
cla;
if (~isnan(handles.cell))
    ce = cel(handles.time, handles.cell, NaN);
    ce.plotData;
end

% Creates root 1 data object and plots root 1 data if exists.
axes(handles.axes2);
cla;
if(~isnan(handles.root1))
    ro1 = root(handles.time, handles.root1, threshold1);
    ro1.bandpass(handles.filtOrder, handles.sampFrequency, handles.passFrequency);
    ro1.downsample(factor);
    ro1.filterData(span);
    ro1.plotData;
end

% Creates root 2 data object and plots root 2 data if exists.
axes(handles.axes4);
cla;
if(~isnan(handles.root2))
    ro2 = root(handles.time, handles.root2, threshold2);
    ro2.bandpass(handles.filtOrder, handles.sampFrequency, handles.passFrequency);
    ro2.downsample(factor);
    ro2.filterData(span);
    ro2.plotData
end

% Creates root 3 data object and plots root 2 data if exists.
axes(handles.axes5);
cla;
if(~isnan(handles.root3))
    ro3 = root(handles.time, handles.root3, threshold3);
    ro3.bandpass(handles.filtOrder, handles.sampFrequency, handles.passFrequency);
    ro3.downsample(factor);
    ro3.filterData(span);
    ro3.plotData
end

% Finished plotting the data.
disp('Plotting Finished')

% -------------------------------------------------------------------------
% Follow try-catch blocks attempt to reset *Onset snd *Offset data sets for
% cell, root 1 and root 2 because they may or may not exist depending if
% the user performed operations or analysed that data set. If the fields
% exist in the GUI handles structure then it will be removed to restore the
% handles structure to initial state after plotting. Otherwise it does
% nothing.
% -------------------------------------------------------------------------
try
    handles = rmfield(handles, 'cellOnset');
    handles = rmfield(handles, 'cellOffset');
    guidata(hObject, handles);
catch err
    
end

try
    handles = rmfield(handles, 'rootOnset1');
    handles = rmfield(handles, 'rootOffset1');
    guidata(hObject, handles);
catch err
    
end

try
    handles = rmfield(handles, 'rootOnset2');
    handles = rmfield(handles, 'rootOffset2');
    guidata(hObject, handles);
catch err
    
end

try
    handles = rmfield(handles, 'rootOnset3');
    handles = rmfield(handles, 'rootOffset3');
    guidata(hObject, handles);
catch err
    
end

% Updates the GUI handles structure.
guidata(hObject, handles);