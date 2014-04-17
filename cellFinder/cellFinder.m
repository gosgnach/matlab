function varargout = cellFinder(varargin)
% CELLFINDER MATLAB code for cellFinder.fig
%      CELLFINDER, by itself, creates a new CELLFINDER or raises the existing
%      singleton*.
%
%      H = CELLFINDER returns the handle to a new CELLFINDER or the handle to
%      the existing singleton*.
%
%      CELLFINDER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELLFINDER.M with the given input arguments.
%
%      CELLFINDER('Property','Value',...) creates a new CELLFINDER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cellFinder_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cellFinder_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cellFinder

% Last Modified by GUIDE v2.5 16-Apr-2014 14:59:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cellFinder_OpeningFcn, ...
                   'gui_OutputFcn',  @cellFinder_OutputFcn, ...
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

% --- Executes just before cellFinder is made visible.
function cellFinder_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cellFinder (see VARARGIN)

% Choose default command line output for cellFinder
handles.output = hObject;
handles.origin = [0, 0];
handles.overlayColor = [1 1 1];
handles.eraseMethod = 'click';
set(handles.white_menu, 'Checked', 'on');
set(handles.click_menu, 'Checked', 'on');
set(handles.findCells_menu, 'Checked', 'on');
set(handles.panel1, 'Visible', 'on');
set(handles.panel2, 'Visible', 'off');


% UIWAIT makes cellFinder wait for user response (see UIRESUME)
% uiwait(handles.cellFinder);
set(handles.axes1, 'XTickLabel', []);
set(handles.axes1, 'XTick', []);
set(handles.axes1, 'YTickLabel', []);
set(handles.axes1, 'YTick', []);
radius = {1:200};
set(handles.mask_pop, 'String', radius);
set(handles.mask2_pop, 'String', radius);

handles.findCellsControls =...
            [...
                handles.grid4_button...
                handles.grid3_button...
                handles.grid2_button...
                handles.grid1_button...
                handles.count_edit...
                handles.count_button...
                handles.bw4_button...
                handles.bw3_button...
                handles.bw2_button...
                handles.bw1_button...
                handles.view_button...
                handles.mask_pop...
                handles.overlayEdit_button...
                handles.remove_button...
                handles.draw_button...
                handles.overlayRefine_button...
                handles.overlayNoise_button...
                handles.overlaybw_button...
                handles.refine_slider...
                handles.disk_edit...
                handles.refine_button...
                handles.noise_slider...
                handles.pixel_edit...
                handles.noise_button...
                handles.bw_slider...
                handles.threshold_edit...
                handles.bw_button...
                handles.contrast_button...
                handles.gray_button...
                handles.hist_radio...
                handles.auto_radio...
                handles.import_button...
                handles.red_radio...
                handles.green_radio...
                handles.blue_radio...
            ];
% Update handles structure
guidata(hObject, handles);
end
% --- Outputs from this function are returned to the command line.
function varargout = cellFinder_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
end

% --------------------------------------------------------------------
function imgSave_menu_Callback(hObject, eventdata, handles)
     [filename, pathname] = uiputfile({'*.mat'});
     full = fullfile(pathname, filename);
    if (isfield(handles, 'imgEdit'))
        image = handles.imgEdit;
    elseif (isfield(handles, 'imgRefined'))
        image = handles.imgRefined;
    elseif (isfield(handles, 'imgCleaned'))
        image = handles.imgCleaned;
    elseif (isfield(handles, 'imgBW'))
        image = handles.imgBW;
    else
        errordlg('No cell data to save.');
        return
    end
    save(full, 'image');
    guidata(hObject, handles);
    
    
end

% --------------------------------------------------------------------
function centroidsSave_menu_Callback(hObject, eventdata, handles)
    if(isfield(handles, 'origin'))
        xo = handles.origin(1);
        yo = handles.origin(2);
    else
        xo = 0;
        yo = 0;
    end
    
    data = [];
    
    if(isfield(handles, 'redStats'))
        xRed = zeros(numel(handles.redStats), 1);
        yRed = zeros(numel(handles.redStats), 1);
        cRed = zeros(numel(handles.redStats), 1);
        for i = 1:numel(handles.redStats)
            centroid = handles.redStats(i).Centroid;
            xRed(i) = centroid(1) - xo;
            yRed(i) = centroid(2) - yo;
        end
        cRed(:) = 1;
        data = vertcat(data, [xRed, yRed, cRed]);
    end
    
    if(isfield(handles, 'greenStats'))
        xGreen = zeros(numel(handles.greenStats), 1);
        yGreen = zeros(numel(handles.greenStats), 1);
        cGreen = zeros(numel(handles.greenStats), 1);
        for i = 1:numel(handles.greenStats)
            centroid = handles.greenStats(i).Centroid;
            xGreen(i) = centroid(1) - xo;
            yGreen(i) = centroid(2) - yo;
        end
        cGreen(:) = 2;
        data = vertcat(data, [xGreen, yGreen, cGreen]);
    end
        
    if (isfield(handles, 'blueStats'))
        xBlue = zeros(numel(handles.blueStats), 1);
        yBlue = zeros(numel(handles.blueStats), 1);
        cBlue = zeros(numel(handles.blueStats), 1);
        for i = 1:numel(handles.blueStats)
            centroid = handles.blueStats(i).Centroid;
            xBlue(i) = centroid(1) - xo;
            yBlue(i) = centroid(2) - yo;
        end
        cBlue(:) = 3;
        data = vertcat(data, [xBlue, yBlue, cBlue]);
    end
    
    if (isfield(handles, 'blueGreenStats'))
        xBlueGreen = zeros(numel(handles.blueGreenStats), 1);
        yBlueGreen = zeros(numel(handles.blueGreenStats), 1);
        cBlueGreen = zeros(numel(handles.blueGreenStats), 1);
        for i = 1:numel(handles.blueGreenStats)
            centroid = handles.blueGreenStats(i).Centroid;
            xBlueGreen(i) = centroid(1) - xo;
            yBlueGreen(i) = centroid(2) - yo;
        end
        cBlueGreen(:) = 23;
        data = vertcat(data, [xBlueGreen, yBlueGreen, cBlueGreen]);
    end
    
    if (isfield(handles, 'blueRedStats'))
        xBlueRed = zeros(numel(handles.blueRedStats), 1);
        yBlueRed = zeros(numel(handles.blueRedStats), 1);
        cBlueRed = zeros(numel(handles.blueRedStats), 1);
        for i = 1:numel(handles.blueRedStats)
            centroid = handles.blueRedStats(i).Centroid;
            xBlueRed(i) = centroid(1) - xo;
            yBlueRed(i) = centroid(2) - yo;
        end
        cBlueRed(:) =  13;
        data = vertcat(data, [xBlueRed, yBlueRed, cBlueRed]);
    end
    
    if(isfield(handles, 'greenRedStats'))
        xGreenRed = zeros(numel(handles.greenRedStats), 1);
        yGreenRed = zeros(numel(handles.greenRedStats), 1);
        cGreenRed = zeros(numel(handles.greenRedStats), 1);
        for i = 1:numel(handles.greenRedStats)
            centroid = handles.greenRedStats(i).Centroid;
            xGreenRed(i) = centroid(1) - xo;
            yGreenRed(i) = centroid(2) - yo;
        end
        cGreenRed(:) = 12;
        data = vertcat(data, [xGreenRed, yGreenRed, cGreenRed]);
    end
    
    if(isfield(handles, 'blueGreenRedStats'))
        xBlueGreenRed = zeros(numel(handles.blueGreenRedStats), 1);
        yBlueGreenRed = zeros(numel(handles.blueGreenRedStats), 1);
        cBlueGreenRed = zeros(numel(handles.blueGreenRedStats), 1);
        for i = 1:numel(handles.blueGreenRedStats)
            centroid = handles.blueGreenRedStats(i).Centroid;
            xBlueGreenRed(i) = centroid(1) - xo;
            yBlueGreenRed(i) = centroid(2) - yo;
        end
        cBlueGreenRed(:) = 123;
        data = vertcat(data, [xBlueGreenRed, yBlueGreenRed, cBlueGreenRed]);
    end
    
    [filename, pathname] = uiputfile({'*.txt'});
    full = fullfile(pathname, filename);
    dlmwrite(full, data, 'delimiter', '\t'); 

