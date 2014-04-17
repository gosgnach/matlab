function varargout = eng(varargin)
% ENG is a GUI for signal analysis. Type eng in the command window to run
% the program.
%
% Author: Henry Kao
% Purpose: Dr. Gosgnach's University of Alberta Labortatory.
% Date: January - April 2014
%
% ENG MATLAB code for eng.fig
%      ENG, by itself, creates a new ENG or raises the existing
%      singleton*.
%
%      H = ENG returns the handle to a new ENG or the handle to
%      the existing singleton*.
%
%      ENG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENG.M with the given input arguments.
%
%      ENG('Property','Value',...) creates a new ENG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eng_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eng_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eng

% Last Modified by GUIDE v2.5 18-Mar-2014 15:44:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eng_OpeningFcn, ...
                   'gui_OutputFcn',  @eng_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before eng is made visible.
function eng_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eng (see VARARGIN)

% Choose default command line output for eng
    handles.output = hObject;
% Update handles structure
    guidata(hObject, handles);
    setappdata(0, 'defaultHandles', handles)
    initializeVar;
% UIWAIT makes eng wait for user response (see UIRESUME)
% uiwait(handles.eng);
    
end

% --- Outputs from this function are returned to the command line.
function varargout = eng_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.output;
end

% --------------------------------------------------------------------
% File menu.
function file_menu_Callback(hObject, eventdata, handles)
end

% --------------------------------------------------------------------
% Sub-menu under file. Opens File Import GUI to pick file and load raw
% data.
function file_load_menu_Callback(hObject, eventdata, handles)
    engFileImport;
end

% --------------------------------------------------------------------
% Sub-menu under file. Opens existing saved GUI to continue work. File to
% open must be a .fig file.
function file_open_menu_Callback(hObject, eventdata, handles)
    % Opens a browse file ui to locate the file you want to open.
    [fileName, pathName] = uigetfile('*.fig');
    open(fullfile(pathName, fileName));
    fprintf('File %s%s has been Opened.\n', pathName, fileName);    
end

% --------------------------------------------------------------------
% Sub-menu under file. Allow you to save current GUI figure as .fig, .mat,
% .eps, and .emf. 

% Save as .fig to be able to reopen the GUI at a later time to continue
% work.

% Save as .mat to get the handles structure to the GUI. Handles structure
% constains almost all of the info and parameters used in the GUI. Other
% data can be obtained by looking into the root of MATLAB by typing
% getappdata(0).

% Save as .eps or .emf to get able to open GUI in a vector bases drawing
% program such as CorelDraw or Adobe Illustrator. Data used in GUI will not
% be save. Only the physical appearance of the GUI at save time will be
% saved.
function file_saveas_menu_Callback(hObject, eventdata, handles)
    % Opens ui to enter a save location.
    [fileName, pathName] = uiputfile({'*.fig', 'MATLAB Figure (*.fig)';...
        '*.mat', 'MATLAB File (*.mat)';...
        '*.eps', 'Encapsulated PostScript (*.eps)';...
        '*.emf', 'Enhanced Metafile (*.emf)'});
    handles.file = fullfile(pathName, fileName);
    
    % Determines which file format was specified by user and executes
    % corresponding save fuction.
    search1 = strfind(fileName, '.mat');
    search2 = strfind(fileName, '.fig');
    search3 = strfind(fileName, '.eps');
    search4 = strfind(fileName, '.emf');
    notEmpty = (~isempty(search3)) || (~isempty(search4));
    
    if (~isempty(search1))
       save(handles.file);
       fprintf('Current work saved as, %s, in directory, %s\n',...
           fileName, pathName);
       
    elseif (notEmpty == 1)
       saveas(handles.eng, handles.file);
       fprintf('Current work saved as, %s, in directory, %s\n',...
           fileName, pathName);
       
    elseif (~isempty(search2))
        hgsave(handles.eng, handles.file);
        fprintf('Current work saved as, %s, in directory, %s\n',...
            fileName, pathName);
    else
        fprintf('ERROR: Could not save file');
       return
    end
    
    guidata(hObject, handles);
    
