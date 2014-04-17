function engRootManualMode( hObject, handles, identity, mm, baseline,...
    clickHistory, evenHandle, oddHandle, yValues)
% engRootManualMode is the function that plots and performs the
% computations based on user clicks for onset and offsets of bursts.
%
% INPUT VARIABLES ---------------------------------------------------------
% NAME              TYPE            DESCRIPTION
%
% hObject           double          Handles of the GUI figure.
% handles           struct          The stucture of the GUI to store
%                                     variables.
% identity          double          Determines which button manual mode was
%                                     called from.
%                                     Cell   ---> 0
%                                     Root 1 ---> 1
%                                     Root 2 ---> 2
%                                     Root 3 ---> 3
% mm                object          Object of the cel or root sub-classes
%                                     of signalanalysis.
% baseline          double          Baseline of the root plots.
% clickHistory      double, []      Array of even and odd values. Serves as
%                                     a memory of the users consecutive 
%                                     button clicks to plot onsets and
%                                     offsets.
% evenHandle        double, 0       All clicks to plot onsets are saved as
%                                     even values in clickHistory.
% oddHandle         double, 1       All clicks to plot offsets are saved
%                                     as even values in clickHistory.
% -------------------------------------------------------------------------
%
% OPERATION - User presses manual mode button in GUI to bring up cursors.
% Bring cursor onto the plot and Left Mouse Click once to begin the manual
% plotting process. (First Left Click does not plot anything, it lets the
% program know you are starting the manual plotting process). Set cursor to
% where you want to plot a burst onset and press the 'V' button on the
% keyboard. A green cross will appear on the plot after you click 'V'. Once
% cursor reappers, move cursor to location where you want to plot burst
% offset and press 'B'. A red cross will appear on the plot after you
% click 'B'. Repeat until you have selected all onsets and offsets and then
% press ENTER for program to give you results. If you have made a mistake
% during plotting process, press the 'BACKSPACE' button on keyboard to
% delete the last plotted onset or offset. Right Click Mouse Button to exit
% the manual mode at anytime, no results will be produced.
    
    % ---------------------------------------------------------------------
    % Default values for the buttons used in manual mode. You can change
    % these values to suit your preferences.
    LEFTMOUSE = 1;
    ONSETBUTTON = 118;
    OFFSETBUTTON = 98;
    BACKSPACE = 8;
    % ---------------------------------------------------------------------
    
    % Brings up cursor on the figure.
    [x, y, button] = ginput(1);
    
    % Left Mouse click to begin the manual plotting process.
    if (button == LEFTMOUSE)
        fprintf('Manual Starting.\n');
        % Recursive.
        engRootManualMode(hObject, handles, identity, mm, baseline,...
            clickHistory,  evenHandle, oddHandle, yValues);
    end
    
    % Onset button press to perform the onset plotting operations.
    if (button == ONSETBUTTON)
        % appends an even number to clickHistory to remember to onset
        % button press.
        clickHistory(end+1) = evenHandle;
        % Adds 2 to evenHandle for next onset plot.
        evenHandle = evenHandle + 2;
        % Calls addBurstOnset method in signalanalysis.
        mm.addBurstOnset(x, y);
        yValues(end + 1) = y;
        % Recursive.
        engRootManualMode(hObject, handles, identity, mm, baseline,...
            clickHistory,  evenHandle, oddHandle, yValues);
    
    % Offset button press to perform the offset plotting operations.
    elseif (button == OFFSETBUTTON)
        % appends an odd number to clickHistory to remember to offset
        % button press.
        clickHistory(end+1) = oddHandle;
        % Adds 2 to oddHandle for next offset plot.
        oddHandle = oddHandle + 2;
        % Calls addBurstOffset method in signalanalysis.
        mm.addBurstOffset(x, y);
        yValues(end + 1) = y;
        % Recursive.
        engRootManualMode(hObject, handles, identity, mm, baseline,...
            clickHistory,  evenHandle, oddHandle, yValues);
        
    % Backspace press to delete previouslt plotted onset or offset.    
    elseif (button == BACKSPACE)
        % If clickHistory is not empty, meaning that there are onsets and
        % offsets plotted, it will delete the previously plotted onset or
        % offset.
        
        if (~isempty(clickHistory))
            % Calls deleteBurstMarker method in signalanalysis.
            mm.deleteBurstMarker(clickHistory);
            % Removes the place holder for onset or offset from the end of
            % clickHistory
            clickHistory(end) = [];
            % Recursive.
            engRootManualMode(hObject, handles, identity, mm, baseline,...
                clickHistory,  evenHandle, oddHandle, yValues);
        end
        
    % If button is empty (ENTER key press), it will return the results.
    elseif (isempty(button))
        switch identity
            % Case 0 for cell.
            case 0
                % Gets burst duration and burst count from averageDuration
                % method in signalanalysis.
                [handles.cellDuration, handles.cellCount] = mm.averageDuration;
                % Gets burst period from averagePeriod method in
                % signalanalysis
                handles.cellPeriod = mm.averagePeriod;
                % Sets the edit boxes to display to result values.
                set(handles.cell_count_edit, 'String', handles.cellCount);
                set(handles.cell_avg_dur_edit, 'String', handles.cellDuration);
                set(handles.cell_avg_per_edit, 'String', handles.cellPeriod);
                % Creates or refreshes the *Onset and *Offset fields in the
                % handles structure of the GUI.
                [handles.cellOnset, handles.cellOffset] = mm.returnBurstInfo;
                
                threshold = str2double(get(handles.thresh_cell_edit, 'String'));
                if(isnan(threshold))
                    set(handles.thresh_cell_edit, 'String', mean(yValues));
                    hold on
                    refline(0, mean(yValues));
                    hold off
                end

            % Case 1 for root 1
            case 1
                % Try-catch block trys to find line1 (average amplitude
                % graphic object for root 1) in the handles structure, if
                % exists, removes line1 object from axes, otherwise does
                % nothing.
                try
                    hold on;
                    delete(handles.line1);
                    hold off;
                catch err
                end
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
                % Refreshes the amplitude graphics object in handles.
                handles.line1 = mm.plotAmplitude(amp);
                % Sets the edit boxes to display to result values.
                set(handles.root1_count_edit, 'String', handles.root1Count);
                set(handles.root1_avg_dur_edit, 'String', handles.root1Duration);
                set(handles.root1_avg_per_edit, 'String', handles.root1Period);
                set(handles.root1_avg_amp_edit, 'String', handles.root1Amp);
                % Creates or refreshes the *Onset and *Offset fields in the
                % handles structure of the GUI.
                [rootOnset1, rootOffset1] = mm.returnBurstInfo;
                handles.rootOnset1 = rootOnset1;
                handles.rootOffset1 = rootOffset1;
                
                threshold = str2double(get(handles.thresh_root1_edit, 'String'));
                if(isnan(threshold))
                    set(handles.thresh_root1_edit, 'String', mean(yValues));
                    hold on
                    refline(0, mean(yValues));
                    hold off
                end
                
            case 2
                % Try-catch block trys to find line2 (average amplitude
                % graphic object for root 2) in the handles structure, if
                % exists, removes line2 object from axes, otherwise does
                % nothing.
                try
                    delete(handles.line2);
                catch err
                end
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
                % Refreshes the amplitude graphics object in handles.
                handles.line2 = mm.plotAmplitude(amp);
                % Sets the edit boxes to display to result values. 
                set(handles.root2_count_edit, 'String', handles.root2Count);
                set(handles.root2_avg_dur_edit, 'String', handles.root2Duration);
                set(handles.root2_avg_per_edit, 'String', handles.root2Period);
                set(handles.root2_avg_amp_edit, 'String', handles.root2Amp);
                [rootOnset2, rootOffset2] = mm.returnBurstInfo;
                % Creates or refreshes the *Onset and *Offset fields in the
                % handles structure of the GUI.
                handles.rootOnset2 = rootOnset2;
                handles.rootOffset2 = rootOffset2;
                
                threshold = str2double(get(handles.thresh_root2_edit, 'String'));
                if(isnan(threshold))
                    set(handles.thresh_root2_edit, 'String', mean(yValues));
                    hold on
                    refline(0, mean(yValues));
                    hold off
                end
                
            case 3
                % Try-catch block trys to find line3 (average amplitude
                % graphic object for root 3) in the handles structure, if
                % exists, removes line2 object from axes, otherwise does
                % nothing.
                try
                    delete(handles.line3);
                catch err
                end
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
                % Refreshes the amplitude graphics object in handles.
                handles.line3 = mm.plotAmplitude(amp);
                % Sets the edit boxes to display to result values. 
                set(handles.root3_count_edit, 'String', handles.root3Count);
                set(handles.root3_avg_dur_edit, 'String', handles.root3Duration);
                set(handles.root3_avg_per_edit, 'String', handles.root3Period);
                set(handles.root3_avg_amp_edit, 'String', handles.root3Amp);
                [rootOnset3, rootOffset3] = mm.returnBurstInfo;
                % Creates or refreshes the *Onset and *Offset fields in the
                % handles structure of the GUI.
                handles.rootOnset3 = rootOnset3;
                handles.rootOffset3 = rootOffset3;
                
                threshold = str2double(get(handles.thresh_root3_edit, 'String'));
                if(isnan(threshold))
                    set(handles.thresh_root3_edit, 'String', mean(yValues));
                    hold on
                    refline(0, mean(yValues));
                    hold off
                end
               
        end
        
        % Updates GUI handles structure.
        guidata(hObject, handles);
        
    % Manual canceled.    
    else
        fprintf('Manual Canceled.\n');
        
    end
    
end



