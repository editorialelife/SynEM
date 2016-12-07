function handles = getHighlightedSegments( handles,imagedSegments )
%GETHIGHLIGHTEDSEGMENTS
%create image with highlighted segments which belong to interface surface
%the first column of innerBoxSegmentsList is highlighted in green
%the second column of innerBoxSegmentsList is highlighted in blue
%the interface surface is highlighted in red

interfaceNumber = handles.currentInterfaceNumber;
subsegNumber1 = handles.data.neighborIDs(interfaceNumber,1);
subsegNumber2 = handles.data.neighborIDs(interfaceNumber,2);
colormap = [0,1,0;0,0,1;1,0,0];
switch handles.view
    case 'explore-xy'
        L = zeros(size(handles.data.raw));
        L(handles.data.segments == subsegNumber1) = 1;
        L(handles.data.segments == subsegNumber2) = 2;
        L(handles.data.interfaceSurfaceList{handles.currentInterfaceNumber}) = 3;
    case 'explore-xz'
        L = zeros(size(handles.data.raw));
        L(handles.data.segments == subsegNumber1) = 1;
        L(handles.data.segments == subsegNumber2) = 2;
        L(handles.data.interfaceSurfaceList{handles.currentInterfaceNumber}) = 3;
        L = permute(L,[1 3 2]);
    case 'explore-yz'
        L = zeros(size(handles.data.raw));
        L(handles.data.segments == subsegNumber1) = 1;
        L(handles.data.segments == subsegNumber2) = 2;
        L(handles.data.interfaceSurfaceList{handles.currentInterfaceNumber}) = 3;
        L = permute(L,[2 3 1]);
    case {'interface-rotated','interface-xy','interface-xz','interface-yz'}
        L = zeros(size(imagedSegments));
        L(imagedSegments == subsegNumber1) = 1;
        L(imagedSegments == subsegNumber2) = 2;
        L(imagedSegments == intmax('uint16')) = 3;
end

%interface surface in imaged segments is labelled by intmax('uint16')
currentHighlightedSegments = zeros(size(L,1),size(L,2),3,size(L,3));
for i=1:size(L,3)
    image = label2rgb(L(:,:,i),colormap);
    currentHighlightedSegments(:,:,:,i) = image;
end

%set highlights segments used in drawImage.m
handles.currentHighlightedSegments = currentHighlightedSegments;

%get alphaData matrix (used in drawImage.m)
handles.alphaData = L > 0;

end

