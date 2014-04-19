function varargout = plotData(varargin)
% PLOTDATA MATLAB code for plotData.fig
%      PLOTDATA, by itself, creates a new PLOTDATA or raises the existing
%      singleton*.
%
%      H = PLOTDATA returns the handle to a new PLOTDATA or the handle to
%      the existing singleton*.
%
%      PLOTDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTDATA.M with the given input arguments.
%
%      PLOTDATA('Property','Value',...) creates a new PLOTDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotData

% Last Modified by GUIDE v2.5 17-Apr-2014 10:17:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotData_OpeningFcn, ...
                   'gui_OutputFcn',  @plotData_OutputFcn, ...
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


% --- Executes just before plotData is made visible.
function plotData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotData (see VARARGIN)

% Choose default command line output for plotData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotData wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.marker_edit, 'String', '5');
set(handles.smoothing_edit, 'String', '0.5');
set(handles.xbin_edit, 'String', '50');
set(handles.ybin_edit, 'String', '50');


% --- Outputs from this function are returned to the command line.
function varargout = plotData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in directory_button.
function directory_button_Callback(hObject, eventdata, handles)
    folder = uigetdir();
    dirListing = dir(folder);
    handles.data = [];
    for i = 1:length(dirListing)
        if (~dirListing(i).isdir)
            fileName = fullfile(folder, dirListing(i).name);
            handles.data = vertcat(handles.data, importdata(fileName));
        end
    end
    fprintf('\nFolder: %s\n', folder);
    guidata(hObject, handles);

% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)

    close(findobj('Type', 'Figure', 'Name', 'Centroids'));
    close(findobj('Type', 'Figure', 'Name', 'Density Plot'));
    close(findobj('Type', 'Figure', 'Name', 'Contour Plot'));

    circleSize = str2double(get(handles.marker_edit, 'String'));
    smoothing = str2double(get(handles.smoothing_edit, 'String'));
    xBin = str2double(get(handles.xbin_edit, 'String'));
    yBin = str2double(get(handles.ybin_edit, 'String'));
    nBin = [xBin yBin];
    
    xmin = str2double(get(handles.xmin_edit, 'String'));
    xmax = str2double(get(handles.xmax_edit, 'String'));
    ymin = str2double(get(handles.ymin_edit, 'String'));
    ymax = str2double(get(handles.ymax_edit, 'String'));
    
    if (~isnan(xmin) && ~isnan(xmax) && ~isnan(ymin) && ~isnan(ymax))
        lim = [xmin, xmax, ymin, ymax];
    else
        lim = 'auto';
    end

    dataH = handles.data;
    if (get(handles.r_check, 'Value') == 0)
        dataH = removerows(dataH, find(dataH(:,3) == 1));
    end
    
    if (get(handles.g_check, 'Value') == 0)
        dataH = removerows(dataH, find(dataH(:,3) == 2));
    end
    
    if (get(handles.b_check, 'Value') == 0)
        dataH = removerows(dataH, find(dataH(:,3) == 3));
    end
   
    if (get(handles.rg_check, 'Value') == 0)
        dataH = removerows(dataH, find(dataH(:,3) == 12));
    end
    
    if (get(handles.rb_check, 'Value') == 0)
        dataH = removerows(dataH, find(dataH(:,3) == 13));
    end
    
    if (get(handles.gb_check, 'Value') == 0)
        dataH = removerows(dataH, find(dataH(:,3) == 23));
    end
    
    if (get(handles.rgb_check, 'Value') == 0)
        dataH = removerows(dataH, find(dataH(:,3) == 123));
    end

    % x coordinate of centroid in first column.
    xx = dataH(:, 1);
    % y cooordinate of centroid in second column.
    yy = dataH(:, 2);
    % color code of coordinate in third column.
    color = dataH(:, 3);
    
    hFig1 = figure(101);
    set(hFig1, 'Name', 'Centroids');
    hold on
    axis ij;
    axis(lim);
    % For loop to plot data.
    for i = 1:numel(xx)
        x = xx(i);
        y = yy(i);
        c = color(i);
        switch c
            case 1 
                c = [1 0 0];        % Red Cells
                
            case 2
                c = [0 1 0];        % Green Cells
                
            case 3
                c = [0 0 1];        % Blue Cells
                
            case 12
                c = [1 0.6 .2];     % Red/Green (Yellow) Cells
                
            case 13
                c = [1 0 1];        % Red/Blue (Magenta) Cells
                
            case 23
                c = [0 1 1];        % Blue/Green (Cyan) Cells
                
            case 123
                c = [0 0 0];        % Red/Green/Blue (Black, actually supposed to be White) Cells
        end
        plot(x, y, 'o', 'MarkerEdgeColor', c, 'MarkerFaceColor', c, 'MarkerSize', circleSize);   
    end
    xlabel('X-Axis');
    ylabel('Y-Axis');
    hold off
    if (strcmp(lim, 'auto'))
        lim = axis;
    end
        
    hFig2 = figure(102);
    set(hFig2, 'Name', 'Density Plot');
    axis(lim);
    axis ij
    hold on
    smoothhist2D([xx yy], lim, smoothing, nBin, [], 'surf');
    hold off
    
    hFig3 = figure(103);
    set(hFig3, 'Name', 'Contour Plot');
    axis(lim);
    axis ij
    hold on
    smoothhist2D([xx yy], lim, smoothing, nBin, [], 'contour');
    hold off


    %     % End of plotting the data.
%     n = 5;
%     xxi = linspace(min(xx(:)), max(xx(:)), n);
%     yyi = linspace(min(yy(:)), max(yy(:)), n);
% 
%     % Groups data.
%     xxr = interp1(xxi, 1:numel(xxi), xx, 'nearest');
%     yyr = interp1(yyi, 1:numel(yyi), yy, 'nearest');
% 
%     % Makes matrix.
%     zz = accumarray([xxr yyr], 1, [n n]);
%     figure(104)
%     hold on
%     % Creates Heat/Density Map.
%     surf(zz)
%     camroll(270);
%     xlabel('X-Axis');
%     ylabel('Y-Axis');
%     hold off
%     
%    % Sets subplot 3 of figure(2) to current axes.
%     figure(105)
%     hold on
%     % Creates contour plot.
%     contour(zz);
%     camroll(270);
%     hold off


% --- Executes on button press in closeFig_button.
function closeFig_button_Callback(hObject, eventdata, handles)
    close(findobj('Type', 'Figure', 'Name', 'Centroids'));
    close(findobj('Type', 'Figure', 'Name', 'Density Plot'));
    close(findobj('Type', 'Figure', 'Name', 'Contour Plot'));

function marker_edit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function marker_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function smoothing_edit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function smoothing_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function xbin_edit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function xbin_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function ybin_edit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function ybin_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in r_check.
function r_check_Callback(hObject, eventdata, handles)


% --- Executes on button press in g_check.
function g_check_Callback(hObject, eventdata, handles)


% --- Executes on button press in b_check.
function b_check_Callback(hObject, eventdata, handles)


% --- Executes on button press in rg_check.
function rg_check_Callback(hObject, eventdata, handles)


% --- Executes on button press in rb_check.
function rb_check_Callback(hObject, eventdata, handles)


% --- Executes on button press in gb_check.
function gb_check_Callback(hObject, eventdata, handles)


% --- Executes on button press in rgb_check.
function rgb_check_Callback(hObject, eventdata, handles)



function xmin_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function xmin_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function xmax_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function xmax_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function ymin_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function ymin_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function ymax_edit_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function ymax_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