end

% --------------------------------------------------------------------
% Figure Menu
function figure_menu_Callback(hObject, eventdata, handles)
end

% --------------------------------------------------------------------
% Sub-menu of figure. Opens a plot selection GUI to get user to input 2
% plots to compare. Opens a figure of a polar plot.
function figure_polar_menu_Callback(hObject, eventdata, handles)
    % Opens the plot selection GUI. User will be able to enter two plots to
    % compare.
    fig = engSelectPlots;
    % Waits for figure to close.
    waitfor(fig);
    % If user selected cancel is the plot selection GUI then function will
    % return and do noting. Otherwise if user selects OK then function will
    % continue.
    if ( getappdata(0, 'userAccept') == 0 )
        return;
        
    elseif ( getappdata(0, 'userAccept') == 1 )
        plot1 = getappdata(0, 'plot1');
        plot2 = getappdata(0, 'plot2');
        
        % Determines the reference plot. Case 1 is the uppermost plot for
        % the cell. Case 2 is the middle plot for root 1, Case 3 is the
        % bottom plot for root 2.
        switch plot1
            
            case 1
                firstPlotOnset = handles.cellOnset(:);
                firstPlotOffset = handles.cellOffset(:);
                
            case 2
                firstPlotOnset = handles.rootOnset1(:);
                firstPlotOffset = handles.rootOffset1(:);
                
            case 3
                firstPlotOnset = handles.rootOnset2(:);
                firstPlotOffset = handles.rootOffset2(:);
                
            case 4
                firstPlotOnset = handles.rootOnset3(:);
                firstPlotOffset = handles.rootOffset3(:);
                
            otherwise
                fprinf('\nInvalid plot, Please choose again.\n')
                
        end
        
        %Determines the measurement plot.
        switch plot2
            
            case 1
                secondPlotOnset = handles.cellOnset(:);
                secondPlotOffset = handles.cellOffset(:);
                
            case 2
                secondPlotOnset = handles.rootOnset1(:);
                secondPlotOffset = handles.rootOffset1(:);
                
            case 3
                secondPlotOnset = handles.rootOnset2(:);
                secondPlotOffset = handles.rootOffset2(:);
                
            case 4
                secondPlotOnset = handles.rootOnset3(:);
                secondPlotOffset = handles.rootOffset3(:);
                
            otherwise
                fprinf('\nInvalid plot, Please choose again.\n')
                
        end

        % If the number of bursts between the reference and measurement
        % plots are not equal. GUI will prompt user to select bursts from
        % reference and measurement plots manually user a cursor. Otherwise
        % if bursts are equal, then GUI will automatically start comparing
        % the two plots.
        if (numel(firstPlotOnset) ~= numel(secondPlotOnset))
            msg1 = msgbox({'Please select the bursts in the first (reference) plot using left click, then press ENTER when finished.',...
                'WARNING: NUMBER OF SELECTED BURSTS IN THE REFERENCE AND MEASUREMENT PLOTS MUST BE THE SAME.'});
            waitfor(msg1);
            [cellX, cellY] = ginput;
            msg2 = msgbox({'Please select the bursts in the second (measurement) plot using left click, then press ENTER when finished.',...
                'WARNING: NUMBER OF SELECTED BURSTS IN THE REFERENCE AND MEASUREMENT PLOTS MUST BE THE SAME.'});
            waitfor(msg2);
            [rootX, rootY] = ginput;
            cellOnsetInd = [];
            rootOnsetInd = [];
            cellOffsetInd = [];
            rootOffsetInd = [];
            for i = 1:numel(cellX)
                cellOnsetInd(end+1) = find(firstPlotOnset < cellX(i), 1, 'last');
                rootOnsetInd(end+1) = find(secondPlotOnset < rootX(i), 1, 'last');
                cellOffsetInd(end+1) = find(firstPlotOffset > cellX(i), 1, 'first');
                rootOffsetInd(end+1) = find(secondPlotOffset > rootX(i), 1, 'first');
            end
            cellOnset = firstPlotOnset(cellOnsetInd);
            rootOnset = secondPlotOnset(rootOnsetInd);
            cellOffset = firstPlotOffset(cellOffsetInd);
            rootOffset = secondPlotOffset(rootOffsetInd);
            [timeOnsetDiff, timeOnsetDiffArray] = delta(cellOnset, rootOnset);
            referencePeriod = diff(firstPlotOnset(cellOnsetInd));
            
        else
            msg3 = msgbox('Equal amount of bursts between both (reference and measurement) plots. Press O.K. to get result.');
            waitfor(msg3);
            [timeOnsetDiff, timeOnsetDiffArray] = delta(firstPlotOnset, secondPlotOnset);
            referencePeriod = diff(firstPlotOnset);
        end

        % Determines the values to be plotted on the polar plot. Coverts
        % time into radians and finds the average of all the radian and the
        % radius.
        timeOnsetDiffArray(end) = [];
        theta = (-2*pi*(timeOnsetDiffArray ./ referencePeriod)) + (pi/2);
        radius = ones(size(theta));
        yBar = mean(sin(theta));
        xBar = mean(cos(theta));
        radiusBar = [0, sqrt((xBar^2) + (yBar^2))];
        quadrant1 = ((xBar > 0) && (yBar > 0));
        quadrant2 = ((xBar < 0) && (yBar > 0));
        quadrant3 = ((xBar < 0) && (yBar < 0));
        quadrant4 = ((xBar > 0) && (yBar < 0));
        
        if (quadrant1 == 1)
            thetaBar = [0, atan(yBar/xBar)];
            angle = 90 - (thetaBar(:,2) * 180/pi);
            
        elseif (quadrant2 == 1)
            thetaBar = [0, atan(yBar/xBar) + pi];
            angle = 360 - (thetaBar(:,2) * 180/pi) + 90;
            
        elseif (quadrant3 == 1)
            thetaBar = [0, atan(yBar/xBar) + pi];
            angle = 360 - (thetaBar(:,2) * 180/pi) + 90;
            
        elseif (quadrant4 == 1)
            thetaBar = [0, atan(yBar/xBar)];
            angle = abs(thetaBar(:,2) * 180/pi) + 90;
            
        end
        
        % Creates figure 99 for the polar plot. 
        figure(99);
        polar(theta, radius, 'r*');
        hold on;
        polar(thetaBar, radiusBar, '-ob');

        % Re-labling polar plot axis.
        polarHandle = findall(gca, 'Type', 'Text');
        polarString = get(polarHandle, 'String');
        polarString(3:15) = {
            'Polar Plot'
            '90'
            '270'
            '120'
            '300'
            '150'
            '330'
            '180'
            '0'
            '210'
            '30'
            '240'
            '60'
            };
        set(polarHandle, {'String'}, polarString);
        txt = {'Reference Plot:', num2str(plot1), '',...
            'Measurement Plot:', num2str(plot2), '',...
            'Angle of vector in degrees:', num2str(angle), '',...
            'Length of vector (Maximum = 1):' num2str(radiusBar(:,2))};
        ano = annotation('textbox', [0 0.5 0 0], 'String', txt);
        set(ano, 'FitBoxToText', 'on', 'EdgeColor', 'none');
        hold off;
        
    end