end

% --------------------------------------------------------------------
function tool_menu_Callback(hObject, eventdata, handles)
end

% --------------------------------------------------------------------
function restart_menu_Callback(hObject, eventdata, handles)
    answer = questdlg({'Are you sure you want to restart?' 'All progress will be lost!'});
    if (strcmp(answer, 'Yes'))
        close(handles.cellFinder);
        cellFinder;
    elseif (strcmp(answer, 'No'))
        return
    elseif (strcmp(answer, 'Cancel'))
        return
    end
end


% --------------------------------------------------------------------
function origin_menu_Callback(hObject, eventdata, handles)
    hbox = msgbox('Click to set new origin');
    waitfor(hbox);
    [x, y, button] = ginput(1);
    if (button == 1)
        handles.origin = [x, y];
    end
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function section_menu_Callback(hObject, eventdata, handles)
    imageSize = size(handles.img);
    grid = meshgrid(1:imageSize(2), 1:imageSize(1));
    hbox1 = msgbox('Please section the image vertically');
    waitfor(hbox1);
    yValues = [];
    vert;
    function vert
        [x, y, button] = ginput(1);
        if (button == 1)
            yValues(end + 1) = y;
            line([1, imageSize(2)], [y, y], 'Color', 'w');
            vert;
        end
    end
    hbox2 = msgbox('Please section the image horizontally');
    waitfor(hbox2);
    xValues = [];
    horz;
    function horz
        [x, y, button] = ginput(1);
        if (button == 1)
            xValues(end + 1) = x;
            line([x, x], [1, imageSize(1)], 'Color', 'w');
            horz;
        end
    end
    
    for i = 1:numel(yValues)
        grid(round(yValues(i)), :, :) = 0;
    end
    
    for j = 1:numel(xValues)
        grid(:, round(xValues(j)), :) = 0;
    end
    
    imageSize = size(handles.img);
    handles.imgGrid = imcomplement(grid);
    handles.gridRows = [0, sort(yValues, 'ascend'), imageSize(1)];
    handles.gridCols = [0, sort(xValues, 'ascend'), imageSize(2)];
    guidata(hObject, handles);
end 

% --------------------------------------------------------------------
function choose_menu_Callback(hObject, eventdata, handles)
    if(isfield(handles, 'gridRows') && isfield(handles, 'gridCols'))
        gridRows = handles.gridRows;
        gridCols = handles.gridCols;
    else
        msgbox('No Sections to choose from. Please section image first');
        return;
    end
    
    topMsg = msgbox('Please click on the most top left section of the grid you want to use.');
    waitfor(topMsg);
    [xTop, yTop, buttonTop] = ginput(1);
     if (buttonTop == 1)
         keepTopRows = (yTop < gridRows);
         keepTopRows(find(keepTopRows, 1, 'first') - 1) = 1;
         gridRows = gridRows(keepTopRows == 1);
         keepTopCols = (xTop < gridCols);
         keepTopCols(find(keepTopCols, 1, 'first') - 1) = 1;
         gridCols = gridCols(keepTopCols == 1);
     else
         return
     end
    
    botMsg = msgbox('Please click on the most bottom right section of the grid you want to use.');
    waitfor(botMsg);
    [xBot, yBot, buttonBot] = ginput(1);
    if (buttonBot == 1)
        keepBotRows = (yBot > gridRows);
        keepBotRows(find(keepBotRows, 1, 'last') + 1) = 1;
        gridRows = gridRows(keepBotRows == 1);
        keepBotCols = (xBot > gridCols);
        keepBotCols(find(keepBotCols, 1, 'last') + 1) = 1;
        gridCols = gridCols(keepBotCols == 1);
    else
        return
    end
    confirm = questdlg('Press OK to confirm secletion, or press No/Cancel to try again');
    waitfor(confirm);
    switch confirm
        case 'Yes'
            handles.gridRows = gridRows;
            handles.gridCols = gridCols;
            guidata(hObject, handles);
        case 'No'
            choose_menu_Callback(hObject, eventdata, handles)
        case 'Cancel'
            choose_menu_Callback(hObject, eventdata, handles)
    end
end

% --------------------------------------------------------------------
function invert_menu_Callback(hObject, eventdata, handles)
    if(isfield(handles, 'imgBW'))
        handles.img = imcomplement(handles.img);
        handles.imgBW = imcomplement(handles.imgBW);
        imshow(handles.imgBW);
    end
    guidata(hObject, handles)
end

% --------------------------------------------------------------------
function mode_menu_Callback(hObject, eventdata, handles)
end

% --------------------------------------------------------------------
function findCells_menu_Callback(hObject, eventdata, handles)
    cla;
    if strcmp(get(gcbo, 'Checked'),'on')
        set(gcbo, 'Checked', 'off');
    else
        set(gcbo, 'Checked', 'on');
    end
    set(handles.stuff_menu, 'Checked', 'off');
    set(handles.panel2, 'Visible', 'off');
    set(handles.panel1, 'Visible', 'on');
    set(handles.findCellsControls, 'Enable', 'on', 'Visible', 'on');
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function stuff_menu_Callback(hObject, eventdata, handles)
    cla;
    if strcmp(get(gcbo, 'Checked'),'on')
        set(gcbo, 'Checked', 'off');
    else
        set(gcbo, 'Checked', 'on');
    end
    set(handles.findCells_menu, 'Checked', 'off');
    pos = get(handles.panel1, 'Position');
    set(handles.panel1, 'Visible', 'off');
    set(handles.panel2, 'Visible', 'on');
    set(handles.panel2, 'Position', pos);
    set(handles.findCellsControls, 'Enable', 'off', 'Visible', 'off');
    if(isfield(handles, 'imgBlue') && isfield(handles, 'imgGreen'))
        handles.imgBlueGreen = handles.imgBlue & handles.imgGreen;
        black = cat(3, zeros(size(handles.imgBlue)), zeros(size(handles.imgBlue)), zeros(size(handles.imgBlue)));
    end
    if(isfield(handles, 'imgBlue') && isfield(handles, 'imgRed'))
        handles.imgBlueRed = handles.imgBlue & handles.imgRed;
        black = cat(3, zeros(size(handles.imgRed)), zeros(size(handles.imgRed)), zeros(size(handles.imgRed)));
    end
    if(isfield(handles, 'imgGreen') && isfield(handles, 'imgRed'))
        handles.imgGreenRed = handles.imgGreen & handles.imgRed;

    end
    if(isfield(handles, 'imgBlue') && isfield(handles, 'imgGreen') && isfield(handles, 'imgRed'))
        handles.imgBlueGreenRed = handles.imgBlue & handles.imgGreen & handles.imgRed;
    end
    handles.cleanAxes = getimage(handles.axes1);
    
    clc;
    
    fprintf('Blocks are counted left to right, top to bottom.\nEx.\nBlock 1\nBlock 2\nBlock 3\n...\n');

    imshow(black);
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function plotDataGUI_menu_Callback(hObject, eventdata, handles)
    plotData;
