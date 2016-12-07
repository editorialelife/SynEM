function [ handles ] = getInterfaceNumber( handles )
%GETINTERFACENUMBER Read interface number from the text field.

input = str2double(get(handles.InterfaceChooserTextField,'String'));
if isnan(input) || ~(input == floor(input)) || input < 0
    msgbox('Specify a integer number greater than zero.','Error');
    set(handles.InterfaceChooserTextField,'String',handles.currentInterfaceNumber);
else
    %focus on specified interface (or last interface if input exceeds number of
    %interfaces) without rotating the cube
    if input <= size(handles.data.interfaceSurfaceList,1)
        handles.currentInterfaceNumber = input;
    elseif input > size(handles.data.interfaceSurfaceList,1)
        handles.currentInterfaceNumber = length(handles.data.interfaceSurfaceList);
        set(handles.InterfaceChooserTextField,'String',num2str(size(handles.data.interfaceSurfaceList,1)));
    end
end
end