end

% --------------------------------------------------------------------
% Fuction to calculate the time difference between two plots. Similar to
% the polar plot function.
function [timeOnsetDiff, timeOffsetDiff] = set_time_diff (handles)
    % Opens the plot selection GUI. User will be able to enter two plots to
    % compare.
    fig = engSelectPlots;
    % Waits for figure to close.
    waitfor(fig);
    % If user selected cancel is the plot selection GUI then function will
    % return and do noting. Otherwise if user selects OK then function will
    % continue.
    if ( getappdata(0, 'userAccept') == 0 )
        return;
    elseif ( getappdata(0, 'userAccept') == 1 )
        plot1 = getappdata(0, 'plot1');
        plot2 = getappdata(0, 'plot2');

        % Determines the reference plot. Case 1 is the uppermost plot for
        % the cell. Case 2 is the middle plot for root 1, Case 3 is the
        % bottom plot for root 2.
        switch plot1
            case 1
                firstPlotOnset = handles.cellOnset(:);
                firstPlotOffset = handles.cellOffset(:);
                
            case 2
                firstPlotOnset = handles.rootOnset1(:);
                firstPlotOffset = handles.rootOffset1(:);
                
            case 3
                firstPlotOnset = handles.rootOnset2(:);
                firstPlotOffset = handles.rootOffset2(:);
                
            case 4
                firstPlotOnset = handles.rootOnset3(:);
                firstPlotOffset = handles.rootOffset3(:);
                
            otherwise
                fprinf('\nInvalid plot, Please choose again.\n')
                
        end

        %Determines the measurement plot.
        switch plot2
            case 1
                secondPlotOnset = handles.cellOnset(:);
                secondPlotOffset = handles.cellOffset(:);
                
            case 2
                secondPlotOnset = handles.rootOnset1(:);
                secondPlotOffset = handles.rootOffset1(:);
                
            case 3
                secondPlotOnset = handles.rootOnset2(:);
                secondPlotOffset = handles.rootOffset2(:);
                
            case 4
                secondPlotOnset = handles.rootOnset3(:);
                secondPlotOffset = handles.rootOffset3(:);
                
            otherwise
                fprinf('\nInvalid plot, Please choose again.\n')
        end

        % If the number of bursts between the reference and measurement
        % plots are not equal. GUI will prompt user to select bursts from
        % reference and measurement plots manually user a cursor. Otherwise
        % if bursts are equal, then GUI will automatically start comparing
        % the two plots.
        if (numel(firstPlotOnset) ~= numel(secondPlotOnset))
            msg1 = msgbox({'Please select the bursts in the first (reference) plot using left click, then press ENTER when finished.',...
                'WARNING: NUMBER OF SELECTED BURSTS IN THE REFERENCE AND MEASUREMENT PLOTS MUST BE THE SAME.'});
            waitfor(msg1);
            [cellX, cellY] = ginput;
            msg2 = msgbox({'Please select the bursts in the second (measurement) plot using left click, then press ENTER when finished.',...
                'WARNING: NUMBER OF SELECTED BURSTS IN THE REFERENCE AND MEASUREMENT PLOTS MUST BE THE SAME.'});
            waitfor(msg2);
            [rootX, rootY] = ginput;
            cellOnsetInd = [];
            rootOnsetInd = [];
            cellOffsetInd = [];
            rootOffsetInd = [];
            for i = 1:numel(cellX)
                cellOnsetInd(end+1) = find(firstPlotOnset < cellX(i), 1, 'last');
                rootOnsetInd(end+1) = find(secondPlotOnset < rootX(i), 1, 'last');
                cellOffsetInd(end+1) = find(firstPlotOffset > cellX(i), 1, 'first');
                rootOffsetInd(end+1) = find(secondPlotOffset > rootX(i), 1, 'first');
            end
            cellOnset = firstPlotOnset(cellOnsetInd);
            rootOnset = secondPlotOnset(rootOnsetInd);
            cellOffset = firstPlotOffset(cellOffsetInd);
            rootOffset = secondPlotOffset(rootOffsetInd);
            [timeOnsetDiff, timeOnsetDiffArray] = delta(cellOnset, rootOnset);
            [timeOffsetDiff] = delta(cellOffset, rootOffset);
            
        else
            msg3 = msgbox('Equal amount of bursts between both (reference and measurement) plots. Press O.K. to get result.');
            waitfor(msg3);
            [timeOnsetDiff, timeOnsetDiffArray] = delta(firstPlotOnset, secondPlotOnset);
            [timeOffsetDiff] = delta(firstPlotOffset, secondPlotOffset);
            
        end
        
    end
    