end
% --------------------------------------------------------------------
function settings_menu_Callback(hObject, eventdata, handles)
% hObject    handle to settings_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function overlayColor_menu_Callback(hObject, eventdata, handles)
% hObject    handle to overlayColor_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function white_menu_Callback(hObject, eventdata, handles)
    if strcmp(get(gcbo, 'Checked'),'on')
        set(gcbo, 'Checked', 'off');
    else
        set(gcbo, 'Checked', 'on');
    end
    set(handles.red_menu, 'Checked', 'off');
    set(handles.orange_menu, 'Checked', 'off');
    set(handles.green_menu, 'Checked', 'off');
    handles.overlayColor = [1 1 1];
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function red_menu_Callback(hObject, eventdata, handles)
    if strcmp(get(gcbo, 'Checked'),'on')
        set(gcbo, 'Checked', 'off');
    else
        set(gcbo, 'Checked', 'on');
    end
    set(handles.white_menu, 'Checked', 'off');
    set(handles.orange_menu, 'Checked', 'off');
    set(handles.green_menu, 'Checked', 'off');
    handles.overlayColor = [1 0 0];
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function orange_menu_Callback(hObject, eventdata, handles)
    if strcmp(get(gcbo, 'Checked'),'on')
        set(gcbo, 'Checked', 'off');
    else
        set(gcbo, 'Checked', 'on');
    end
    set(handles.red_menu, 'Checked', 'off');
    set(handles.white_menu, 'Checked', 'off');
    set(handles.green_menu, 'Checked', 'off');
    handles.overlayColor = [1 0.5 0];
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function green_menu_Callback(hObject, eventdata, handles)
    if strcmp(get(gcbo, 'Checked'),'on')
        set(gcbo, 'Checked', 'off');
    else
        set(gcbo, 'Checked', 'on');
    end
    set(handles.red_menu, 'Checked', 'off');
    set(handles.orange_menu, 'Checked', 'off');
    set(handles.white_menu, 'Checked', 'off');
    handles.overlayColor = [0 1 0];
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function erase_menu_Callback(hObject, eventdata, handles)
end

% --------------------------------------------------------------------
function click_menu_Callback(hObject, eventdata, handles)
    if strcmp(get(gcbo, 'Checked'),'on')
        set(gcbo, 'Checked', 'off');
    else
        set(gcbo, 'Checked', 'on');
    end
    set(handles.draw_menu, 'Checked', 'off');
    handles.eraseMethod = 'click';
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function draw_menu_Callback(hObject, eventdata, handles)
    if strcmp(get(gcbo, 'Checked'),'on')
        set(gcbo, 'Checked', 'off');
    else
        set(gcbo, 'Checked', 'on');
    end
    set(handles.click_menu, 'Checked', 'off');
    handles.eraseMethod = 'draw';
    guidata(hObject, handles);
    
end

%---------------------------------------------------------------------

% --- Executes on button press in red_radio.
function red_radio_Callback(hObject, eventdata, handles)
    set(handles.green_radio, 'Value', 0);
    set(handles.blue_radio, 'Value', 0);
    handles.imgColor = 'r';
    guidata(hObject, handles);
end

% --- Executes on button press in green_radio.
function green_radio_Callback(hObject, eventdata, handles)
    set(handles.red_radio, 'Value', 0)
    set(handles.blue_radio, 'Value', 0)
    handles.imgColor = 'b';
    guidata(hObject, handles);
end

% --- Executes on button press in blue_radio.
function blue_radio_Callback(hObject, eventdata, handles)
    set(handles.red_radio, 'Value', 0)
    set(handles.green_radio, 'Value', 0)
    handles.imgColor = 'g';
    guidata(hObject, handles);
end

% --- Executes on button press in import_button.
function import_button_Callback(hObject, eventdata, handles)
    if (isfield(handles, 'img'))
        handles = rmfield(handles, 'img');
    end
    
    if(isfield(handles, 'imgGray'))
        handles = rmfield(handles, 'imgGray');
    end
    
    if(isfield(handles, 'fig'))
        handles = rmfield(handles, 'fig');
    end
    
    if(isfield(handles, 'imgBW'))
        handles = rmfield(handles, 'imgBW');
    end
    
    if(isfield(handles, 'imgCleaned'))
        handles = rmfield(handles, 'imgCleaned');
    end
    
    if(isfield(handles, 'imgRefined'))
        handles = rmfield(handles, 'imgRefined');
    end
    
    if(isfield(handles, 'imgEdit'))
        handles = rmfield(handles, 'imgEdit');
    end

    [filename, pathname] = uigetfile({'*.tiff;*.tif'; '*.png'; '*.jpg'; '*.jpeg'});
    full = fullfile(pathname, filename);
    handles.img = imread(full);
    handles.fig = handles.img;
    axes(handles.axes1)
    dot = regexp(filename, '\.');
    switch(filename(dot+1:end))
        case {'tiff', 'tif'}
            try
                handles.img(:,:,4) = []; % Removes 4th channel from .tiff
            catch err
            end
            imshow(handles.img);
            set(handles.axes1, 'NextPlot', 'ReplaceChildren');
            guidata(hObject, handles);
        case {'png', 'jpg', 'jpeg'}
            imshow(handles.img);
            set(handles.axes1, 'NextPlot', 'ReplaceChildren');
            guidata(hObject, handles);
    end
end
    
% --- Executes on button press in gray_button.
function gray_button_Callback(hObject, eventdata, handles)
    if (get(handles.red_radio, 'Value') == 1)
        handles.imgGray = handles.img(:, :, 1);
    elseif (get(handles.green_radio, 'Value') == 1)
        handles.imgGray = handles.img(:, :, 2);
    elseif (get(handles.blue_radio, 'Value') == 1)
        handles.imgGray = handles.img(:, :, 3);
    else
        handles.imgGray = rgb2gray(handles.img);
    end
    handles.fig = handles.imgGray;
    imshow(handles.imgGray);
    guidata(hObject, handles);
end

% --- Executes on button press in contrast_button.
function contrast_button_Callback(hObject, eventdata, handles)
    if (get(handles.red_radio, 'Value') == 1)
        handles.imgGray = handles.img(:, :, 1);
    elseif (get(handles.green_radio, 'Value') == 1)
        handles.imgGray = handles.img(:, :, 2);
    elseif (get(handles.blue_radio, 'Value') == 1)
        handles.imgGray = handles.img(:, :, 3);
    else
        handles.imgGray = rgb2gray(handles.img);
    end
    handles.imgGrayContrast = adapthisteq(handles.imgGray);
    handles.fig = handles.imgGrayContrast;
    imshow(handles.imgGrayContrast);
    guidata(hObject, handles);
end

% --- Executes on button press in auto_radio.
function auto_radio_Callback(hObject, eventdata, handles)
    set(handles.hist_radio, 'Value', 0);
end

% --- Executes on button press in hist_radio.
function hist_radio_Callback(hObject, eventdata, handles)
    set(handles.auto_radio, 'Value', 0);
    if (get(handles.hist_radio, 'Value') == 1)
        figure(45);
        hold on;
        imhist(handles.fig);
        hold off;
    end
end

% --- Executes on button press in bw_button.
function bw_button_Callback(hObject, eventdata, handles)
    if (get(handles.auto_radio, 'Value') == 1)
        threshold = graythresh(handles.fig);
        handles.imgBW = im2bw(handles.fig, threshold);
        imshow(handles.imgBW);
        set(handles.threshold_edit, 'String', threshold * 255);
        set(handles.bw_slider, 'Value', threshold * 255);
        
    elseif (get(handles.hist_radio, 'Value') == 1)
        threshold = str2double(get(handles.threshold_edit, 'String'));
        handles.imgBW = handles.fig > threshold;
        imshow(handles.imgBW);
        set(handles.bw_slider, 'Value', threshold);
    end
    
    guidata(hObject, handles);
end
    



function threshold_edit_Callback(hObject, eventdata, handles)
    threshold = str2double(get(handles.threshold_edit, 'String'));
    set(handles.bw_slider, 'Value', threshold);
end
    
% --- Executes during object creation, after setting all properties.
function threshold_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on slider movement.
function bw_slider_Callback(hObject, eventdata, handles)
    threshold = get(handles.bw_slider, 'Value');
    set(handles.threshold_edit, 'String', threshold);
    handles.imgBW = handles.fig > threshold;
    imshow(handles.imgBW, 'InitialMagnification', 'fit'); 
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function bw_slider_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

