function varargout = engSelectPlots(varargin)
% ENGSELECTPLOTS MATLAB code for engSelectPlots.fig
%      ENGSELECTPLOTS, by itself, creates a new ENGSELECTPLOTS or raises the existing
%      singleton*.
%
%      H = ENGSELECTPLOTS returns the handle to a new ENGSELECTPLOTS or the handle to
%      the existing singleton*.
%
%      ENGSELECTPLOTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENGSELECTPLOTS.M with the given input arguments.
%
%      ENGSELECTPLOTS('Property','Value',...) creates a new ENGSELECTPLOTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before engSelectPlots_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to engSelectPlots_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help engSelectPlots

% Last Modified by GUIDE v2.5 12-Feb-2014 11:45:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @engSelectPlots_OpeningFcn, ...
                   'gui_OutputFcn',  @engSelectPlots_OutputFcn, ...
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


% --- Executes just before engSelectPlots is made visible.
function engSelectPlots_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to engSelectPlots (see VARARGIN)

% Choose default command line output for engSelectPlots
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes engSelectPlots wait for user response (see UIRESUME)
% uiwait(handles.engSelectPlots);


% --- Outputs from this function are returned to the command line.
function varargout = engSelectPlots_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function first_plot_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function first_plot_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function second_plot_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function second_plot_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ok_button.
function ok_button_Callback(hObject, eventdata, handles)
plot1 = str2double(get(handles.first_plot_edit, 'String'));
plot2 = str2double(get(handles.second_plot_edit, 'String'));
setappdata(0, 'plot1', plot1);
setappdata(0, 'plot2', plot2);
setappdata(0, 'userAccept', 1);
close(handles.engSelectPlots);

% --- Executes on button press in cancel_button.
function cancel_button_Callback(hObject, eventdata, handles)
setappdata(0, 'userAccept', 0);
close(handles.engSelectPlots);
