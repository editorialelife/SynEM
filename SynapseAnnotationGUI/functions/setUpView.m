function handles = setUpView( handles )
%SETUPVIEW

switch handles.view
    case 'interface-rotated'
        set(handles.axes1,{'xlim','ylim'},{[0.5 141.5],[0.5 141.5]});
        axes(handles.axes1);
        imshow(zeros(handles.interfaceImageSize));
        zoom(gcf,'reset');
        set(handles.axes1,'DataAspectRatio',[1 1 1]);
        handles = displayInterface(handles);
        s = sprintf('Current view:\nInterface rotated');
        set(handles.ViewStaticText,'String',s);
        set(handles.IdentifyVoxelButton,'Enable','off');
        set(handles.LabelLineButton,'Enable','off');
    case 'interface-xy'
        set(handles.axes1,{'xlim','ylim'},{[0.5 141.5],[0.5 141.5]});
        axes(handles.axes1);
        imshow(zeros(handles.interfaceImageSize));
        zoom(gcf,'reset');
        set(handles.axes1,'DataAspectRatio',[1 1 1]);
        handles = displayInterface(handles);
        s = sprintf('Current view:\nInterface xy');
        set(handles.ViewStaticText,'String',s);
        set(handles.IdentifyVoxelButton,'Enable','on');
        set(handles.LabelLineButton,'Enable','on');
    case 'interface-xz'
        axes(handles.axes1);
        imshow(zeros(handles.interfaceImageSize));
        zoom(gcf,'reset');
        set(handles.axes1,'DataAspectRatio',[1 2.5 1]);
        handles = displayInterface(handles);
        s = sprintf('Current view:\nInterface xz');
        set(handles.ViewStaticText,'String',s);
        set(handles.IdentifyVoxelButton,'Enable','on');
        set(handles.LabelLineButton,'Enable','on');
    case 'interface-yz'
        set(handles.axes1,{'xlim','ylim'},{[0.5 141.5],[0.5 141.5]});
        axes(handles.axes1);
        imshow(zeros(handles.interfaceImageSize));
        zoom(gcf,'reset');
        set(handles.axes1,'DataAspectRatio',[1 2.5 1]);
        handles = displayInterface(handles);
        s = sprintf('Current view:\nInterface yz');
        set(handles.ViewStaticText,'String',s);
        set(handles.IdentifyVoxelButton,'Enable','on');
        set(handles.LabelLineButton,'Enable','on');
    case 'explore-xy'
        handles = displayCube(handles);
        set(handles.IdentifyVoxelButton,'Enable','on');
        set(handles.LabelLineButton,'Enable','on');
    case 'explore-xz'
        handles = displayCube(handles);
        set(handles.IdentifyVoxelButton,'Enable','on');
        set(handles.LabelLineButton,'Enable','on');
    case 'explore-yz'
        handles = displayCube(handles);
        set(handles.IdentifyVoxelButton,'Enable','on');
        set(handles.LabelLineButton,'Enable','on');
end


end