% --- Executes on button press in noise_button.
function noise_button_Callback(hObject, eventdata, handles)
    if (isfield(handles, 'imgBW'))
        area = str2double(get(handles.pixel_edit, 'String'));
        handles.imgCleaned = imfill(handles.imgBW, 'holes');
        handles.imgCleaned = bwareaopen(handles.imgCleaned, area);
        imshow(handles.imgCleaned);
        guidata(hObject, handles);
    end
end


function pixel_edit_Callback(hObject, eventdata, handles)
    area = str2double(get(handles.pixel_edit, 'String'));
    set(handles.noise_slider, 'Value', area);
end
    
% --- Executes during object creation, after setting all properties.
function pixel_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on slider movement.
function noise_slider_Callback(hObject, eventdata, handles)
    if(isfield(handles, 'imgBW'))
        area = get(handles.noise_slider, 'Value');
        set(handles.pixel_edit, 'String', area);
        handles.imgCleaned = imfill(handles.imgBW, 'holes');
        handles.imgCleaned = bwareaopen(handles.imgCleaned, area);
        imshow(handles.imgCleaned);
        guidata(hObject, handles);
    end
end

% --- Executes during object creation, after setting all properties.
function noise_slider_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

% --- Executes on button press in refine_button.
function refine_button_Callback(hObject, eventdata, handles)
    if (isfield(handles, 'imgCleaned'))
        image = handles.imgCleaned;
    elseif (isfield(handles, 'imgBW'))
        image = handles.imgBW;
    end
    radius = str2double(get(handles.disk_edit, 'String'));
    se = strel('disk', radius);
    handles.imgRefined = imopen(image, se);
    handles.imgRefined = imdilate(handles.imgRefined, se);
    imshow(handles.imgRefined);
    guidata(hObject, handles);
end


function disk_edit_Callback(hObject, eventdata, handles)
    radius = str2double(get(handles.disk_edit, 'String'));
    set(handles.refine_slider, 'Value', radius);
end


% --- Executes during object creation, after setting all properties.
function disk_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on slider movement.
function refine_slider_Callback(hObject, eventdata, handles)
    if (isfield(handles, 'imgCleaned'))
        image = handles.imgCleaned;
    elseif (isfield(handles, 'imgBW'))
        image = handles.imgBW;
    end
    radius = get(handles.refine_slider, 'Value');
    set(handles.disk_edit, 'String', radius);
    se = strel('disk', radius);
    handles.imgRefined = imopen(image, se);
    handles.imgRefined = imdilate(handles.imgRefined, se);
    imshow(handles.imgRefined);
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function refine_slider_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

% --- Executes on button press in overlaybw_button.
function overlaybw_button_Callback(hObject, eventdata, handles)
    overlayBW = imoverlay(handles.img, handles.imgBW, handles.overlayColor);
    imshow(overlayBW);
end

% --- Executes on button press in overlayNoise_button.
function overlayNoise_button_Callback(hObject, eventdata, handles)
    overlayCleaned = imoverlay(handles.img, handles.imgCleaned, handles.overlayColor);
    imshow(overlayCleaned);
end


% --- Executes on button press in overlayRefine_button.
function overlayRefine_button_Callback(hObject, eventdata, handles)
    overlayRefined = imoverlay(handles.img, handles.imgRefined, handles.overlayColor);
    imshow(overlayRefined);
end


% --- Executes on button press in overlayEdit_button.
function overlayEdit_button_Callback(hObject, eventdata, handles)
    overlayEdit = imoverlay(handles.img, handles.imgEdit, handles.overlayColor);
    imshow(overlayEdit);
end
    
% --- Executes on button press in draw_button.
function draw_button_Callback(hObject, eventdata, handles)
    
    if (~isfield(handles, 'imgEdit'))
        if (isfield(handles, 'imgRefined'))
            handles.imgEdit = handles.imgRefined;
        elseif (isfield(handles, 'imgCleaned'))
            handles.imgEdit = handles.imgCleaned;
        elseif (isfield(handles, 'imgBW'))
            handles.imgEdit = handles.imgBW;
        end
    end
    
    [x, y, button] = ginput(1);
    if (button == 1)
        imageSize = size(handles.img);
        radius = get(handles.mask_pop, 'Value');

        [imgX, imgY] = meshgrid(1:imageSize(2), 1:imageSize(1));
        mask = sqrt((imgX - x).^2 + (imgY - y).^2) <= radius;
        handles.imgEdit(mask == 1) = 1;
        overlay = imoverlay(handles.img, handles.imgEdit, handles.overlayColor);
        imshow(overlay);
        guidata(hObject, handles);
        draw_button_Callback(hObject, eventdata, handles);
    end
end    
    
    
    
% --- Executes on button press in remove_button.
function remove_button_Callback(hObject, eventdata, handles)
    if (~isfield(handles, 'imgEdit'))
        if (isfield(handles, 'imgRefined'))
            handles.imgEdit = handles.imgRefined;
        elseif (isfield(handles, 'imgCleaned'))
            handles.imgEdit = handles.imgCleaned;
        elseif (isfield(handles, 'imgBW'))
            handles.imgEdit = handles.imgBW;
        end
    end
    handles.imgLabeled = bwlabel(handles.imgEdit);
    switch handles.eraseMethod
        case 'click'
            [x, y, button] = ginput(1);
            if (button == 1)
                blob = handles.imgLabeled(round(y), round(x));
                handles.imgEdit(handles.imgLabeled == blob) = 0;
                handles.imgLabeled = bwlabel(handles.imgEdit);
                overlay = imoverlay(handles.img, handles.imgEdit, handles.overlayColor);
                imshow(overlay);
                guidata(hObject, handles);
                remove_button_Callback(hObject, eventdata, handles);
            end
            
        case 'draw'
            freehand = imfreehand();
            imgBinary = freehand.createMask();
            handles.imgEdit(imgBinary) = 0;
            handles.imgLabeled = bwlabel(handles.imgEdit);
            overlay = imoverlay(handles.img, handles.imgEdit, handles.overlayColor);
            imshow(overlay);
            guidata(hObject, handles);                   
    end
    
end


% --- Executes on selection change in mask_pop.
function mask_pop_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function mask_pop_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in view_button.
function view_button_Callback(hObject, eventdata, handles)
    imshow(handles.img);
end

% --- Executes on button press in bw1_button.
function bw1_button_Callback(hObject, eventdata, handles)
    imshow(handles.imgBW);
end

% --- Executes on button press in bw2_button.
function bw2_button_Callback(hObject, eventdata, handles)
    imshow(handles.imgCleaned);
end


% --- Executes on button press in bw3_button.
function bw3_button_Callback(hObject, eventdata, handles)
    imshow(handles.imgRefined);
end

% --- Executes on button press in bw4_button.
function bw4_button_Callback(hObject, eventdata, handles)
    imshow(handles.imgEdit);
end

