function varargout = engFileImport(varargin)
% ENGFILEIMPORT MATLAB code for engFileImport.fig
%      ENGFILEIMPORT, by itself, creates a new ENGFILEIMPORT or raises the existing
%      singleton*.
%
%      H = ENGFILEIMPORT returns the handle to a new ENGFILEIMPORT or the handle to
%      the existing singleton*.
%
%      ENGFILEIMPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENGFILEIMPORT.M with the given input arguments.
%
%      ENGFILEIMPORT('Property','Value',...) creates a new ENGFILEIMPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before engFileImport_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to engFileImport_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help engFileImport

% Last Modified by GUIDE v2.5 19-Mar-2014 09:02:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @engFileImport_OpeningFcn, ...
                   'gui_OutputFcn',  @engFileImport_OutputFcn, ...
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

% --- Executes just before engFileImport is made visible.
function engFileImport_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to engFileImport (see VARARGIN)

% Choose default command line output for engFileImport
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes engFileImport wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = engFileImport_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


function root1_edit_Callback(hObject, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function root1_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function import_edit_Callback(hObject, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function import_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function path_file_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function path_file_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
    [file_name, path_name] = uigetfile({...
    '*.atf;*.abf', 'All Axon Files (*.atf. *.abf)';...
    '*.atf','Axon Text Files (*.atf)';...
    '*.abf','Axon Binary Files (*.abf)'}, 'Please select ENG data file');
    handles.path_and_file = strcat(path_name, file_name);
    guidata(hObject, handles);
    set(handles.path_file_edit, 'String', handles.path_and_file);
end

% --- Executes on button press in import_button.
function import_button_Callback(hObject, eventdata, handles)

    root1_col = str2double(get(handles.root1_edit, 'String'));
    root2_col = str2double(get(handles.root2_edit, 'String'));
    root3_col = str2double(get(handles.root3_edit, 'String'));
    cell_col = str2double(get(handles.cell_edit, 'String'));
    first = str2double(get(handles.from_edit, 'String'));
    last = str2double(get(handles.to_edit, 'String'));
    span = str2double(get(handles.span_edit, 'String'));
    factor = str2double(get(handles.downsample_edit, 'String'));

    if (isnan(first))
        first = 0;
    end

    if (isnan(last))
        last = 'e';
    end

    try
        [data, si] =...
        abfload(handles.path_and_file, 'start', first, 'stop', last);
        if (isnan(root1_col))
            root1 = NaN;
        else
            root1 = data(:,root1_col);
        end

        if (isnan(root2_col))
            root2 = NaN;
        else
            root2 = data(:,root2_col);
        end

        if (isnan(root3_col))
            root3 = NaN;
        else
            root3 = data(:,root3_col);
        end
        
        if (isnan(cell_col))
            cell = NaN;
        else
            cell = data(:,cell_col);
        end

        sample = (1 / (si*10 ^ -6));

        if (~isnan(cell))
            time = (0 : (1/sample) : (numel(cell) - 1)/sample)';
        elseif (~isnan(root1))
            time = (0 : (1/sample) : (numel(root1) - 1)/sample)';
        elseif (~isnan(root2))
            time = (0 : (1/sample) : (numel(root2) - 1)/sample)';
        elseif (~isnan(root3))
            time = (0 : (1/sample) : (numel(root3) - 1)/sample)';
        else
            disp('No data sets were recognized, please try again.')
        end

        setappdata(0, 'factor', factor)
        setappdata(0, 'span', span);
        setappdata(0, 'root1', root1);
        setappdata(0, 'root2', root2);
        setappdata(0, 'root3', root3);
        setappdata(0, 'cell', cell);
        setappdata(0, 'time', time);
        set(handles.import_edit, 'String', 'Import Successful');
    catch err
        set(handles.import_edit, 'String', 'Import Unsuccessful');
    end
end


function cell_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function cell_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function from_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function from_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function to_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function to_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function root2_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root2_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function root3_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function root3_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

function span_edit_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function span_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function downsample_edit_Callback(hObject, eventdata, handles)

end

% --- Executes during object creation, after setting all properties.
function downsample_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --------------------------------------------------------------------
function tools_menu_Callback(hObject, eventdata, handles)
end

% --------------------------------------------------------------------
function filter_menu_Callback(hObject, eventdata, handles)
    filterSettings;
end
