message = 'Press: Left Mouse between an onset and offset to erase burst; Right Mouse to exit Erase.';
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
        % operations to erase bursts.
        %--------------------------------------------------------------
        % Cell data on axes3 of the GUI.
        ax = handles.axes3;
        % Gets the time, potential, threshold, baseline, and spike, trough,
        % burst settings. Threshold and baseline are set to NaN because the
        % cell object does not need them to determine bursts.
        baseline = NaN;
        handles.threshold0 = str2double(get(handles.thresh_cell_edit,...
            'String'));
        time        = handles.time;
        potential   = handles.cell;
        spike       = handles.cellSpike;
        trough      = handles.cellTrough;
        burst       = handles.cellBurst;
        percent = NaN;
        % Try-catch block to determine if there are bursts that were
        % detected. If so, creates the cel object, otherwise error dialog
        % box pops up.
        try
            mm = cel(time, potential, handles.threshold0,...
                handles.cellOnset, handles.cellOffset);
        catch err
            errordlg('Nothing to erase.');
        end
    
    % Case 1 for root 1.
    case 1
        % -------------------------------------------------------------
        % Obtains the information needed to create the root 1 object 
        % and operations to erase bursts.
        %--------------------------------------------------------------
        % Root 1 data on axes2 of the GUI.
        ax = handles.axes2;
        baseline = handles.baseline1;
        % Gets the time, potential, threshold, baseline, and spike, trough,
        % burst, percent settings for root 1.
        handles.threshold1 = str2double(get(handles.thresh_root1_edit,...
            'String'));
        time        = handles.time;
        potential   = handles.root1;
        span        = handles.span;
        factor      = handles.factor;
        spike       = handles.spike;
        trough      = handles.trough;
        burst       = handles.burst;
        percent     = handles.percent;
        % Try-catch block to determine if there are bursts that were
        % detected. If so, creates the cel object, otherwise error dialog
        % box pops up.
        try
            mm = root(time, potential, handles.threshold1,...
                handles.rootOnset1, handles.rootOffset1);
        catch err
            errordlg('Nothing to erase.');
        end

    % Case 2 for root 2.
    case 2
        % -------------------------------------------------------------
        % Obtains the information needed to create the root 2 object 
        % and operations to erase bursts.
        %--------------------------------------------------------------
        % Root 2 data on axes4 of the GUI.
        ax = handles.axes4;
        % Gets the time, potential, threshold, baseline, and spike, trough,
        % burst, percent settings for root 2.
        baseline = handles.baseline2;
        handles.threshold2 = str2double(get(handles.thresh_root2_edit,...
            'String'));
        time        = handles.time;
        potential   = handles.root2;
        span        = handles.span;
        factor      = handles.factor;
        spike       = handles.spike2;
        trough      = handles.trough2;
        burst       = handles.burst2;
        percent     = handles.percent2;
        % Try-catch block to determine if there are bursts that were
        % detected. If so, creates the cel object, otherwise error dialog
        % box pops up.
        try
            mm = root(time, potential, handles.threshold2,...
                handles.rootOnset2, handles.rootOffset2);
        catch err
            errordlg('Nothing to erase.');
        end
        
    % Case 3 for root 3.
    case 3
        % -------------------------------------------------------------
        % Obtains the information needed to create the root 3 object 
        % and operations to erase bursts.
        %--------------------------------------------------------------
        % Root 3 data on axes5 of the GUI.
        ax = handles.axes5;
        % Gets the time, potential, threshold, baseline, and spike, trough,
        % burst, percent settings for root 3.
        baseline = handles.baseline3;
        handles.threshold3 = str2double(get(handles.thresh_root3_edit,...
            'String'));
        time        = handles.time;
        potential   = handles.root3;
        span        = handles.span;
        factor      = handles.factor;
        spike       = handles.spike3;
        trough      = handles.trough3;
        burst       = handles.burst3;
        percent     = handles.percent3;
        % Try-catch block to determine if there are bursts that were
        % detected. If so, creates the cel object, otherwise error dialog
        % box pops up.
        try
            mm = root(time, potential, handles.threshold3,...
                handles.rootOnset3, handles.rootOffset3);
        catch err
            errordlg('Nothing to erase.');
        end
        
end

% Makes ax axes the current axes and initializes the engRootErase fucntion.
axes(ax);
engRootErase(hObject, handles, mm, ax, baseline, identity, percent)

set(handles.instructions_edit, 'String', '');