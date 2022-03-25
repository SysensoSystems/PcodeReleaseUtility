function varargout = pcodeGUI(varargin)
% GUI for PCode Release Utility
% Guide Generated Info

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @pcodeGUI_OpeningFcn, ...
    'gui_OutputFcn',  @pcodeGUI_OutputFcn, ...
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
%--------------------------------------------------------------------------
function pcodeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for pcodeGUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% Set the initial conditions
set(handles.data_table,'Data',{});
set(handles.singleFile_radioButton,'value',0);
set(handles.multipleFile_radioButton,'value',1);
set(handles.help_checkbox,'value',1);
setappdata(handles.generate_button,'packagingMethod','multiple');
%--------------------------------------------------------------------------
function varargout = pcodeGUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
%--------------------------------------------------------------------------
% CustomCallbacks
function addFiles_button_Callback(hObject, eventdata, handles)
% Add button callback
[name,fpath] = uigetfile('MultiSelect', 'on');
if(fpath == 0)
    return;
end
fnames = strcat(fpath,name);
iAddFiles(fnames,handles);
%--------------------------------------------------------------------------
function addFolder_button_Callback(hObject, eventdata, handles)
directoryName = uigetdir(pwd, 'Pick the Development Folder');
if(directoryName == 0)
    return;
end
dirStruct = dir(directoryName);
fnames = {};
for ii = 1:length(dirStruct)
    if ~dirStruct(ii).isdir
        fnames = [fnames fullfile(directoryName,dirStruct(ii).name)];
    end
end
iAddFiles(fnames,handles);
%--------------------------------------------------------------------------
function addFolderAll_button_Callback(hObject, eventdata, handles)
mainDirectoryName = uigetdir(pwd, 'Pick the Development Folder');
if(mainDirectoryName == 0)
    return;
end
fnames = {};
pathStr = genpath(mainDirectoryName);
while ~isempty(pathStr)
    [directoryName,pathStr] = strtok(pathStr,';');
    dirStruct = dir(directoryName);
    for ii = 1:length(dirStruct)
        if ~dirStruct(ii).isdir
            fnames = [fnames fullfile(directoryName,dirStruct(ii).name)];
        end
    end
    pathStr = pathStr(2:end);
end
iAddFiles(fnames,handles);
%--------------------------------------------------------------------------
% Remove button callback
function remove_button_Callback(hObject, eventdata, handles)
tableData = get(handles.data_table,'Data');
if(isempty(tableData))
    return;
end
selectedRow = getappdata(handles.data_table,'selectedRow');
if size(tableData,1) < selectedRow
    selectedRow = size(tableData,1);
end
tableData(selectedRow,:) = [];
set(handles.data_table,'Data',tableData);
if isempty(tableData)
    set(handles.topFileSelect_pop,'String','select');
else
    set(handles.topFileSelect_pop,'String',tableData(:,2));
end
%--------------------------------------------------------------------------
% Clear button callback
function clear_button_Callback(hObject, eventdata, handles)
set(handles.data_table,'Data',{});
set(handles.topFileSelect_pop,'String','select');
%--------------------------------------------------------------------------
% Browse button callback
function browse_button_Callback(hObject, eventdata, handles)
path = uigetdir();
if (path == 0)
    path = '';
    msgbox('Please select directory!');
end
set(handles.outputPath_edit,'string',path);
%--------------------------------------------------------------------------
% Run button callback
function generate_button_Callback(hObject, eventdata, handles)

% Get the release utility information
outputPath = get(handles.outputPath_edit,'string');
tableData = get(handles.data_table,'Data');
allFiles = tableData(:,2);
helpRequired = tableData(:,1);
for ii = 1:length(helpRequired)
    if isequal(helpRequired{ii},1)
        helpChoice(ii) = true;
    else
        helpChoice(ii) = false;
    end
end
packagingMethod = getappdata(handles.generate_button,'packagingMethod');
retainFolder_checkbox_Callback(hObject, eventdata, handles)
if get(handles.retainFolder_checkbox,'Value') == 1
    folderOption = 'retain';
else
    folderOption = 'flat';
end
selectedIndex = get(handles.topFileSelect_pop,'value');
mainFunctionPath = tableData{selectedIndex,2};
% Call the Release utility function
try
    releaseUtility(packagingMethod,folderOption,allFiles,helpChoice,mainFunctionPath,outputPath);
catch exceptionObj
    errordlg(exceptionObj.message,'Run Error','modal');
