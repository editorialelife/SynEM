function [e_1,e_2,interfaceSurfaceNormal] = calculateReferenceCoordinateSystem(interfaceIndices,raw, startPos )
%CALCULATESYNAPSECOORDINATESYSTEM Determine a reference coordinate system.
%Calculates the three base vectors for a coordinate system as a common
%reference frame located for a interface.

%% Calculate the coordinate system using a principal component analysis on a small box around the center of mass of the interface
%restrict interface surface to small box around startPos
interfaceSurface = false(size(raw));
interfaceSurface(interfaceIndices) = true;
box = [startPos - [7,7,3]; startPos + [7,7,3]];
temp = false(size(raw));
temp(box(1,1):box(2,1),box(1,2):box(2,2),box(1,3):box(2,3)) = true;
temp = (temp & interfaceSurface);
indices = find(temp);
[x,y,z] = ind2sub(size(raw),indices);
%do principal component analysis for interfaceSurface. x and y are
%interchanged because of internal functionality of princomp. z is
%multiplied by 28/11.24 to take anisotropy into account.
try
    pcaCoeff = princomp([y,x,28/11.24.*z]);
catch exception
    %sometimes princomp throws exception that covariance matrix is not pos
    %def. This workaround seems to avoid this problem and yields the same
    %result in the other cases.
    fprintf('%s\n',getReport(exception,'basic'));
    C = cov([y,x,28/11.24.*z]);
    pcaCoeff = pcacov(C);
end
e_1 = pcaCoeff(:,1).';
e_2 = pcaCoeff(:,2).';
interfaceSurfaceNormal = pcaCoeff(:,3).';

