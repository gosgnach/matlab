message = 'Press: Left Mouse to initiate Manual Mode; V button to set onset; B button to set offset; ENTER button to get results; Right Mouse to exit Manual.';
set(handles.instructions_edit, 'String', message);

% Switch block to determine which cursor button it was called from. 
% Case 0 ---> cell.
% Case 1 ---> root 1.
% Case 2 ---> root 2.
% Case 3 ---> root 3.
switch identity
    
    % Case 0 for cell.
    case 0
        % -------------------------------------------------------------
        % Obtains the information needed to create the cell object and
        % operations to detect bursts.
        %--------------------------------------------------------------
        % Cell data on axes3 of the GUI.
        ax = handles.axes3;
        % Gets the time, potential, threshold and baseline. Threshold and
        % baseline are set to NaN because the cell object does not need
        % them to determine bursts.
        time        = handles.time;
        potential   = handles.cell;
        threshold   = str2double(get(handles.thresh_cell_edit, 'String'));
        baseline    = NaN;
        % Try-catch block determines if cellOnset and cellOffset already
        % exist within the GUI handle structure. If they do, manual mode
        % builds onto the prexisting set of bursts, otherwise, manual mode
        % starts with no prexisting bursts.
        try
            mm = cel(time, potential, threshold,...
                handles.cellOnset, handles.cellOffset);
        catch err
            mm = cel(time, potential, threshold);
        end
    
    % Case 1 for root 1 data.
    case 1
        % -------------------------------------------------------------
        % Obtains the information needed to create the root 1 object 
        % and operations to detect bursts.
        %--------------------------------------------------------------
        % Root 1 data on axes2 of the GUI.
        ax = handles.axes2;
        % Baseline for root 1 must exist before the program can
        % continue, otherwise an error dialouge box pops up to warn
        % user to select a baseline first.
        if (~isfield(handles, 'baseline1'))
            errordlg('Please select a baseline for Root 1.');
            return;
        else
            baseline = handles.baseline1;
        end
        % Gets the time, potential, threshold.
        time        = handles.time;
        potential   = handles.root1;
        threshold = str2double(get(handles.thresh_root1_edit, 'String'));
        % Try-catch block determines if rootOnset1 and rootOffset1 already
        % exist within the GUI handle structure. If they do, manual mode
        % builds onto the prexisting set of bursts, otherwise, manual mode
        % starts with no prexisting bursts.
        try
            mm = root(time, potential, threshold,...
                handles.rootOnset1, handles.rootOffset1);
        catch err 
            mm = root(time, potential, threshold);
        end
        
    % Case 2 for root 2 data.
    case 2
        % -------------------------------------------------------------
        % Obtains the information needed to create the root 2 object 
        % and operations to detect bursts.
        %--------------------------------------------------------------
        % Root 2 data on axes4 of the GUI.
        ax = handles.axes4;
        % Baseline for root 2 must exist before the program can
        % continue, otherwise an error dialouge box pops up to warn
        % user to select a baseline first.
        if (~isfield(handles, 'baseline2'))
           errordlg('Please select a baseline for Root 2.');
           return;
        else
            baseline = handles.baseline2;
        end
        % Gets the time, potential, threshold.
        time        = handles.time;
        potential   = handles.root2;
        threshold = str2double(get(handles.thresh_root2_edit, 'String'));
        % Try-catch block determines if rootOnset2 and rootOffset2 already
        % exist within the GUI handle structure. If they do, manual mode
        % builds onto the prexisting set of bursts, otherwise, manual mode
        % starts with no prexisting bursts.
        try
            mm = root(time, potential, threshold,...
                handles.rootOnset2, handles.rootOffset2);
        catch err 
            mm = root(time, potential, threshold);
        end
        
    % Case 3 for root 3 data.
    case 3
        % -------------------------------------------------------------
        % Obtains the information needed to create the root 3 object 
        % and operations to detect bursts.
        %--------------------------------------------------------------
        % Root 3 data on axes5 of the GUI.
        ax = handles.axes5;
        % Baseline for root 3 must exist before the program can
        % continue, otherwise an error dialouge box pops up to warn
        % user to select a baseline first.
        if (~isfield(handles, 'baseline3'))
           errordlg('Please select a baseline for Root 3.');
           return;
        else
            baseline = handles.baseline3;
        end
        % Gets the time, potential, threshold.
        time        = handles.time;
        potential   = handles.root3;
        threshold = str2double(get(handles.thresh_root3_edit, 'String'));
        % Try-catch block determines if rootOnset3 and rootOffset3 already
        % exist within the GUI handle structure. If they do, manual mode
        % builds onto the prexisting set of bursts, otherwise, manual mode
        % starts with no prexisting bursts.
        try
            mm = root(time, potential, threshold,...
                handles.rootOnset3, handles.rootOffset3);
        catch err 
            mm = root(time, potential, threshold);
        end
end

% evenHandle is used as a place holder for 'v' button press that plots
% onsets. oddHandle is used as a place holder for 'b' button press that
% plots offsets. Plotting a single onset will add 2 to evenHandle and append
% that value to clickHistory. PLotting a single offset will add 2 to
% oddGandle and append that value to clickHistory. Even values in
% clickHistory represent clicks that plot onsets, odd values represent
% clicks that plots offsets.
% Example: clickHistory = [0, 1, 2, 3, 4, 6] represents this series of
% consecutive button clicks: Onset -> Offset -> Onset -> Offset -> Onset ->
% Onset.
% clickHistory is used to determine which marker to delete when the user
% chooses to undo a button click.
evenHandle = 0;
oddHandle = 1;
clickHistory = [];
yValues = [];

% Sets the axes to plot on.
axes(ax);
% Starts the manual mode function.
engRootManualMode( hObject, handles, identity, mm, baseline,...
    clickHistory, evenHandle, oddHandle, yValues);

set(handles.instructions_edit, 'String', '');