end

% -------------------------------------------------------------------------
% PLOT/RESET BUTTON
% -------------------------------------------------------------------------
% --- Executes on button press in plot_button.
% Plot button. Press to plot the data after entering values in the file
% import window.
function plot_button_Callback(hObject, eventdata, handles)
    % defaultHandles is the handles created in the opening fuction of the
    % GUI. If plot button is pressed, then the handles will be reset to
    % defaultHandles in the engPlotButton script.
    defaultHandles = getappdata(0, 'defaultHandles');
    engPlotButton;
end

% -------------------------------------------------------------------------
% CELL INPUT PANEL BUTTONS
% -------------------------------------------------------------------------
% The following Callback fuctions have an 'identity' variable set to 0 so
% that the corresponding code for the buttons know which set of operations
% to perform. identity = 0 corresponds to the cell data set.

% --- Executes on button press in cursor_cell_button.
% Cursor button for the cell plot.
function cursor_cell_button_Callback(hObject, eventdata, handles)
    identity = 0;
    engRootCursorButton;
end

% --- Executes on button press in manual_cell_button.
% Manual button for the cell plot.
function manual_cell_button_Callback(hObject, eventdata, handles)
    identity = 0;
    engRootManualButton;
end

% --- Executes on button press in erase_cell_button.
% Erase button for the cell plot. Can erase bursts from cursor mode or
% manual mode.
function erase_cell_button_Callback(hObject, eventdata, handles)
    identity = 0;
    engRootEraseButton;
