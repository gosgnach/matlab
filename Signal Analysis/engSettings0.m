function varargout = engSettings0(varargin)
% ENGSETTINGS0 MATLAB code for engSettings0.fig
%      ENGSETTINGS0, by itself, creates a new ENGSETTINGS0 or raises the existing
%      singleton*.
%
%      H = ENGSETTINGS0 returns the handle to a new ENGSETTINGS0 or the handle to
%      the existing singleton*.
%
%      ENGSETTINGS0('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENGSETTINGS0.M with the given input arguments.
%
%      ENGSETTINGS0('Property','Value',...) creates a new ENGSETTINGS0 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before engSettings0_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to engSettings0_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help engSettings0

% Last Modified by GUIDE v2.5 11-Mar-2014 14:21:16

% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @engSettings0_OpeningFcn, ...
                       'gui_OutputFcn',  @engSettings0_OutputFcn, ...
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
end
% End initialization code - DO NOT EDIT


% --- Executes just before engSettings0 is made visible.
function engSettings0_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to engSettings0 (see VARARGIN)

% Choose default command line output for engSettings0
    handles.output = hObject;

% Update handles structure
    guidata(hObject, handles);

% UIWAIT makes engSettings0 wait for user response (see UIRESUME)
% uiwait(handles.engSettings0);

% Sets the values of the edit boxes to the last entered values for spike,
% trough, burst thresholds.
set(handles.spike_thresh_edit, 'String', getappdata(0, 'cellSpike'));
set(handles.trough_thresh_edit, 'String', getappdata(0, 'cellTrough'));
set(handles.burst_thresh_edit, 'String', getappdata(0, 'cellBurst'));
end    

% --- Outputs from this function are returned to the command line.
function varargout = engSettings0_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;
end


function spike_thresh_edit_Callback(hObject, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function spike_thresh_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function trough_thresh_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function trough_thresh_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function burst_thresh_edit_Callback(hObject, eventdata, handles)

end

% --- Executes during object creation, after setting all properties.
function burst_thresh_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function del_percent_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function del_percent_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'),...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in ok_button.
function ok_button_Callback(hObject, eventdata, handles)
    % Resets the MATLAB root values to the entered thresholds.
    setappdata...
        (0, 'cellSpike'  , str2double(get(handles.spike_thresh_edit , 'String')));
    setappdata...
        (0, 'cellTrough' , str2double(get(handles.trough_thresh_edit, 'String')));
    setappdata...
        (0, 'cellBurst'  , str2double(get(handles.burst_thresh_edit , 'String')));
    close(handles.engSettings);
end

% --- Executes on button press in default_button.
function default_button_Callback(hObject, eventdata, handles)
    % Sets the values of the edit boxes to default threshold values.
    set(handles.spike_thresh_edit, 'String', 0.005);
    set(handles.trough_thresh_edit, 'String', 1.00);
    set(handles.burst_thresh_edit, 'String', 0.05);
end

% --- Executes on button press in cancel_button.
function cancel_button_Callback(hObject, eventdata, handles)
    % Does not set or reset any variables, just closes this GUI.
    close(handles.engSettings);
end