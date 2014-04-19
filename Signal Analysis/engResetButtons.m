% Switch block to determine which cursor button it was called from. 
% Case 0 ---> cell.
% Case 1 ---> root 1.
% Case 2 ---> root 2.
% Case 3 ---> root 3.
switch identity
    
    %Case 0 for cell.
    case 0
        % -----------------------------------------------------------------
        % Resets only the values obtained through the cell panels to the
        % state when plot button was pressed. Root 1 and root 2 will remain
        % unchanged.
        % -----------------------------------------------------------------
        disp('Reseting Cell Data...');
        
        % Removes the threshold0 field (threshold for the cell data) if it
        % exists in the handles structure.
        if(isfield(handles, 'threshold0'))
            handles = rmfield(handles, 'threshold0');
        end
        
        % Removes the cellOnset field (values of all burst onsets in the
        % cell data set) if exists in the handles structure.
        if(isfield(handles, 'cellOnset'))
            handles = rmfield(handles, 'cellOnset');
        end
        
        % Removes the cellOffset field (values of all offsets in the cell
        % data set) if exists in the handles structure.
        if(isfield(handles, 'cellOffset'))
            handles = rmfield(handles, 'cellOffset');
        end
        
        % Removes the cellDuration field (value for the average duration of
        % a cell burst) if exists from the handles structure.
        if(isfield(handles, 'cellDuration'))
            handles = rmfield(handles, 'cellDuration');
        end
        
        % Removes the cellCount field (value for number of cell bursts) if
        % exists from the handles structure.
        if(isfield(handles, 'cellCount'))
            handles = rmfield(handles, 'cellCount');
        end
        
        % Removes the cellPeriod field (value for average period between
        % cell bursts) if exists from the handles structure.
        if(isfield(handles, 'cellPeriod'))
            handles = rmfield(handles, 'cellPeriod');
        end
        
        % Removes the onsetDiff field (value of time difference between two
        % sets of onsets) if exists from the handles structure.
        if(isfield(handles, 'onsetDiff'))
            handles = rmfield(handles, 'onsetDiff');
        end
        
        % Removes the offsetDiff field (value of time difference between
        % two sets of offsets) of exists from the handles structure.
        if(isfield(handles, 'offsetDiff'))
            handles = rmfield(handles, 'offsetDiff');
        end
        
        % Resets the values of the edit boxes in the cell input and output
        % panels to nothing.
        set(handles.thresh_cell_edit, 'String', '');
        set(handles.cell_count_edit, 'String', '');
        set(handles.cell_avg_dur_edit, 'String', '');
        set(handles.cell_avg_per_edit, 'String', '');
        set(handles.onset_diff_edit, 'String', '');
        set(handles.offset_diff_edit, 'String', '');
        
        % Removes all graphics onjects from the cell plot except that of
        % the cell data.
        axes(handles.axes3);
        del_items = findobj(handles.axes3, 'Color', 'red', '-or', 'Color', 'blue',...
            '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
            'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
        delete(del_items);
        
        % Updates GUI handles structure.
        guidata(hObject, handles);
        
    % Case 1 for root 1.    
    case 1
        % -----------------------------------------------------------------
        % Resets only the values obtained through the root 1 panels to the
        % state when plot button was pressed. Cell and root 2 will remain
        % unchanged.
        % -----------------------------------------------------------------
        disp('Reseting Root 1 Data...');
        
        % Removes the threshold1 field (threshold for the root 1 data) if
        % it exists in the handles structure.
        if(isfield(handles, 'threshold1'))
            handles = rmfield(handles, 'threshold1');
        end
        
        % Removes the baseline1 field (values for the baseline for root 1)
        % if exists from the handles structure.
        if(isfield(handles, 'baseline1'))
            handles = rmfield(handles, 'baseline1');
        end
        
        % Removes the base1 field (graphics object for baseline1) if exists
        % from the handles structure.
        if(isfield(handles, 'base1'))
            handles = rmfield(handles, 'base1');
        end
        
        % Removes the line1 field (graphics object for root 1 amplitude) if
        % exists from the handles structure.
        if(isfield(handles, 'line1'))
            handles = rmfield(handles, 'line1');
        end
        
        % Removes the rootOnset1 field (values of all onsets in the root
        % 1 data set) if exists in the handles structure.
        if(isfield(handles, 'rootOnset1'))
            handles = rmfield(handles, 'rootOnset1');
        end
        
        % Removes the rootOffset1 field (values of all offsets in the root
        % 1 data set) if exists in the handles structure.
        if(isfield(handles, 'rootOffset1'))
            handles = rmfield(handles, 'rootOffset1');
        end
        
        % Removes the root1Duration field (value for the average duration
        % of a root 1 burst) if exists from the handles structure.
        if(isfield(handles, 'root1Duration'))
            handles = rmfield(handles, 'root1Duration');
        end
        
        % Removes the root1Count field (value for number of root 1 bursts)
        % if exists from the handles structure.
        if(isfield(handles, 'root1Count'))
            handles = rmfield(handles, 'root1Count');
        end
        
        % Removes the root1Period field (value for average period between
        % root 1 bursts) if exists from the handles structure.
        if(isfield(handles, 'root1Period'))
            handles = rmfield(handles, 'root1Period');
        end
        
        % Removes the root1Amp field (values for the average amplitude of
        % root 1 data) if exists from the handles structure.
        if(isfield(handles, 'root1Amp'))
            handles = rmfield(handles, 'root1Amp');
        end
        
        % Resets the values of the edit boxes in the root 1 input and
        % output panels to nothing.
        set(handles.baseline1_edit, 'String', '');
        set(handles.thresh_root1_edit, 'String', '');
        set(handles.root1_count_edit, 'String', '');
        set(handles.root1_avg_dur_edit, 'String', '');
        set(handles.root1_avg_per_edit, 'String', '');
        set(handles.root1_avg_amp_edit, 'String', '');
        set(handles.thresh_root2_edit, 'String', '');
        set(handles.root1_count_edit, 'String', '');
        threshold1 = str2double(get(handles.thresh_root1_edit, 'String'));
        
        % Removes all graphics onjects from the root 1 plot except that of
        % the root 1 data.
        axes(handles.axes2);
        del_items = findobj(handles.axes2, 'Color', 'red', '-or', 'Color', 'blue',...
            '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
            'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
        delete(del_items);
        
        % Updates the GUI handles structure.
        guidata(hObject, handles);
    
     % Case 2 for root 2.
    case 2
        % -----------------------------------------------------------------
        % Resets only the values obtained through the root 2 panels to the
        % state when plot button was pressed. Cell and root 1 will remain
        % unchanged.
        % -----------------------------------------------------------------
        disp('Reseting Root 2 Data...');
       
        % Removes the threshold2 field (threshold for the root 2 data) if
        % it exists in the handles structure.
        if(isfield(handles, 'threshold2'))
            handles = rmfield(handles, 'threshold2');
        end
        
        % Removes the baseline2 field (values for the baseline for root 2)
        % if exists from the handles structure.
        if(isfield(handles, 'baseline2'))
            handles = rmfield(handles, 'baseline2');
        end
        
        % Removes the base2 field (graphics object for baseline2) if exists
        % from the handles structure.
        if(isfield(handles, 'base2'))
            handles = rmfield(handles, 'base2');
        end
        
        % Removes the line2 field (graphics object for root 2 amplitude) if
        % exists from the handles structure.
        if(isfield(handles, 'line2'))
            handles = rmfield(handles, 'line2');
        end
        
        % Removes the rootOnset2 field (values of all onsets in the root
        % 2 data set) if exists in the handles structure.
        if(isfield(handles, 'rootOnset2'))
            handles = rmfield(handles, 'rootOnset2');
        end
        
        % Removes the rootOffset2 field (values of all offsets in the root
        % 2 data set) if exists in the handles structure.
        if(isfield(handles, 'rootOffset2'))
            handles = rmfield(handles, 'rootOffset2');
        end
        
        % Removes the root2Duration field (value for the average duration
        % of a root 2 burst) if exists from the handles structure.
        if(isfield(handles, 'root2Duration'))
            handles = rmfield(handles, 'root2Duration');
        end
        
        % Removes the root2Count field (value for number of root 2 bursts)
        % if exists from the handles structure.
        if(isfield(handles, 'root2Count'))
            handles = rmfield(handles, 'root2Count');
        end
        
        % Removes the root2Period field (value for average period between
        % root 2 bursts) if exists from the handles structure.
        if(isfield(handles, 'root2Period'))
            handles = rmfield(handles, 'root2Period');
        end
        
        % Removes the root2Amp field (values for the average amplitude of
        % root 2 data) if exists from the handles structure.
        if(isfield(handles, 'root2Amp'))
            handles = rmfield(handles, 'root2Amp');
        end
        
        % Resets the values of the edit boxes in the root 2 input and
        % output panels to nothing.
        set(handles.thresh_root2_edit, 'String', '');
        set(handles.baseline2_edit, 'String', '');
        set(handles.root2_count_edit, 'String', '');
        set(handles.root2_avg_dur_edit, 'String', '');
        set(handles.root2_avg_per_edit, 'String', '');
        set(handles.root2_avg_amp_edit, 'String', '');
        set(handles.root2_count_edit, 'String', '');
        threshold2 = str2double(get(handles.thresh_root2_edit, 'String'));
        
        % Removes all graphics onjects from the root 2 plot except that of
        % the root 2 data.
        axes(handles.axes4);
        del_items = findobj(handles.axes4, 'Color', 'red', '-or', 'Color', 'blue',...
            '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
            'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
        delete(del_items);
        
        % Updates the GUI handles structure.
        guidata(hObject, handles);
        
    % Case 3 for root 3.
    case 3
        % -----------------------------------------------------------------
        % Resets only the values obtained through the root 3 panels to the
        % state when plot button was pressed. Cell and root 1 will remain
        % unchanged.
        % -----------------------------------------------------------------
        disp('Reseting Root 3 Data...');
       
        % Removes the threshold3 field (threshold for the root 3 data) if
        % it exists in the handles structure.
        if(isfield(handles, 'threshold3'))
            handles = rmfield(handles, 'threshold3');
        end
        
        % Removes the baseline3 field (values for the baseline for root 3)
        % if exists from the handles structure.
        if(isfield(handles, 'baseline3'))
            handles = rmfield(handles, 'baseline3');
        end
        
        % Removes the base3 field (graphics object for baseline3) if exists
        % from the handles structure.
        if(isfield(handles, 'base3'))
            handles = rmfield(handles, 'base3');
        end
        
        % Removes the line3 field (graphics object for root 3 amplitude) if
        % exists from the handles structure.
        if(isfield(handles, 'line3'))
            handles = rmfield(handles, 'line3');
        end
        
        % Removes the rootOnset3 field (values of all onsets in the root
        % 3 data set) if exists in the handles structure.
        if(isfield(handles, 'rootOnset3'))
            handles = rmfield(handles, 'rootOnset3');
        end
        
        % Removes the rootOffset3 field (values of all offsets in the root
        % 3 data set) if exists in the handles structure.
        if(isfield(handles, 'rootOffset3'))
            handles = rmfield(handles, 'rootOffset3');
        end
        
        % Removes the root3Duration field (value for the average duration
        % of a root 3 burst) if exists from the handles structure.
        if(isfield(handles, 'root3Duration'))
            handles = rmfield(handles, 'root3Duration');
        end
        
        % Removes the root2Count field (value for number of root 3 bursts)
        % if exists from the handles structure.
        if(isfield(handles, 'root3Count'))
            handles = rmfield(handles, 'root3Count');
        end
        
        % Removes the root2Period field (value for average period between
        % root 3 bursts) if exists from the handles structure.
        if(isfield(handles, 'root3Period'))
            handles = rmfield(handles, 'root3Period');
        end
        
        % Removes the root3Amp field (values for the average amplitude of
        % root 3 data) if exists from the handles structure.
        if(isfield(handles, 'root3Amp'))
            handles = rmfield(handles, 'root3Amp');
        end
        
        % Resets the values of the edit boxes in the root 3 input and
        % output panels to nothing.
        set(handles.thresh_root3_edit, 'String', '');
        set(handles.baseline3_edit, 'String', '');
        set(handles.root3_count_edit, 'String', '');
        set(handles.root3_avg_dur_edit, 'String', '');
        set(handles.root3_avg_per_edit, 'String', '');
        set(handles.root3_avg_amp_edit, 'String', '');
        set(handles.root3_count_edit, 'String', '');
        threshold3 = str2double(get(handles.thresh_root3_edit, 'String'));
        
        % Removes all graphics onjects from the root 3 plot except that of
        % the root 3 data.
        axes(handles.axes5);
        del_items = findobj(handles.axes5, 'Color', 'red', '-or', 'Color', 'blue',...
            '-or', 'Color', 'green', '-or', 'Color', 'm', '-or', 'Marker', '>', '-or',...
            'Marker', '<', '-or', 'Marker', '+', '-or', 'Marker', 's');
        delete(del_items);
        
        % Updates the GUI handles structure.
        guidata(hObject, handles);
        
end


% Re-links the axes together.
warning OFF;
ax(1) = handles.axes2;
ax(2) = handles.axes3;
ax(4) = handles.axes4;
ax(5) = handles.axes5;
linkaxes(ax, 'x');