end

% --- Executes on button press in time_diff_button.
% Button to calculate the time difference between two data sets. Calls the
% set_time_diff function above.
function time_diff_button_Callback(hObject, eventdata, handles)
    % Calls set_time_diff function to get time difference values for onsets
    % and offsets.
    [handles.onsetDiff, handles.offsetDiff] = set_time_diff(handles);
    % Sets the respective edit boxes to the values obtained trough thr
    % set_time_diff function.
    set(handles.onset_diff_edit, 'String', handles.onsetDiff);
    set(handles.offset_diff_edit, 'String', handles.offsetDiff);
    % Updates handles structure.
    guidata(hObject, handles);
end

% --- Executes on button press in cell_reset_button.
% Reset button for cell plot. Resets only that data that the cell panel
% produces.
function cell_reset_button_Callback(hObject, eventdata, handles)
    identity = 0;
    engResetButtons;
end

% -------------------------------------------------------------------------
% CELL INPUT PANEL EDIT BOXES
% -------------------------------------------------------------------------
% Callback function for the cell threshold edit box in the cell input
% panel.
function thresh_cell_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates the cell threshold edit box.
function thresh_cell_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% -------------------------------------------------------------------------
% CELL OUTPUT PANEL EDIT BOXES
% -------------------------------------------------------------------------
% Callback function for the average duration edit box in cell output panel.
function cell_avg_dur_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates the average duration edit box in the cell output panel.
function cell_avg_dur_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
            get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    end
end

% Callback function for the average period edit box in cell output panel.
function cell_avg_per_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates the average period edit box in the cell output panel.
function cell_avg_per_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% Callback function for the onset difference edit box in the cell output
% panel.
function onset_diff_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates the onset difference edit box in the cell output panel.
function onset_diff_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% Callback function for the offset difference edit box in the cell output
% panel.
function offset_diff_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates the offset difference edit box in the cell output panel.
function offset_diff_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% Callback function for the cell count edit box
function cell_count_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates the cell count edit box.
function cell_count_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% -------------------------------------------------------------------------
% ROOT 1 PANEL BUTTONS
% -------------------------------------------------------------------------
% --- Executes on button press in set_root1_button.
% Set button in the root 1 input panel.
function set_root1_button_Callback(hObject, eventdata, handles)
    identity = 1;
    engRootSetButton;
