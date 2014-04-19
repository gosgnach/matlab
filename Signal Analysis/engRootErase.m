function engRootErase( hObject, handles, mm, ax, baseline, identity, percent )
% engRootManualMode is the function that plots and performs the
% computations based on user clicks for onset and offsets of bursts.
%
% INPUT VARIABLES ---------------------------------------------------------
% NAME              TYPE            DESCRIPTION
%
% hObject           double          Handles of the GUI figure.
% handles           struct          The stucture of the GUI to store
%                                     variables.
% mm                object          Object of the cel or root sub-classes
%                                     of signalanalysis.
% ax                double          Handles of the axes to erase a burst
%                                     on.
% baseline          double          Baseline of the root plots.
% identity          double          Determines which button manual mode was
%                                     called from.
%                                     Cell   ---> 0
%                                     Root 1 ---> 1
%                                     Root 2 ---> 2
%                                     Root 3 ---> 3
% percent           double          Percent threshold setting used in the
%                                     findDeletinons method of
%                                     signalanalysis.
%
% -------------------------------------------------------------------------
%
% OPERATION - User presses Erase button in the eng GUI to choose a burst to
% erase. Once erase button is pressed, a cursor will appeear, move mouse to
% set cursor crosshairs on a burst to delete. WARNING: CROSSHAIRS MUST
% BETWEEN THE ONSET AND OFFSET OF THE BURST TO DELETE. Left click while
% crosshair is on burst to delete that burst. Results will automatically
% update to match the new plot. Right click to exit erase mode.

% Brings up cursor on the figure.
[x, y, button] = ginput(1);

