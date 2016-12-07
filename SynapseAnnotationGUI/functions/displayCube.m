function [ handles ] = displayCube( handles )
%DISPLAYCUBE Display the whole dataset and axis aligned reslices.

switch handles.view
    case 'explore-xy'
        handles.currentImageData = handles.data.raw;
        handles = getHighlightedVoxels(handles,handles.voxelLabels);
        set(handles.axes1,'DataAspectRatio',[1 1 1]);
        s = sprintf('Current mode:\nExplore X-Y mode');
        set(handles.ViewStaticText,'String',s);
    case 'explore-xz'
        handles.currentImageData = permute(handles.data.raw,[1 3 2]);
        handles = getHighlightedVoxels(handles,permute(handles.voxelLabels,[1 3 2]));
        set(handles.axes1,'DataAspectRatio',[1 2.5 1]);
        s = sprintf('Current mode:\nExplore X-Z mode');
        set(handles.ViewStaticText,'String',s);
    case 'explore-yz'
        handles.currentImageData = permute(handles.data.raw,[2 3 1]);
        handles = getHighlightedVoxels(handles,permute(handles.voxelLabels,[2 3 1]));
        set(handles.axes1,'DataAspectRatio',[1 2.5 1]);
        s = sprintf('Current mode:\nExplore Y-Z mode');
        set(handles.ViewStaticText,'String',s);
end
set(handles.axes1,{'xlim','ylim'},{[0 size(handles.currentImageData,2)],[0 size(handles.currentImageData,1)]});
handles.currentImage = 1;
handles.lastImage = size(handles.currentImageData,3);
handles = getHighlightedSegments(handles,[]);
handles = setFieldsForNewInterface(handles);
drawImage(handles);
zoom(gcf,'reset');
end

