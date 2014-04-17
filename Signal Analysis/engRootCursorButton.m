message = 'Press: Left Mouse to set threshold; Right Mouse to exit Cursor.';
set(handles.instructions_edit, 'String', message);

% Initiates ginput which is a crosshair that lets the user pick a point on
% a figure. This ginput allows only one button click and returns the x and
% y values along with the value of the button that was clicked.
[x, y, button] = ginput(1);

% Rcursively performs the following operations only if button 1 (Left Mouse Button),
% otherwise, it ends.
if (button == 1)

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
            % Gets the time, potential, threshold and the spike, trough, burst
            % settings.
            time        = handles.time;
            potential   = handles.cell;
            spike       = handles.cellSpike;
            trough      = handles.cellTrough;
            burst       = handles.cellBurst;
            set(handles.thresh_cell_edit, 'String', y);
            handles.threshold0 = str2double(get(handles.thresh_cell_edit, 'String'));
            % Cell object being created.
            ce = cel(time, potential, handles.threshold0);
            % Sets axes3 as the current axes for plotting.
            axes(ax);
            % Clears the current axes by finding all object on the plot
            % with the following prooperties and deletes them.
            del_items = findobj(ax, 'Color', 'red', '-or', 'Color', 'blue',...
                '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
                'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
            delete(del_items);
            % Operations that locates the bursts.
            ce.aboveThreshold
            ce.isBurst(spike, trough, burst);
            [handles.cellDuration, handles.cellCount] = ce.averageDuration;
            handles.cellPeriod = ce.averagePeriod;
            ce.plotMarkers;
            % Sets the values of the cell output edit boxes to the results
            % obtained by the operations above.
            set(handles.cell_count_edit, 'String', handles.cellCount);
            set(handles.cell_avg_dur_edit, 'String', handles.cellDuration);
            set(handles.cell_avg_per_edit, 'String', handles.cellPeriod);
            % Gets the *Onset and *Offset arrays used to calculate the time
            % difference between two sets of data and polar plots. Stores
            % these arrays onto fields on the GUI handles structure.
            [cellOnset, cellOffset] = ce.returnBurstInfo;
            handles.cellOnset = cellOnset';
            handles.cellOffset = cellOffset';
            % Updates the handles structure.
            guidata(hObject, handles);
            % Recursive if button == 1.
            cursor_cell_button_Callback(hObject, eventdata, handles);
            
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
            % Gets the time, potential, threshold and the span, factor,
            % spike, trough, burst, percent settings.
            time        = handles.time;
            potential   = handles.root1;
            span        = handles.span;
            factor      = handles.factor;
            spike       = handles.spike;
            trough      = handles.trough;
            burst       = handles.burst;
            percent     = handles.percent;
            set(handles.thresh_root1_edit, 'String', y);
            handles.threshold1 = str2double(get(handles.thresh_root1_edit, 'String'));
            % Creates the root 1 object.
            ro = root(time, potential, handles.threshold1);
            % Makes axes3 the current axes.
            axes(ax);
            % Clears the current axes by finding all object on the plot
            % with the following prooperties and deletes them.
            del_items = findobj(ax, 'Color', 'red', '-or', 'Color', 'blue',...
                '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
                'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
            delete(del_items); 
            % Operations that locates the bursts.
            ro.bandpass(handles.filtOrder, handles.sampFrequency, handles.passFrequency);
            ro.downsample(factor);
            ro.filterData(span);
            ro.aboveThreshold;
            ro.isBurst(spike, trough, burst);
            [handles.root1Duration, handles.root1Count] = ro.averageDuration;
            handles.root1Period = ro.averagePeriod;
            amp = ro.averageAmplitude(baseline);
            handles.root1Amp = amp - baseline;
            ro.plotMarkers;
            % Sets the values of the root 1 output edit boxes to the results
            % obtained by the operations above.
            handles.line1 = root.plotAmplitude(amp);
            ro.findDeletion(percent, amp, handles.root1Period);
            set(handles.root1_count_edit, 'String', handles.root1Count);
            set(handles.root1_avg_dur_edit, 'String', handles.root1Duration);
            set(handles.root1_avg_per_edit, 'String', handles.root1Period);
            set(handles.root1_avg_amp_edit, 'String', handles.root1Amp);
            % Gets the *Onset and *Offset arrays used to calculate the time
            % difference between two sets of data and polar plots. Stores
            % these arrays onto fields on the GUI handles structure.
            [rootOnset1, rootOffset1] = ro.returnBurstInfo;
            handles.rootOnset1 = rootOnset1';
            handles.rootOffset1 = rootOffset1';
            % Updates the handles structure.
            guidata(hObject, handles);
            % Recursive if button == 1.
            cursor_root1_button_Callback(hObject, eventdata, handles);
            
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
            % Gets the time, potential, threshold and the span, factor,
            % spike, trough, burst, percent settings.
            time        = handles.time;
            potential   = handles.root2;
            span        = handles.span;
            factor      = handles.factor;
            spike       = handles.spike2;
            trough      = handles.trough2;
            burst       = handles.burst2;
            percent     = handles.percent2;
            set(handles.thresh_root2_edit, 'String', y);
            handles.threshold2 = str2double(get(handles.thresh_root2_edit, 'String'));
            % Creates the root 2 object.
            ro = root(time, potential, handles.threshold2);
            % Makes axes4 the current axes.
            axes(ax);
            % Clears the current axes by finding all object on the plot
            % with the following prooperties and deletes them.
            del_items = findobj(ax, 'Color', 'red', '-or', 'Color', 'blue',...
                '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
                'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
            delete(del_items);
            % Operations that locates the bursts.
            ro.bandpass(handles.filtOrder, handles.sampFrequency, handles.passFrequency);
            ro.downsample(factor);
            ro.filterData(span);
            ro.aboveThreshold;
            ro.isBurst(spike, trough, burst);
            [handles.root2Duration, handles.root2Count] = ro.averageDuration;
            handles.root2Period = ro.averagePeriod;
            amp = ro.averageAmplitude(baseline);
            handles.root2Amp = amp - baseline;
            ro.plotMarkers;
            handles.line2 = root.plotAmplitude(amp);
            ro.findDeletion(percent, amp, handles.root2Period);
            % Sets the values of the root 2 output edit boxes to the results
            % obtained by the operations above.
            set(handles.root2_count_edit, 'String', handles.root2Count);
            set(handles.root2_avg_dur_edit, 'String', handles.root2Duration);
            set(handles.root2_avg_per_edit, 'String', handles.root2Period);
            set(handles.root2_avg_amp_edit, 'String', handles.root2Amp);
            % Gets the *Onset and *Offset arrays used to calculate the time
            % difference between two sets of data and polar plots. Stores
            % these arrays onto fields on the GUI handles structure.
            [rootOnset2, rootOffset2] = ro.returnBurstInfo;
            handles.rootOnset2 = rootOnset2';
            handles.rootOffset2 = rootOffset2';
            % Updates the handles structure.
            guidata(hObject, handles);
            % Recursive if button == 1.
            cursor_root2_button_Callback(hObject, eventdata, handles);
            
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
            % Gets the time, potential, threshold and the span, factor,
            % spike, trough, burst, percent settings.
            time        = handles.time;
            potential   = handles.root3;
            span        = handles.span;
            factor      = handles.factor;
            spike       = handles.spike3;
            trough      = handles.trough3;
            burst       = handles.burst3;
            percent     = handles.percent3;
            set(handles.thresh_root3_edit, 'String', y);
            handles.threshold3 = str2double(get(handles.thresh_root3_edit, 'String'));
            % Creates the root 3 object.
            ro = root(time, potential, handles.threshold3);
            % Makes axes5 the current axes.
            axes(ax);
            % Clears the current axes by finding all object on the plot
            % with the following prooperties and deletes them.
            del_items = findobj(ax, 'Color', 'red', '-or', 'Color', 'blue',...
                '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
                'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
            delete(del_items);
            % Operations that locates the bursts.
            ro.bandpass(handles.filtOrder, handles.sampFrequency, handles.passFrequency);
            ro.downsample(factor);
            ro.filterData(span);
            ro.aboveThreshold;
            ro.isBurst(spike, trough, burst);
            [handles.root3Duration, handles.root3Count] = ro.averageDuration;
            handles.root3Period = ro.averagePeriod;
            amp = ro.averageAmplitude(baseline);
            handles.root3Amp = amp - baseline;
            ro.plotMarkers;
            handles.line3 = root.plotAmplitude(amp);
            ro.findDeletion(percent, amp, handles.root3Period);
            % Sets the values of the root 3 output edit boxes to the results
            % obtained by the operations above.
            set(handles.root3_count_edit, 'String', handles.root3Count);
            set(handles.root3_avg_dur_edit, 'String', handles.root3Duration);
            set(handles.root3_avg_per_edit, 'String', handles.root3Period);
            set(handles.root3_avg_amp_edit, 'String', handles.root3Amp);
            % Gets the *Onset and *Offset arrays used to calculate the time
            % difference between two sets of data and polar plots. Stores
            % these arrays onto fields on the GUI handles structure.
            [rootOnset3, rootOffset3] = ro.returnBurstInfo;
            handles.rootOnset3 = rootOnset3';
            handles.rootOffset3 = rootOffset3';
            % Updates the handles structure.
            guidata(hObject, handles);
            % Recursive if button == 1.
            cursor_root3_button_Callback(hObject, eventdata, handles);
    end
    
end

set(handles.instructions_edit, 'String', '');