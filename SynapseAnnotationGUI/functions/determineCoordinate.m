function coordinates = determineCoordinate( handles,x,y )
%CALCULATECOORDINATE Calculate coordinate in current view.

switch handles.view
    case 'interface-xy'
        z = handles.currentImage;
        startPos = calculateStartPos(handles.data.segments,handles.data.interfaceSurfaceList{handles.currentInterfaceNumber});
        x_global = startPos(1) + y - 71;
        y_global = startPos(2) + x - 71;
        z_global = startPos(3) + z - 31;
    case 'interface-xz'
        startPos = calculateStartPos(handles.data.segments,handles.data.interfaceSurfaceList{handles.currentInterfaceNumber});
        x_global = startPos(1) + y - 71;
        y_global = startPos(2) + handles.currentImage - 61;
        z_global = startPos(3) + x - 36;
    case 'interface-yz'
        startPos = calculateStartPos(handles.data.segments,handles.data.interfaceSurfaceList{handles.currentInterfaceNumber});
        x_global = startPos(1) + handles.currentImage - 61;
        y_global = startPos(2) + y - 71;
        z_global = startPos(3) + x - 36;
    case 'explore-xy'
        x_global = y;
        y_global = x;
        z_global = handles.currentImage;
    case 'explore-xz'
        x_global = y;
        y_global = handles.currentImage;
        z_global = x;
    case 'explore-yz'
        x_global = handles.currentImage;
        y_global = y;
        z_global = x;
end
coordinates = [x_global,y_global,z_global];


end

