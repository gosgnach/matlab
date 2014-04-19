function varargout = engSettings2(varargin)
% ENGSETTINGS2 MATLAB code for engSettings2.fig
%      ENGSETTINGS2, by itself, creates a new ENGSETTINGS2 or raises the existing
%      singleton*.
%
%      H = ENGSETTINGS2 returns the handle to a new ENGSETTINGS2 or the handle to
%      the existing singleton*.
%
%      ENGSETTINGS2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENGSETTINGS2.M with the given input arguments.
%
%      ENGSETTINGS2('Property','Value',...) creates a new ENGSETTINGS2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before engSettings2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to engSettings2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help engSettings2

% Last Modified by GUIDE v2.5 11-Mar-2014 14:18:08

% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @engSettings2_OpeningFcn, ...
                       'gui_OutputFcn',  @engSettings2_OutputFcn, ...
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


% --- Executes just before engSettings2 is made visible.
function engSettings2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to engSettings2 (see VARARGIN)

% Choose default command line output for engSettings2
    handles.output = hObject;

% Update handles structure
    guidata(hObject, handles);

% UIWAIT makes engSettings2 wait for user response (see UIRESUME)
% uiwait(handles.engSettings2);

% Sets the values of the edit boxes to the last entered values for spike,
% trough, burst and percent thresholds.
set(handles.spike_thresh_edit, 'String', getappdata(0, 'spike2'));
set(handles.trough_thresh_edit, 'String', getappdata(0, 'trough2'));
set(handles.burst_thresh_edit, 'String', getappdata(0, 'burst2'));
set(handles.del_percent_edit, 'String', getappdata(0, 'percent2'));
end    

% --- Outputs from this function are returned to the command line.
function varargout = engSettings2_OutputFcn(hObject, eventdata, handles) 
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
        (0, 'spike2'  , str2double(get(handles.spike_thresh_edit , 'String')));
    setappdata...
        (0, 'trough2' , str2double(get(handles.trough_thresh_edit, 'String')));
    setappdata...
        (0, 'burst2'  , str2double(get(handles.burst_thresh_edit , 'String')));
    setappdata...
        (0, 'percent2', str2double(get(handles.del_percent_edit  , 'String')));
    close(handles.engSettings);
end

% --- Executes on button press in default_button.
function default_button_Callback(hObject, eventdata, handles)
    % Sets the values of the edit boxes to default threshold values.
    set(handles.spike_thresh_edit, 'String', 0.05);
    set(handles.trough_thresh_edit, 'String', 0.20);
    set(handles.burst_thresh_edit, 'String', 0.70);
    set(handles.del_percent_edit, 'String', 50);
end

% --- Executes on button press in cancel_button.
function cancel_button_Callback(hObject, eventdata, handles)
    % Does not set or reset any variables, just closes this GUI.
    close(handles.engSettings);
end