end

% --- Executes on button press in cursor_root1_button.
% Cursor button for root 1 input panel.
function cursor_root1_button_Callback(hObject, eventdata, handles)
    identity = 1;
    engRootCursorButton;
end

% --- Executes on button press in manual_root1_button.
% Manual button for root 1 input panel.
function manual_root1_button_Callback(hObject, eventdata, handles)
    identity = 1;
    engRootManualButton;
end

% --- Executes on button press in erase_root1_button.
% Erase button for root 1 input panel.
function erase_root1_button_Callback(hObject, eventdata, handles)
    identity = 1;
    engRootEraseButton;
end

% --- Executes on button press in baseline1_button.
% Baseline button for root 1 input panel.
function baseline1_button_Callback(hObject, eventdata, handles)
    % Brings up cursor.
    [x, y, button] = ginput(1);
    % Executes following code if Left Mouse Click
    if (button == 1)
        try
            % Deletes previous baseline graphics object from axes.
            delete(handles.base1);
        catch err
        end
        % Sets the baseline edit box for root 1 to the y-value obtained
        % through ginput.
        set(handles.baseline1_edit, 'String', y);
        % Updates the baseline1 field in handles to the new y-value from
        % ginput.
        handles.baseline1 = str2double(get(handles.baseline1_edit, 'String'));
        hold on;
        % Updates the base1 field graphics object.
        handles.base1 = refline(0, handles.baseline1);
        % Sets base1 color to red.
        set(handles.base1, 'Color', 'r');
        hold off;
        
        % Updates GUI handles structure.
        guidata(hObject, handles);
        
    end
end

% --- Executes on button press in view_baseline1.
% View button in root 1 input panel.
function view_baseline1_Callback(hObject, eventdata, handles)
    axes(handles.axes2);
    % Re-plots base1 field graphics object to the current axes.
    handles.base1 = refline(0, handles.baseline1);
    set(handles.base1, 'Color', 'r');
end

% --- Executes on button press in root1_reset_button.
% Reset button in root 1 input panel.
function root1_reset_button_Callback(hObject, eventdata, handles)
    identity = 1;
    engResetButtons;
end

% -------------------------------------------------------------------------
% ROOT 1 PANEL EDIT BOXES
% -------------------------------------------------------------------------
% Callback function for threshold edit box in root 1 panel.
function thresh_root1_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates the threshold edit box in root 1 input panel.
function thresh_root1_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% Callback function for baseline edit box in root 1 input panel.
function baseline1_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates the baseline edit box for root 1 input panel.
function baseline1_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% -------------------------------------------------------------------------
% ROOT 1 OUTPUT PANEL EDIT BOXES
% -------------------------------------------------------------------------
% Callback for average duration edit box in root 1 output.
function root1_avg_dur_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates the average duration edit box in root 1 output.
function root1_avg_dur_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% Callback for average period edit box in root 1 output.
function root1_avg_per_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates the average period edit box in root 1 out.put
function root1_avg_per_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% Callback function for average amplitude in the root 1 output panel.
function root1_avg_amp_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates the average amplitude edit box in the root 1 panel.
function root1_avg_amp_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% Callback function for count edit box in root 1 output panel.
function root1_count_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates the count edit box for root 1 ouput panel.
function root1_count_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

%--------------------------------------------------------------------------
% ROOT 2 INPUT PANEL BUTTONS
% -------------------------------------------------------------------------
% --- Executes on button press in set_root2_button.
% Set button on the root 2 input panel.
function set_root2_button_Callback(hObject, eventdata, handles)
    identity = 2;
    engRootSetButton;
end

% --- Executes on button press in cursor_root2_button.
% Cursor button on the root 2 input panel.
function cursor_root2_button_Callback(hObject, eventdata, handles)
    identity = 2;
    engRootCursorButton;
end

% --- Executes on button press in manual_root2_button.
% Manual button on the root 2 input panel.
function manual_root2_button_Callback(hObject, eventdata, handles)
    identity = 2;
    engRootManualButton;