end
%--------------------------------------------------------------------------
% Close button callback
function close_button_Callback(hObject, eventdata, handles)
close(gcf);
%--------------------------------------------------------------------------
function topFileSelect_pop_Callback(hObject, eventdata, handles)
tableData = get(handles.data_table,'Data');
selectedIndex =  get(handles.topFileSelect_pop,'value');

if ~isempty(regexp(tableData{selectedIndex,2},'\.m$'))
    for ii = 1:length(tableData)
        tableData{ii,1} = '';
    end
    tableData{selectedIndex,1} = true;
else
    msgbox('Please select an .m file');
end
set(handles.data_table,'Data',tableData);
%--------------------------------------------------------------------------
function topFileSelect_pop_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%--------------------------------------------------------------------------
function retainFolder_checkbox_Callback(hObject, eventdata, handles)

%--------------------------------------------------------------------------
function help_checkbox_Callback(hObject, eventdata, handles)
isHelpRequired = get(hObject,'Value');
if isequal(isHelpRequired,1)
    isHelpRequired = true;
else
    isHelpRequired = false;
end
tableData = get(handles.data_table,'Data');
len = size(tableData);
for ii = 1:len(1)
    if ~isempty(tableData{ii,1})
        tableData{ii,1} = isHelpRequired;
    end
end
set(handles.data_table,'Data',tableData);

%--------------------------------------------------------------------------
function singleFile_radioButton_Callback(hObject, eventdata, handles)
if get(hObject,'value') == 1
    try
        tableData = get(handles.data_table,'Data');
    catch
    end
    if isempty(tableData)
        warndlg('Please select the files','Select Files');
        set(hObject,'value',0);
        return;
    end
    len = size(tableData);
    popData = {};
    for ii = 1:len(1)
        popData = [popData; tableData{ii,2}];
        tableData{ii,1} = '';
    end
    tableData{1,1} = true;
    set(handles.data_table,'Data',tableData);
    set(handles.topFileSelect_pop,'enable','on');
    set(handles.topFileSelect_pop,'String',popData');
    setappdata(handles.generate_button,'packagingMethod','single');
end
%--------------------------------------------------------------------------
function multipleFile_radioButton_Callback(hObject, eventdata, handles)
warning('OFF', 'MATLAB:hg:uicontrol:ValueMustBeWithinStringRange');
if get(hObject,'value') == 1
    try
        tableData = get(handles.data_table,'Data');
    catch
    end
    if isempty(tableData)
        warndlg('Please select the files','Select Files');
        set(hObject,'value',0);
        return;
    end
    set(handles.topFileSelect_pop,'String','select');
    len = size(tableData);
    isHelpRequired = get(handles.help_checkbox,'value');
    if isequal(isHelpRequired,1)
        isHelpRequired = true;
    else
        isHelpRequired = false;
    end
    for ii = 1:len(1)
        if ~isempty(regexp(tableData{ii,2},'\.m$'))
            tableData{ii,1} = isHelpRequired;
        else
            tableData{ii,1} = '';
        end
    end
    set(handles.data_table,'Data',tableData);
    setappdata(handles.generate_button,'packagingMethod','multiple');
end
%--------------------------------------------------------------------------
function main_figure_CreateFcn(hObject, eventdata, handles)
%--------------------------------------------------------------------------
function data_table_CellSelectionCallback(hObject, eventdata, handles)
tableData = get(handles.data_table,'Data');
len = size(tableData);
try
    if len(1) > 1
        selectedRow = eventdata.Indices(1);
    else
        selectedRow = 1;
    end
    setappdata(hObject,'selectedRow',selectedRow);
catch
end
%--------------------------------------------------------------------------
% data_table_CellEditCallback
function data_table_CellEditCallback(hObject, eventdata, handles)
tableData = get(handles.data_table,'Data');
len = size(tableData);
if len(1) > 1
    selectedRow = eventdata.Indices(1);
else
    selectedRow = 1;
end
setappdata(hObject,'selectedRow',selectedRow);
%--------------------------------------------------------------------------
function iAddFiles(fnames,handles)
if ~(iscell(fnames))
    fnames = {fnames};
end
tableData = get(handles.data_table,'Data');
for ii = 1:length(fnames)
    row = [false,fnames(ii)];
    tableData = [tableData; row];
end
len = size(tableData);
for ii = 1:len(1)
    if ~isempty(regexp(tableData{ii,2},'\.m$'))
        tableData{ii} = true;
    else
        tableData{ii} = '';
    end
end
set(handles.data_table,'Data',tableData);
set(handles.topFileSelect_pop,'String','select');