% Only deletes burst if left mouse button is pressed. Otherwise does
% nothing.
if (button == 1)

    % Deletes the burst through the deleteBurst method in signalanalysis.
    goAhead = mm.deleteBurst(x);
    
    % goAhead from deleteBurst method in signalanalysis allow code to
    % continue if 1, elseif returns an error and prompts user to try again.
    if (goAhead == 1)
        % Clears the current axes by finding all object on the plot
        % with the following prooperties and deletes them.
        del_items = findobj(ax, 'Color', 'red', '-or', 'Color', 'blue',...
            '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
            'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
        delete(del_items);

        % Switch block to determine which cursor button it was called from. 
        % Case 0 ---> cell.
        % Case 1 ---> root 1.
        % Case 3 ---> root 2.
        switch identity

            % Case 0 for cell data.
            case 0
                % Gets burst duration and burst count from averageDuration
                % method in signalanalysis.
                [handles.cellDuration, handles.cellCount] = mm.averageDuration;
                % Gets burst period from averagePeriod method in
                % signalanalysis
                handles.cellPeriod = mm.averagePeriod;
                % Plots the markers.
                mm.plotMarkers;
                % Sets the edit boxes to display to result values.
                set(handles.cell_count_edit, 'String', handles.cellCount);
                set(handles.cell_avg_dur_edit, 'String', handles.cellDuration);
                set(handles.cell_avg_per_edit, 'String', handles.cellPeriod);
                % Creates or refreshes the *Onset and *Offset fields in the
                % handles structure of the GUI.
                [cellOnset, cellOffset] = mm.returnBurstInfo;
                handles.cellOnset = cellOnset;
                handles.cellOffset = cellOffset;

            % Case 1 for root 1 data.   
            case 1
                % Gets burst duration and burst count from averageDuration
                % method in signalanalysis.
                [handles.root1Duration, handles.root1Count] = mm.averageDuration;
                % Gets amp value that is referenced from 0 from
                % averageAmplitude method in signalanalysis.
                amp = mm.averageAmplitude(baseline);
                % Gets burst period from averagePeriod method in
                % signalanalysis
                handles.root1Period = mm.averagePeriod;
                % True amplitude is amp subtract baseline
                handles.root1Amp = amp - baseline;
                % Plots the markers.
                mm.plotMarkers;
                handles.line1 = root.plotAmplitude(amp);
                % Finds deletions from the findDeletion method in
                % signalanalysis.
                mm.findDeletion(percent, amp, handles.root1Period);
                % Sets the edit boxes to display to result values.
                set(handles.root1_count_edit, 'String', handles.root1Count);
                set(handles.root1_avg_dur_edit, 'String', handles.root1Duration);
                set(handles.root1_avg_per_edit, 'String', handles.root1Period);
                set(handles.root1_avg_amp_edit, 'String', handles.root1Amp);
                % Creates or refreshes the *Onset and *Offset fields in the
                % handles structure of the GUI.
                [handles.rootOnset1, handles.rootOffset1] = mm.returnBurstInfo;

            % Case 2 for root 2 data.    
            case 2
                % Gets burst duration and burst count from averageDuration
                % method in signalanalysis.
                [handles.root2Duration, handles.root2Count] = mm.averageDuration;
                % Gets amp value that is referenced from 0 from
                % averageAmplitude method in signalanalysis.
                amp = mm.averageAmplitude(baseline);
                % Gets burst period from averagePeriod method in
                % signalanalysis
                handles.root2Period = mm.averagePeriod;
                % True amplitude is amp subtract baseline
                handles.root2Amp = amp - baseline;
                % Plots the markers.
                mm.plotMarkers;
                handles.line2 = root.plotAmplitude(amp);
                % Finds deletions from the findDeletion method in
                % signalanalysis.
                mm.findDeletion(percent, amp, handles.root2Period);
                % Sets the edit boxes to display to result values.
                set(handles.root2_count_edit, 'String', handles.root2Count);
                set(handles.root2_avg_dur_edit, 'String', handles.root2Duration);
                set(handles.root2_avg_per_edit, 'String', handles.root2Period);
                set(handles.root2_avg_amp_edit, 'String', handles.root2Amp);
                % Creates or refreshes the *Onset and *Offset fields in the
                % handles structure of the GUI.
                [handles.rootOnset2, handles.rootOffset2] = mm.returnBurstInfo;
                
            % Case 3 for root 3 data.    
            case 3
                % Gets burst duration and burst count from averageDuration
                % method in signalanalysis.
                [handles.root3Duration, handles.root3Count] = mm.averageDuration;
                % Gets amp value that is referenced from 0 from
                % averageAmplitude method in signalanalysis.
                amp = mm.averageAmplitude(baseline);
                % Gets burst period from averagePeriod method in
                % signalanalysis
                handles.root3Period = mm.averagePeriod;
                % True amplitude is amp subtract baseline
                handles.root3Amp = amp - baseline;
                % Plots the markers.
                mm.plotMarkers;
                handles.line3 = root.plotAmplitude(amp);
                % Finds deletions from the findDeletion method in
                % signalanalysis.
                mm.findDeletion(percent, amp, handles.root3Period);
                % Sets the edit boxes to display to result values.
                set(handles.root3_count_edit, 'String', handles.root3Count);
                set(handles.root3_avg_dur_edit, 'String', handles.root3Duration);
                set(handles.root3_avg_per_edit, 'String', handles.root3Period);
                set(handles.root3_avg_amp_edit, 'String', handles.root3Amp);
                % Creates or refreshes the *Onset and *Offset fields in the
                % handles structure of the GUI.
                [handles.rootOnset3, handles.rootOffset3] = mm.returnBurstInfo;

        end
        % Updates the GUI handles structure.
        guidata(hObject, handles);
        % Recursive if left mouse button is pressed.
        engRootErase(hObject, handles, mm, ax, baseline, identity, percent);  
    
    elseif (goAhead == 0)
         msg = errordlg('ERROR: Please select between onset and offset of burst.');
         waitfor (msg);
         engRootErase(hObject, handles, mm, ax, baseline, identity, percent);
    end
    
end