% --- Executes on button press in count_button.
function count_button_Callback(hObject, eventdata, handles)
    if (isfield(handles, 'imgEdit'))
        image = handles.imgEdit;
    elseif (isfield(handles, 'imgRefined'))
        image = handles.imgRefined;
    elseif (isfield(handles, 'imgCleaned'))
        image = handles.imgCleaned;
    elseif (isfield(handles, 'imgBW'))
        image = handles.imgBW;
    end
    label = logical(image);
    handles.stats = regionprops(label, 'Centroid');
    set(handles.count_edit, 'String', numel(handles.stats));
       
    if (isfield(handles, 'gridRows') || isfield(handles, 'gridCols'))
        gridRows = handles.gridRows;
        gridCols = handles.gridCols;
        height = diff(gridRows);
        width = diff(gridCols);
        sections = 1:(numel(width) * numel(height));

        gridCols2 = gridCols(1:end - 1);
        gridCols3 = gridCols(2:end);
        gridRows2 = gridRows(1:end - 1);
        gridRows3 = gridRows(2:end);

        multiple1 = numel(sections) / numel(gridCols2);
        xMin = cell(1, multiple1);
        xMax = cell(1, multiple1);
        for i = 1:numel(xMin)
            xMin{i} = gridCols2;
            xMax{i} = gridCols3;
        end
        xMin = cell2mat(xMin);
        xMax = cell2mat(xMax);

        multiple2 = numel(sections) / numel(gridRows2);
        yMin = cell(1, multiple2);
        yMax = cell(1, multiple2);
        for i = 1:numel(yMin)
            yMin{i} = gridRows2;
            yMax{i} = gridRows3;        
        end
        yMin = cell2mat(yMin);  
        yMin = sort(yMin, 'ascend');
        yMax = cell2mat(yMax);
        yMax = sort(yMax, 'ascend');

        allocateCell = cell(1, numel(sections)); 
        block = struct('blockNumber', allocateCell,...
            'xMinimum', allocateCell, 'xMaximum', allocateCell,...
            'yMinimum', allocateCell, 'yMaximum', allocateCell,...
            'cellCount', allocateCell);

        for i = 1:numel(sections)
            block(i).blockNumber = i;
            block(i).xMinimum = xMin(i);
            block(i).xMaximum = xMax(i);
            block(i).yMinimum = yMin(i);
            block(i).yMaximum = yMax(i);
            block(i).cellCount = 0;
        end

        for i = 1:numel(handles.stats)
            centroid = handles.stats(i).Centroid;
            xx = centroid(1);
            yy = centroid(2);
            for j = 1:numel(block)
                cond1 = (xx > block(j).xMinimum) && (xx < block(j).xMaximum);
                cond2 = (yy > block(j).yMinimum) && (yy < block(j).yMaximum);
                cellCount = block(j).cellCount;
                if ( (cond1 == 1) && (cond2 == 1))
                    block(j).cellCount = cellCount + 1;
                end
            end     
        end

        
        if(get(handles.red_radio, 'Value') == 1)
            handles.quadrantRed = block;
            clc;
            disp('Red Cells');
        elseif(get(handles.green_radio, 'Value') == 1)
            handles.quadrantGreen = block;
            clc;
            disp('Green Cells');
        elseif(get(handles.blue_radio, 'Value') == 1)
            handles.quadrantBlue = block;
            clc;
            disp('Blue Cells');
        else
            return
        end
        
        for i = 1:numel(block);
            fprintf('Block: %d\t-\tCell Count: %d\n', block(i).blockNumber, block(i).cellCount); 
        end
        fprintf('\n');
        
        for i = 1:numel(block);
            fprintf('%d\n', block(i).cellCount)
        end
        fprintf('\n');
    end
    
    if(get(handles.red_radio, 'Value') == 1)
        handles.imgRed = image;
    elseif(get(handles.green_radio, 'Value') == 1)
        handles.imgGreen = image;
    elseif(get(handles.blue_radio, 'Value') == 1)
        handles.imgBlue = image;
    else
        return
    end
    guidata(hObject, handles);
end
    
function [stats, block] = getCount(handles, image)
    label = logical(image);
    stats = regionprops(label, 'Centroid');
    set(handles.count_edit, 'String', numel(stats));
       
    if (isfield(handles, 'gridRows') || isfield(handles, 'gridCols'))
        gridRows = handles.gridRows;
        gridCols = handles.gridCols;
        height = diff(gridRows);
        width = diff(gridCols);
        sections = 1:(numel(width) * numel(height));

        gridCols2 = gridCols(1:end - 1);
        gridCols3 = gridCols(2:end);
        gridRows2 = gridRows(1:end - 1);
        gridRows3 = gridRows(2:end);

        multiple1 = numel(sections) / numel(gridCols2);
        xMin = cell(1, multiple1);
        xMax = cell(1, multiple1);
        for i = 1:numel(xMin)
            xMin{i} = gridCols2;
            xMax{i} = gridCols3;
        end
        xMin = cell2mat(xMin);
        xMax = cell2mat(xMax);

        multiple2 = numel(sections) / numel(gridRows2);
        yMin = cell(1, multiple2);
        yMax = cell(1, multiple2);
        for i = 1:numel(yMin)
            yMin{i} = gridRows2;
            yMax{i} = gridRows3;        
        end
        yMin = cell2mat(yMin);  
        yMin = sort(yMin, 'ascend');
        yMax = cell2mat(yMax);
        yMax = sort(yMax, 'ascend');

        allocateCell = cell(1, numel(sections)); 
        block = struct('blockNumber', allocateCell,...
            'xMinimum', allocateCell, 'xMaximum', allocateCell,...
            'yMinimum', allocateCell, 'yMaximum', allocateCell,...
            'cellCount', allocateCell);

        for i = 1:numel(sections)
            block(i).blockNumber = i;
            block(i).xMinimum = xMin(i);
            block(i).xMaximum = xMax(i);
            block(i).yMinimum = yMin(i);
            block(i).yMaximum = yMax(i);
            block(i).cellCount = 0;
        end

        for i = 1:numel(stats)
            centroid = stats(i).Centroid;
            xx = centroid(1);
            yy = centroid(2);
            for j = 1:numel(block)
                cond1 = (xx > block(j).xMinimum) && (xx < block(j).xMaximum);
                cond2 = (yy > block(j).yMinimum) && (yy < block(j).yMaximum);
                cellCount = block(j).cellCount;
                if ( (cond1 == 1) && (cond2 == 1))
                    block(j).cellCount = cellCount + 1;
                end
            end     
        end
        
%         for i = 1:numel(block);
%             fprintf('Block: %d\t-\tCell Count: %d\n', block(i).blockNumber, block(i).cellCount); 
%         end
%         fprintf('\n');
        
        for i = 1:numel(block);
            fprintf('%d\n', block(i).cellCount)
        end
        fprintf('\n');
        
    else
        block = NaN;
    end
end


function count_edit_Callback(hObject, eventdata, handles)
end
    
% --- Executes during object creation, after setting all properties.
function count_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in grid1_button.
function grid1_button_Callback(hObject, eventdata, handles)
    currentFig = getimage(handles.axes1);
    gridRows = handles.gridRows;
    gridRows(gridRows == 0) = 1;
    currentFig(round(gridRows(:)), :, :) = 255;
    gridCols = handles.gridCols;
    gridCols(gridCols == 0) = 1;
    currentFig(:, round(gridCols(:)), :) = 255;
    imshow(currentFig);
end

% --- Executes on button press in grid2_button.
function grid2_button_Callback(hObject, eventdata, handles)
    currentFig = getimage(handles.axes1);
    gridRows = handles.gridRows;
    gridRows(gridRows == 0) = 1;
    currentFig(round(gridRows(:)), :, :) = 255;
    gridCols = handles.gridCols;
    gridCols(gridCols == 0) = 1;
    currentFig(:, round(gridCols(:)), :) = 255;
    imshow(currentFig);
end

% --- Executes on button press in grid3_button.
function grid3_button_Callback(hObject, eventdata, handles)
    currentFig = getimage(handles.axes1);
    gridRows = handles.gridRows;
    gridRows(gridRows == 0) = 1;
    currentFig(round(gridRows(:)), :, :) = 255;
    gridCols = handles.gridCols;
    gridCols(gridCols == 0) = 1;
    currentFig(:, round(gridCols(:)), :) = 255;
    imshow(currentFig);
end

% --- Executes on button press in grid4_button.
function grid4_button_Callback(hObject, eventdata, handles)
    currentFig = getimage(handles.axes1);
    gridRows = handles.gridRows;
    gridRows(gridRows == 0) = 1;
    currentFig(round(gridRows(:)), :, :) = 255;
    gridCols = handles.gridCols;
    gridCols(gridCols == 0) = 1;
    currentFig(:, round(gridCols(:)), :) = 255;
    imshow(currentFig);
end


