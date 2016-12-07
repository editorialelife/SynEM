function [hObject,handles] = developerToolsButton( hObject,handles )
%DEVELOPERTOOLSBUTTON
if strcmp(get(handles.DeveloperToolsButton,'State'),'on')
    set(handles.DeveloperToolsPanel,'Visible','on');
else
    set(handles.DeveloperToolsPanel,'Visible','off');
end

end