%calculate gradient for orientation
sigmaGrad = 60./[11.24,11.24,28];
filterSizeGrad = ceil(3*sigmaGrad);
hx = calculateFilter('GaussGradient',sigmaGrad,filterSizeGrad,1);
hy = calculateFilter('GaussGradient',sigmaGrad,filterSizeGrad,2);
hz = calculateFilter('GaussGradient',sigmaGrad,filterSizeGrad,3);
I = single(raw(startPos(1) - filterSizeGrad(1):startPos(1) + filterSizeGrad(1),startPos(2) - filterSizeGrad(2):startPos(2) + filterSizeGrad(2),startPos(3) - filterSizeGrad(3):startPos(3) + filterSizeGrad(3)));
Ix = sum(sum(sum(I.*hx)));
Iy = sum(sum(sum(I.*hy)));
Iz = sum(sum(sum(I.*hz)));
grad = [Iy,Ix,28/11.24*Iz];
interfaceSurfaceNormal = interfaceSurfaceNormal.*(sign(grad*interfaceSurfaceNormal'));

%        % Calculate the coordinate system using pose indexing
%         %define filter parameters
%         raw = single(raw);
%         sigmaD = 24./[11.24,11.24,11.24];
%         filterSizeD = ceil(3*sigmaD);
%         sigmaW = 24./[11.24,11.24,11.24];
%         filterSizeW = ceil(3*sigmaW);
%         sigmaGrad = 60./[11.24,11.24,11.24];
%         filterSizeGrad = ceil(3*sigmaGrad);
% %         %calculate structure tensor around startPos
% %         hx = calculateFilter('GaussGradient',sigmaD,filterSizeD,1);
% %         hy = calculateFilter('GaussGradient',sigmaD,filterSizeD,2);
% %         hz = calculateFilter('GaussGradient',sigmaD,filterSizeD,3);
% %         I = raw(startPos(1) - 5:startPos(1) + 5,startPos(2) - 5:startPos(2) + 5,startPos(3) - 3:startPos(3) + 3);
% %         Ix = imfilter(I,hx);
% %         Iy = imfilter(I,hy);
% %         Iz = imfilter(I,hz);
% %         h = calculateFilter('Gaussian',sigmaW,filterSizeW);
% %         Ixx = imfilter(Ix.^2,h);
% %         Iyy = imfilter(Iy.^2,h);
% %         Izz = imfilter(Iz.^2,h);
% %         Ixy = imfilter(Ix.*Iy,h);
% %         Ixz = imfilter(Ix.*Iz,h);
% %         Iyz = imfilter(Iy.*Iz,h);
% %         structureTensor = [Ixx(6,6,4),Ixy(6,6,4),Ixz(6,6,4); ...
% %                            Ixy(6,6,4),Iyy(6,6,4),Iyz(6,6,4); ...
% %                            Ixz(6,6,4),Iyz(6,6,4),Izz(6,6,4)];
% %         %calculate eigenvectors of structure tensor
% %         [V,D] = eig(structureTensor);
% %         [~,IX] = sort(diag(D));
% %         V = V(:,IX);
%         %calculate hessian around startPos
%         hxx = getFilter('GaussGradient2',sigmaD,filterSizeD,11);
%         hyy = getFilter('GaussGradient2',sigmaD,filterSizeD,22);
%         hzz = getFilter('GaussGradient2',sigmaD,filterSizeD,33);
%         hxy = getFilter('GaussGradient2',sigmaD,filterSizeD,12);
%         hxz = getFilter('GaussGradient2',sigmaD,filterSizeD,13);
%         hyz = getFilter('GaussGradient2',sigmaD,filterSizeD,23);
%         
%         I = raw(startPos(1) - filterSizeD(1):startPos(1) + filterSizeD(1),startPos(2) - filterSizeD(2):startPos(2) + filterSizeD(2),startPos(3) - filterSizeD(3):startPos(3) + filterSizeD(3));
%         
%         Ixx = sum(sum(sum(I.*hxx)));
%         Iyy = sum(sum(sum(I.*hyy)));
%         Izz = sum(sum(sum(I.*hzz)));
%         Ixy = sum(sum(sum(I.*hxy)));
%         Ixz = sum(sum(sum(I.*hxz)));
%         Iyz = sum(sum(sum(I.*hyz)));
%         hessian = [Ixx,Ixy,Ixz;
%                    Ixy,Iyy,Iyz;
%                    Ixz,Iyz,Izz];
%         %calculate eigenvectors of hessian
%         [V,D] = eig(hessian);
%         [~,IX] = sort(diag(abs(D)),'ascend');
%         V = V(:,IX);
%         %calculate gradient
%         hx = calculateFilter('GaussGradient',sigmaGrad,filterSizeGrad,1);
%         hy = calculateFilter('GaussGradient',sigmaGrad,filterSizeGrad,2);
%         hz = calculateFilter('GaussGradient',sigmaGrad,filterSizeGrad,3);
%         I = raw(startPos(1) - filterSizeGrad(1):startPos(1) + filterSizeGrad(1),startPos(2) - filterSizeGrad(2):startPos(2) + filterSizeGrad(2),startPos(3) - filterSizeGrad(3):startPos(3) + filterSizeGrad(3));
%         Ix = sum(sum(sum(I.*hx)));
%         Iy = sum(sum(sum(I.*hy)));
%         Iz = sum(sum(sum(I.*hz)));
%         grad = [Ix,Iy,Iz];
%         %take anisotropy into account
%         grad(3) = 28/11.24.*grad(3);
%         V(3,:) = 28/11.24.*V(3,:);
%         V(:,1) = V(:,1)./sqrt(V(:,1)'*V(:,1));
%         V(:,2) = V(:,2)./sqrt(V(:,2)'*V(:,2));
%         V(:,3) = V(:,3)./sqrt(V(:,3)'*V(:,3));
%         %determine coordinate system
%         interfaceSurfaceNormal = V(:,3)'.*(sign(grad*V(:,3)));
%         e_1 = V(:,2)'.*(sign(grad*V(:,2)));
%         e_1 = e_1 - (interfaceSurfaceNormal*e_1').*interfaceSurfaceNormal;
%         e_2 = cross(interfaceSurfaceNormal,e_1);


end