% --- Executes on button press in blue_button.
function blue_button_Callback(hObject, eventdata, handles)
    if(isfield(handles, 'imgBlue'))
        if(isfield(handles, 'doubleLabelB'))
            handles.imgBlue = handles.doubleLabelB;
        end
        
        sliderMax = max(cell2mat(struct2cell(regionprops(handles.imgBlue, 'Area')))) + 1;
        if (isempty(sliderMax))
            sliderMax = 1;
        end
        sliderStep = [1, 1] / (sliderMax);
        set(handles.doubleLabel_slider, 'Max', sliderMax);
        set(handles.doubleLabel_slider, 'SliderStep', sliderStep);
        set(handles.doubleLabel_slider, 'Value', 0);
                        
        try
            delete(handles.blueLayer);
        catch err
        end
        toggle = get(handles.blue_button, 'Value');
        if (toggle == get(handles.blue_button, 'Max'))
            blue = cat(3, zeros(size(handles.imgBlue)), zeros(size(handles.imgBlue)), ones(size(handles.imgBlue)));
            hold on
            handles.blueLayer = imshow(blue);
            set(handles.blueLayer, 'AlphaData', handles.imgBlue);
            hold off
            disp('Blue Cells');
            [stats, block] = getCount(handles, handles.imgBlue);
            set(handles.blue_edit, 'String', numel(stats));
            handles.blueStats = stats;
            handles.blueQuads = block;
            handles.toggle = 'blue';
            guidata(hObject, handles);   
        elseif (toggle == get(handles.blue_button, 'Min'))
            try
                delete(handles.blueLayer);
            catch err
            end
        end
        guidata(hObject, handles);
    end
end


% --- Executes on button press in green_button.
function green_button_Callback(hObject, eventdata, handles)
    if(isfield(handles, 'imgGreen'))
        if(isfield(handles, 'doubleLabelG'))
            handles.imgGreen = handles.doubleLabelG;
        end
        
        sliderMax = max(cell2mat(struct2cell(regionprops(handles.imgGreen, 'Area')))) + 1;
        if (isempty(sliderMax))
            sliderMax = 1;
        end
        sliderStep = [1, 1] / (sliderMax);
        set(handles.doubleLabel_slider, 'Max', sliderMax);
        set(handles.doubleLabel_slider, 'SliderStep', sliderStep);
        set(handles.doubleLabel_slider, 'Value', 0);
                
        try
            delete(handles.greenLayer);
        catch err
        end
        toggle = get(handles.green_button, 'Value');
        if (toggle == get(handles.green_button, 'Max'))
            green = cat(3, zeros(size(handles.imgGreen)), ones(size(handles.imgGreen)), zeros(size(handles.imgGreen)));
            hold on
            handles.greenLayer = imshow(green);
            set(handles.greenLayer, 'AlphaData', handles.imgGreen);
            hold off
            disp('Green Cells');
            [stats, block] = getCount(handles, handles.imgGreen);
            set(handles.green_edit, 'String', numel(stats));
            handles.greenStats = stats;
            handles.greenQuads = block;
            handles.toggle = 'green';
            guidata(hObject, handles);
        elseif (toggle == get(handles.green_button, 'Min'))
            try
                delete(handles.greenLayer);
            catch err
            end
        end
        guidata(hObject, handles);
    end
end

% --- Executes on button press in red_button.
function red_button_Callback(hObject, eventdata, handles)
    if(isfield(handles, 'imgRed'))
        if(isfield(handles, 'doubleLabelR'))
            handles.imgRed = handles.doubleLabelR;
        end
        
        sliderMax = max(cell2mat(struct2cell(regionprops(handles.imgRed, 'Area')))) + 1;
        if (isempty(sliderMax))
            sliderMax = 1;
        end
        sliderStep = [1, 1] / (sliderMax);
        set(handles.doubleLabel_slider, 'Max', sliderMax);
        set(handles.doubleLabel_slider, 'SliderStep', sliderStep);
        set(handles.doubleLabel_slider, 'Value', 0);
                
        try
            delete(handles.redLayer);
        catch err
        end
        toggle = get(handles.red_button, 'Value');
        if (toggle == get(handles.red_button, 'Max'))
            red = cat(3, ones(size(handles.imgRed)), zeros(size(handles.imgRed)), zeros(size(handles.imgRed)));
            hold on
            handles.redLayer = imshow(red);
            set(handles.redLayer, 'AlphaData', handles.imgRed);
            hold off
            disp('Red Cells');
            [stats, block] = getCount(handles, handles.imgRed);
            set(handles.red_edit, 'String', numel(stats));
            handles.redStats = stats;
            handles.redQuads = block;
            handles.toggle = 'red';
            guidata(hObject, handles);
        elseif (toggle == get(handles.red_button, 'Min'))
            try
                delete(handles.redLayer);
            catch err
            end
        end
        guidata(hObject, handles);
    end
end

% --- Executes on button press in blue_green_button.
function blue_green_button_Callback(hObject, eventdata, handles)
    if (isfield(handles, 'imgBlueGreen'))
        if(isfield(handles, 'doubleLabelBG'))
            handles.imgBlueGreen = handles.doubleLabelBG;
        end
        
        sliderMax = max(cell2mat(struct2cell(regionprops(handles.imgBlueGreen, 'Area')))) + 1;
        if (isempty(sliderMax))
            sliderMax = 1;
        end
        sliderStep = [1, 1] / (sliderMax);
        set(handles.doubleLabel_slider, 'Max', sliderMax);
        set(handles.doubleLabel_slider, 'SliderStep', sliderStep);
        set(handles.doubleLabel_slider, 'Value', 0);
                
        try
            delete(handles.blueGreenLayer);
        catch err
        end
        toggle = get(handles.blue_green_button, 'Value');
        if (toggle == get(handles.blue_green_button, 'Max'))
            BG = cat(3, zeros(size(handles.imgBlueGreen)), ones(size(handles.imgBlueGreen)), ones(size(handles.imgBlueGreen)));
            hold on
            handles.blueGreenLayer = imshow(BG);
            set(handles.blueGreenLayer, 'AlphaData', handles.imgBlueGreen);
            hold off
            disp('Blue/Green (Cyan) Cells');
            [stats, block] = getCount(handles, handles.imgBlueGreen);
            set(handles.blueGreen_edit, 'String', numel(stats));
            handles.blueGreenStats = stats;
            handles.blueGreenQuads = block;
            handles.toggle = 'blueGreen';
            guidata(hObject, handles);
        elseif (toggle == get(handles.blue_green_button, 'Min'))
            try
                delete(handles.blueGreenLayer);
            catch err
            end
        end
        guidata(hObject, handles);
    end
end


% --- Executes on button press in blue_red_button.
function blue_red_button_Callback(hObject, eventdata, handles)
    if(isfield(handles, 'imgBlueRed'))
        if(isfield(handles, 'doubleLabelBR'))
            handles.imgBlueRed = handles.doubleLabelBR;
        end
        
        sliderMax = max(cell2mat(struct2cell(regionprops(handles.imgBlueRed, 'Area')))) + 1;
        if (isempty(sliderMax))
            sliderMax = 1;
        end
        sliderStep = [1, 1] / (sliderMax);
        set(handles.doubleLabel_slider, 'Max', sliderMax);
        set(handles.doubleLabel_slider, 'SliderStep', sliderStep);
        set(handles.doubleLabel_slider, 'Value', 0);
         
        try
            delete(handles.blueRedLayer);
        catch err
        end
        toggle = get(handles.blue_red_button, 'Value');
        if (toggle == get(handles.blue_red_button, 'Max'))
            BR = cat(3, ones(size(handles.imgBlueRed)), zeros(size(handles.imgBlueRed)), ones(size(handles.imgBlueRed)));
            hold on
            handles.blueRedLayer = imshow(BR);
            set(handles.blueRedLayer, 'AlphaData', handles.imgBlueRed);
            hold off
            disp('Blue/Red (Magenta) Cells');
            [stats, block] = getCount(handles, handles.imgBlueRed);
            set(handles.blueRed_edit, 'String', numel(stats));
            handles.blueRedStats = stats;
            handles.blueRedQuads = block;
            handles.toggle = 'blueRed';
            guidata(hObject, handles);
        elseif (toggle == get(handles.blue_red_button, 'Min'))
            try
                delete(handles.blueRedLayer);
            catch err
            end
        end
        guidata(hObject, handles);
    end