end

% --- Executes on button press in erase_root2_button.
% Erase button on the root 2 input panel.
function erase_root2_button_Callback(hObject, eventdata, handles)
    identity = 2;
    engRootEraseButton;
end

% --- Executes on button press in baseline2_button.
% Baseline button on the root 2 input panel.
function baseline2_button_Callback(hObject, eventdata, handles)
    % Brings up cursor.
    [x, y, button] = ginput(1);
    % Executes following code if Left Mouse Click
    if (button == 1)
        try
            % Deletes previous baseline graphics object from axes.
            delete(handles.base2)
        catch err
        end
        % Sets the baseline edit box for root 2 to the y-value obtained
        % through ginput.
        set(handles.baseline2_edit, 'String', y);
        % Updates the baseline2 field in handles to the new y-value from
        % ginput.
        handles.baseline2 = str2double(get(handles.baseline2_edit, 'String'));
        hold on;
        % Updates the base2 field graphics object.
        handles.base2 = refline(0, handles.baseline2);
        % Sets base2 color to red
        set(handles.base2, 'Color', 'r');
        hold off;
        
        % Updates the GUI handles structure.
        guidata(hObject, handles);
        
    end
end


% --- Executes on button press in view_baseline2.
% View button in root 2 input panel.
function view_baseline2_Callback(hObject, eventdata, handles)
    axes(handles.axes4);
    % Re-plots base1 field graphics object to the current axes.
    handles.base2 = refline(0, handles.baseline2);
    set(handles.base2, 'Color', 'r');
end

% --- Executes on button press in root2_reset_button.
% Reset button in root 1 input panel.
function root2_reset_button_Callback(hObject, eventdata, handles)
    identity = 2;
    engResetButtons;
end

% -------------------------------------------------------------------------
% ROOT 2 INPUT PANEL EDIT BOXES
% -------------------------------------------------------------------------
% Callback function for the threshold edit box in root 2 input panel.
function thresh_root2_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates the threshold edit box for root 2 input panel.
function thresh_root2_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% Callback function for baseline edit box in root 2 input panel.
function baseline2_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates the baseline edit box for root 2 input panel.
function baseline2_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% Callback function for the count edit box for root 2 input panel.
function root2_count_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates count edit box for root 2 input panel.
function root2_count_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% -------------------------------------------------------------------------
% ROOT 2 OUTPUT PANEL EDIT BOXES
% -------------------------------------------------------------------------
% Callback function for average duration edit box for root 2 output panel.
function root2_avg_dur_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates average duration edit box for root 2 output panel.
function root2_avg_dur_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% Callback function for average period edit box for root 2 output panel.
function root2_avg_per_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates average period edit box for root 2 ouput panel.
function root2_avg_per_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% Callback function for average amplitude edit box for root 2 output panel.
function root2_avg_amp_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
% Creates average amplitude edit box for root 2 output panel.
function root2_avg_amp_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

%--------------------------------------------------------------------------
% ROOT 3 INPUT PANEL BUTTONS
% -------------------------------------------------------------------------
% --- Executes on button press in set_root3_button.
function set_root3_button_Callback(hObject, eventdata, handles)
    identity = 3;
    engRootSetButton;
end

% --- Executes on button press in cursor_root3_button.
function cursor_root3_button_Callback(hObject, eventdata, handles)
    identity = 3;
    engRootCursorButton;
end

% --- Executes on button press in manual_root3_button.
function manual_root3_button_Callback(hObject, eventdata, handles)
    identity = 3;
    engRootManualButton;
end

% --- Executes on button press in erase_root3_button.
function erase_root3_button_Callback(hObject, eventdata, handles)
    identity = 3;
    engRootEraseButton;
end

