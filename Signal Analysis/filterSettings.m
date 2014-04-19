function varargout = filterSettings(varargin)
% FILTERSETTINGS MATLAB code for filterSettings.fig
%      FILTERSETTINGS, by itself, creates a new FILTERSETTINGS or raises the existing
%      singleton*.
%
%      H = FILTERSETTINGS returns the handle to a new FILTERSETTINGS or the handle to
%      the existing singleton*.
%
%      FILTERSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTERSETTINGS.M with the given input arguments.
%
%      FILTERSETTINGS('Property','Value',...) creates a new FILTERSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before filterSettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to filterSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help filterSettings

% Last Modified by GUIDE v2.5 11-Mar-2014 15:20:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @filterSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @filterSettings_OutputFcn, ...
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


% --- Executes just before filterSettings is made visible.
function filterSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to filterSettings (see VARARGIN)

% Choose default command line output for filterSettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.order_edit, 'String', 2);
set(handles.sample_edit, 'String', 10000);
set(handles.from_edit, 'String', 100);
set(handles.to_edit, 'String', 1000);
% UIWAIT makes filterSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = filterSettings_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function order_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function order_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function sample_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function sample_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function from_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function from_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function to_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function to_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ok_button.
function ok_button_Callback(hObject, eventdata, handles)
setappdata...
        (0, 'filtOrder'  , str2double(get(handles.order_edit , 'String')));
setappdata...
        (0, 'sampFrequency'  , str2double(get(handles.sample_edit , 'String')));
setappdata...
        (0, 'passFrequency'  , [str2double(get(handles.from_edit , 'String')), str2double(get(handles.to_edit , 'String'))]);
    

% --- Executes on button press in cancel_button.
function cancel_button_Callback(hObject, eventdata, handles)
close(filterSettings);