end

% --- Executes on button press in green_red_button.
function green_red_button_Callback(hObject, eventdata, handles)
    if(isfield(handles, 'imgGreenRed'))
        if(isfield(handles, 'doubleLabelGR'))
            handles.imgGreenRed = handles.doubleLabelGR;
        end
        
        sliderMax = max(cell2mat(struct2cell(regionprops(handles.imgGreenRed, 'Area')))) + 1;
        if (isempty(sliderMax))
            sliderMax = 1;
        end
        sliderStep = [1, 1] / (sliderMax);
        set(handles.doubleLabel_slider, 'Max', sliderMax);
        set(handles.doubleLabel_slider, 'SliderStep', sliderStep);
        set(handles.doubleLabel_slider, 'Value', 0);
        
        try
            delete(handles.greenRedLayer);
        catch err
        end
        toggle = get(handles.green_red_button, 'Value');
        if (toggle == get(handles.green_red_button, 'Max'))
            GR = cat(3, ones(size(handles.imgGreenRed)), ones(size(handles.imgGreenRed)), zeros(size(handles.imgGreenRed)));
            hold on
            handles.greenRedLayer = imshow(GR);
            set(handles.greenRedLayer, 'AlphaData', handles.imgGreenRed);
            hold off
            disp('Green/Red (Yellow) Cells');
            [stats, block] = getCount(handles, handles.imgGreenRed);
            set(handles.greenRed_edit, 'String', numel(stats));
            handles.greenRedStats = stats;
            handles.greenRedQuads = block;
            handles.toggle = 'greenRed';
            guidata(hObject, handles);
        elseif (toggle == get(handles.green_red_button, 'Min'))
            try
                delete(handles.greenRedLayer);
            catch err
            end
        end
        guidata(hObject, handles);
    end
end

% --- Executes on button press in blue_green_red_button.
function blue_green_red_button_Callback(hObject, eventdata, handles)
    if(isfield(handles, 'imgBlueGreenRed'))
        if(isfield(handles, 'doubleLabelBGR'))
            handles.imgBlueGreenRed = handles.doubleLabelBGR;
        end
        
        sliderMax = max(cell2mat(struct2cell(regionprops(handles.imgBlueGreenRed, 'Area')))) + 1;
        if (isempty(sliderMax))
            sliderMax = 1;
        end
        sliderStep = [1, 1] / (sliderMax);
        set(handles.doubleLabel_slider, 'Max', sliderMax);
        set(handles.doubleLabel_slider, 'SliderStep', sliderStep);
        set(handles.doubleLabel_slider, 'Value', 0);
        
        try
            delete(handles.blueGreenRedLayer);
        catch err
        end
        toggle = get(handles.blue_green_red_button, 'Value');
        if (toggle == get(handles.blue_green_red_button, 'Max'))
            BGR = cat(3, ones(size(handles.imgBlueGreenRed)), ones(size(handles.imgBlueGreenRed)), ones(size(handles.imgBlueGreenRed)));
            hold on
            handles.blueGreenRedLayer = imshow(BGR);
            set(handles.blueGreenRedLayer, 'AlphaData', handles.imgBlueGreenRed);
            hold off
            clc;
            disp('Blue/Green/Red (White) Cells');
            [stats, block] = getCount(handles, handles.imgBlueGreenRed);
            set(handles.blueGreenRed_edit, 'String', numel(stats));
            handles.blueGreenRedStats = stats;
            handles.blueGreenRedQuads = block;
            handles.toggle = 'blueGreenRed';
            guidata(hObject, handles);
        elseif (toggle == get(handles.blue_green_red_button, 'Min'))
            try
                delete(handles.blueGreenRedLayer);
            catch err
            end
        end
        guidata(hObject, handles);
    end
end