% --- Executes on button press in baseline3_button.
function baseline3_button_Callback(hObject, eventdata, handles)
    % Brings up cursor.
    [x, y, button] = ginput(1);
    % Executes following code if Left Mouse Click
    if (button == 1)
        try
            % Deletes previous baseline graphics object from axes.
            delete(handles.base3)
        catch err
        end
        % Sets the baseline edit box for root 3 to the y-value obtained
        % through ginput.
        set(handles.baseline3_edit, 'String', y);
        % Updates the baseline2 field in handles to the new y-value from
        % ginput.
        handles.baseline3 = str2double(get(handles.baseline3_edit, 'String'));
        hold on;
        % Updates the base3 field graphics object.
        handles.base3 = refline(0, handles.baseline3);
        % Sets base2 color to red
        set(handles.base3, 'Color', 'r');
        hold off;
        
        % Updates the GUI handles structure.
        guidata(hObject, handles);
        
    end
    
end

% --- Executes on button press in root3_reset_button.
function root3_reset_button_Callback(hObject, eventdata, handles)
    identity = 3;
    engResetButtons;
end

% --- Executes on button press in view_baseline3.
function view_baseline3_Callback(hObject, eventdata, handles)
    axes(handles.axes5);
    % Re-plots base1 field graphics object to the current axes.
    handles.base3 = refline(0, handles.baseline3);
    set(handles.base3, 'Color', 'r');
end

% -------------------------------------------------------------------------
% ROOT 3 INPUT PANEL EDIT BOXES
% -------------------------------------------------------------------------
function thresh_root3_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function thresh_root3_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function baseline3_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function baseline3_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% -------------------------------------------------------------------------
% ROOT 3 OUTPUT PANEL EDIT BOXES
% -------------------------------------------------------------------------
function root3_avg_dur_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root3_avg_dur_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function root3_avg_per_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root3_avg_per_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function root3_avg_amp_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root3_avg_amp_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function root3_count_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root3_count_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% -------------------------------------------------------------------------
% SETTINGS BUTTON
% -------------------------------------------------------------------------
% --- Executes on button press in settings0_GUI_button.
% Opens a settings GUI for the cell panels.
function settings0_GUI_button_Callback(hObject, eventdata, handles)
    setGUI = engSettings0;
    waitfor(setGUI);
    handles.cellSpike = getappdata(0, 'cellSpike');
    handles.cellTrough = getappdata(0, 'cellTrough');
    handles.cellBurst = getappdata(0, 'cellBurst');
    guidata(hObject, handles);
end

% --- Executes on button press in settings1_GUI_button.
% Opens a settings GUI for the root 1 panels.
function settings1_GUI_button_Callback(hObject, eventdata, handles)
    setGUI = engSettings;
    waitfor(setGUI);
    handles.spike = getappdata(0, 'spike');
    handles.burst = getappdata(0, 'burst');
    handles.trough = getappdata(0, 'trough');
    handles.percent = getappdata(0, 'percent');
    guidata(hObject, handles);
end

% --- Executes on button press in settings2_GUI_button.
% Opens a settings GUI for the root 2 panels.
function settings2_GUI_button_Callback(hObject, eventdata, handles)
    setGUI = engSettings2;
    waitfor(setGUI);
    handles.spike2 = getappdata(0, 'spike2');
    handles.burst2 = getappdata(0, 'burst2');
    handles.trough2 = getappdata(0, 'trough2');
    handles.percent2 = getappdata(0, 'percent2');
    guidata(hObject, handles);
end

% --- Executes on button press in settings3_GUI_button.
function settings3_GUI_button_Callback(hObject, eventdata, handles)
    setGUI = engSettings3;
    waitfor(setGUI);
    handles.spike3 = getappdata(0, 'spike3');
    handles.burst3 = getappdata(0, 'burst3');
    handles.trough3 = getappdata(0, 'trough3');
    handles.percent3 = getappdata(0, 'percent3');
    guidata(hObject, handles);
end

% -------------------------------------------------------------------------
% Instructions edit box.
function instructions_edit_Callback(hObject, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function instructions_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
% -------------------------------------------------------------------------
