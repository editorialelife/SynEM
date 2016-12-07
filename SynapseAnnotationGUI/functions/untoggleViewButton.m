function handles = untoggleViewButton( hObject,handles )
%UNTOGGLEVIEWBUTTON
set(handles.InterfaceRotatedViewButton,'Value',0);
set(handles.InterfaceXYViewButton,'Value',0);
set(handles.InterfaceXZViewButton,'Value',0);
set(handles.InterfaceYZViewButton,'Value',0);
set(handles.ExploreXYViewButton,'Value',0);
set(handles.ExploreXZViewButton,'Value',0);
set(handles.ExploreYZViewButton,'Value',0);
set(hObject,'Value',1);
end