function blue_edit_Callback(hObject, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function blue_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function green_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function green_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function red_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function red_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function blueGreen_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function blueGreen_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function blueRed_edit_Callback(hObject, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function blueRed_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function greenRed_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function greenRed_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function blueGreenRed_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function blueGreenRed_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)

    if(isfield(handles, 'redStats'))
        color = [1 0 0];
        for i = 1:numel(handles.redStats)
            centroid = handles.redStats(i).Centroid;
            x = centroid(1);
            y = centroid(2);
            hold on;
            plot(x, y, 'o', 'MarkerEdgeColor', color, 'MarkerFaceColor', color);
            hold off;
        end
    end
    
    if(isfield(handles, 'blueStats'))
        color = [0 0 1];
        for i = 1:numel(handles.blueStats)
            centroid = handles.blueStats(i).Centroid;
            x = centroid(1);
            y = centroid(2);
            hold on;
            plot(x, y, 'o', 'MarkerEdgeColor', color, 'MarkerFaceColor', color);
            hold off;
        end
    end
    
    if(isfield(handles, 'greenStats'))
        color = [0 1 0];
        for i = 1:numel(handles.greenStats)
            centroid = handles.greenStats(i).Centroid;
            x = centroid(1);
            y = centroid(2);
            hold on;
            plot(x, y, 'o', 'MarkerEdgeColor', color, 'MarkerFaceColor', color);
            hold off;
        end
    end
    
    if(isfield(handles, 'blueGreenStats'))
        color = [0 1 1];
        for  i = 1:numel(handles.blueGreenStats)
            centroid = handles.blueGreenStats(i).Centroid;
            x = centroid(1);
            y = centroid(2);
            hold on;
            plot(x, y, 'o', 'MarkerEdgeColor', color, 'MarkerFaceColor', color);
            hold off;
        end
    end
    
    if(isfield(handles, 'blueRedStats'))
        color = [1 0 1];
        for i = 1:numel(handles.blueRedStats)
            centroid = handles.blueRedStats(i).Centroid;
            x = centroid(1);
            y = centroid(2);
            hold on;
            plot(x, y, 'o', 'MarkerEdgeColor', color, 'MarkerFaceColor', color);
            hold off;
        end
    end
    
    if(isfield(handles, 'greenRedStats'))
        color = [1 1 0];
        for i = 1:numel(handles.greenRedStats)
            centroid = handles.greenRedStats(i).Centroid;
            x = centroid(1);
            y = centroid(2);
            hold on;
            plot(x, y, 'o', 'MarkerEdgeColor', color, 'MarkerFaceColor', color);
            hold off;
        end
    end
    
    if(isfield(handles, 'blueGreenRedStats'))
        color = [1 1 1];
        for i = 1:numel(handles.blueGreenRedStats)
            centroid = handles.blueGreenRedStats(i).Centroid;
            x = centroid(1);
            y = centroid(2);
            hold on;
            plot(x, y, 'o', 'MarkerEdgeColor', color, 'MarkerFaceColor', color);
            hold off;
        end
    end
end


% --- Executes on button press in draw2_button.
function draw2_button_Callback(hObject, eventdata, handles)
    
    switch handles.toggle
        case {'blue'}
            image = handles.imgBlue;
        case {'green'}
            image = handles.imgGreen;
        case {'red'}
            image = handles.imgRed;
        case {'blueGreen'}
            image = handles.imgBlueGreen;
        case {'blueRed'}
            image = handles.imgBlueRed;
        case {'greenRed'}
            image = handles.imgGreenRed;
        case {'blueGreenRed'}
            image = handles.imgBlueGreenRed;
    end
    
    [x, y, button] = myginput(1);
    if (button == 1)
        imageSize = size(image);
        radius = get(handles.mask2_pop, 'Value');
        [imgX, imgY] = meshgrid(1:imageSize(2), 1:imageSize(1));
        mask = sqrt((imgX - x).^2 + (imgY - y).^2) <= radius;
        image(mask == 1) = 1;
        switch handles.toggle
            case {'blue'}
                handles.imgBlue = image;
            case {'green'}
                handles.imgGreen = image;
            case {'red'}
                handles.imgRed = image;
            case {'blueGreen'}
                handles.imgBlueGreen = image;
            case {'blueRed'}
                handles.imgBlueRed = image;
            case {'greenRed'}
                handles.imgGreenRed = image;
            case {'blueGreenRed'}
                handles.imgBlueGreenRed = image;
        end
        guidata(hObject, handles);
        draw2_button_Callback(hObject, eventdata, handles); 
    end
end

% --- Executes on button press in remove2_button.
function remove2_button_Callback(hObject, eventdata, handles)
    switch handles.toggle
        case {'blue'}
            image = handles.imgBlue;
        case {'green'}
            image = handles.imgGreen;
        case {'red'}
            image = handles.imgRed;
        case {'blueGreen'}
            image = handles.imgBlueGreen;
        case {'blueRed'}
            image = handles.imgBlueRed;
        case {'greenRed'}
            image = handles.imgGreenRed;
        case {'blueGreenRed'}
            image = handles.imgBlueGreenRed;
    end
    image = bwlabel(image);  
    [x, y, button] = myginput(1);
    if (button == 1)
        blob = image(round(y), round(x));
        image(image == blob) = 0;
        image = bwlabel(image);
        switch handles.toggle
            case {'blue'}
                handles.imgBlue = image;
            case {'green'}
                handles.imgGreen = image;
            case {'red'}
                handles.imgRed = image;
            case {'blueGreen'}
                handles.imgBlueGreen = image;
            case {'blueRed'}
                handles.imgBlueRed = image;
            case {'greenRed'}
                handles.imgGreenRed = image;
            case {'blueGreenRed'}
                handles.imgBlueGreenRed = image;
       end
   guidata(hObject, handles);
   remove2_button_Callback(hObject, eventdata, handles);
   end
end

% --- Executes on selection change in mask2_pop.
function mask2_pop_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function mask2_pop_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in overlay2_button.
function overlay2_button_Callback(hObject, eventdata, handles)
    toggle = get(handles.overlay2_button, 'Value');
        if (toggle == get(handles.green_button, 'Max'))
            handles.overlayImg = imshow(handles.img);
        elseif (toggle == get(handles.overlay2_button, 'Min'))
            try
                delete(handles.overlayImg);
            catch err
            end
        end
        guidata(hObject, handles);
end


% --- Executes on slider movement.
function doubleLabel_slider_Callback(hObject, eventdata, handles)
    switch handles.toggle
            case {'blue'}
                image = handles.imgBlue;
                
                try
                    delete(handles.blueLayer);
                catch err
                end
                image2 = bwareaopen(image, round(get(handles.doubleLabel_slider, 'Value')));
                blue = cat(3, zeros(size(image2)), zeros(size(image2)), ones(size(image2)));
                hold on
                handles.blueLayer = imshow(blue);
                set(handles.blueLayer, 'AlphaData', image2);
                hold off
                handles.doubleLabelB = image2;
                guidata(hObject, handles)
                
            case {'green'}
                image = handles.imgGreen;
                sliderMax = max(cell2mat(struct2cell(regionprops(image, 'Area')))) + 1;
                sliderStep = [1, 1] / (sliderMax);
                set(handles.doubleLabel_slider, 'Max', sliderMax);
                set(handles.doubleLabel_slider, 'SliderStep', sliderStep);
                try
                    delete(handles.greenLayer);
                catch err
                end
                image2 = bwareaopen(image, round(get(handles.doubleLabel_slider, 'Value')));
                green = cat(3, zeros(size(image2)), ones(size(image2)), zeros(size(image2)));
                hold on
                handles.greenLayer = imshow(green);
                set(handles.greenLayer, 'AlphaData', image2);
                hold off
                handles.doubleLabelG = image2;
                guidata(hObject, handles)
                   
            case {'red'}
                image = handles.imgRed;
                sliderMax = max(cell2mat(struct2cell(regionprops(image, 'Area')))) + 1;
                sliderStep = [1, 1] / (sliderMax);
                set(handles.doubleLabel_slider, 'Max', sliderMax);
                set(handles.doubleLabel_slider, 'SliderStep', sliderStep);
                try
                    delete(handles.redLayer);
                catch err
                end
                image2 = bwareaopen(image, round(get(handles.doubleLabel_slider, 'Value')));
                red = cat(3, ones(size(image2)), zeros(size(image2)), zeros(size(image2)));
                hold on
                handles.redLayer = imshow(red);
                set(handles.redLayer, 'AlphaData', image2);
                hold off
                handles.doubleLabelR = image2;
                guidata(hObject, handles)
                
            case {'blueGreen'}
                image = handles.imgBlueGreen;
                sliderMax = max(cell2mat(struct2cell(regionprops(image, 'Area')))) + 1;
                sliderStep = [1, 1] / (sliderMax);
                set(handles.doubleLabel_slider, 'Max', sliderMax);
                set(handles.doubleLabel_slider, 'SliderStep', sliderStep);
                try
                    delete(handles.blueGreenLayer);
                catch err
                end
                image2 = bwareaopen(image, round(get(handles.doubleLabel_slider, 'Value')));
                BG = cat(3, zeros(size(image2)), ones(size(image2)), ones(size(image2)));
                hold on
                handles.blueGreenLayer = imshow(BG);
                set(handles.blueGreenLayer, 'AlphaData', image2);
                hold off
                handles.doubleLabelBG = image2;
                guidata(hObject, handles)
                
            case {'blueRed'}
                image = handles.imgBlueRed;
                sliderMax = max(cell2mat(struct2cell(regionprops(image, 'Area')))) + 1;
                sliderStep = [1, 1] / (sliderMax);
                set(handles.doubleLabel_slider, 'Max', sliderMax);
                set(handles.doubleLabel_slider, 'SliderStep', sliderStep);
                try
                delete(handles.blueRedLayer);
                catch err
                end
                image2 = bwareaopen(image, round(get(handles.doubleLabel_slider, 'Value')));
                BR = cat(3, ones(size(image2)), zeros(size(image2)), ones(size(image2)));
                hold on
                handles.blueRedLayer = imshow(BR);
                set(handles.blueRedLayer, 'AlphaData', image2);
                hold off
                handles.doubleLabelBR = image2;
                guidata(hObject, handles)
                
            case {'greenRed'}
                image = handles.imgGreenRed;
                sliderMax = max(cell2mat(struct2cell(regionprops(image, 'Area')))) + 1;
                sliderStep = [1, 1] / (sliderMax);
                set(handles.doubleLabel_slider, 'Max', sliderMax);
                set(handles.doubleLabel_slider, 'SliderStep', sliderStep);
                try
                    delete(handles.greenRedLayer);
                catch err
                end
                image2 = bwareaopen(image, round(get(handles.doubleLabel_slider, 'Value')));
                GR = cat(3, ones(size(image2)), ones(size(image2)), zeros(size(image2)));
                hold on
                handles.greenRedLayer = imshow(GR);
                set(handles.greenRedLayer, 'AlphaData', image2);
                hold off
                handles.doubleLabelGR = image2;
                guidata(hObject, handles)
                
            case {'blueGreenRed'}
                image = handles.imgBlueGreenRed;
                sliderMax = max(cell2mat(struct2cell(regionprops(image, 'Area')))) + 1;
                sliderStep = [1, 1] / (sliderMax);
                set(handles.doubleLabel_slider, 'Max', sliderMax);
                set(handles.doubleLabel_slider, 'SliderStep', sliderStep);
                try
                    delete(handles.blueGreenRedLayer);
                catch err
                end
                image2 = bwareaopen(image, round(get(handles.doubleLabel_slider, 'Value')));
                BGR = cat(3, zeros(size(image2)), zeros(size(image2)), zeros(size(image2)));
                hold on
                handles.blueGreenRedLayer = imshow(BGR);
                set(handles.blueGreenRedLayer, 'AlphaData', image2);
                hold off
                handles.doubleLabelBGR = image2;
                guidata(hObject, handles);
    end
    
end

% --- Executes during object creation, after setting all properties.
function doubleLabel_slider_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end
