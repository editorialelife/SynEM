function h = calculateFilter( type,sigma,siz,varargin)
%CALCULATEFILTER Calculate 3D filters.
%INPUT type: String specifying type of filter
%      sigma: Variance of gaussian in each dimension.
%      siz: The size of the filter in each dimension.
%
%Furthermore, for some types additional arguments are needed:
%
%      type = 'GaussGradient' or type = 'GaussGradient2'
%      dir: direction for gauss gradient (1,2,3) and gauss gradient 2
%           (11,22,33,12,13,23).
%
%      type = 'DifferenceOfGaussian'
%      k: scalar bigger than one for the variance of the second gaussian

%define standard size if it was not specified
if nargin < 3
    siz = ceil(2*sigma);
end

%define grid for filter
if length(siz) == 1
    siz = [siz siz siz];
end
[x,y,z] = ndgrid(-siz(1):siz(1),-siz(2):siz(2),-siz(3):siz(3));

switch type
    case 'Gaussian'
        h = exp(-(x.*x/2/sigma(1)^2 + y.*y/2/sigma(2)^2 + z.*z/2/sigma(3)^2));
        h = h/sum(h(:));
        
    case 'LaplacianOfGaussian'
        h = exp(-(x.*x/2/sigma(1)^2 + y.*y/2/sigma(2)^2 + z.*z/2/sigma(3)^2));
        h = h/sum(h(:));
        arg = (x.*x/sigma(1)^4 + y.*y/sigma(2)^4 + z.*z/sigma(3)^4 - ...
            (1/sigma(1)^2 + 1/sigma(2)^2 + 1/sigma(3)^2));
        h = arg.*h;
        
    case 'DifferenceOfGaussians'
        if nargin < 4
            error('Variance factor for second gaussian not specified. Please enter provide a scalar k>1.');
        end
        k = varargin{1};
        h1 = exp(-(x.*x/2/sigma(1)^2 + y.*y/2/sigma(2)^2 + z.*z/2/sigma(3)^2));
        h1 = h1/sum(h1(:));
        h2 = exp(-(x.*x/2/sigma(1)^2/k^2 + y.*y/2/sigma(2)^2/k^2 + z.*z/2/sigma(3)^2/k^2));
        h2 = h2/sum(h2(:));
        
        h = h1 - h2;
        
    case 'GaussGradient'
        if nargin < 4
            error('Direction for gradient not specified.');
        end
        dir = varargin{1};
        h = exp(-(x.*x/2/sigma(1)^2 + y.*y/2/sigma(2)^2 + z.*z/2/sigma(3)^2));
        h = h/sum(h(:));
        switch dir
            case 1
                h = -x.*h/sigma(1)^2;
            case 2
                h = -y.*h/sigma(2)^2;
            case 3
                h = -z.*h/sigma(3)^2;
            otherwise
                error('Specified direction not valid.');
        end
        
    case 'GaussGradient2'
        if nargin < 4
            error('Direction for gradient not specified');
        end
        dir = varargin{1};
        h = exp(-(x.*x/2/sigma(1)^2 + y.*y/2/sigma(2)^2 + z.*z/2/sigma(3)^2));
        h = h/sum(h(:));
        switch dir
            case 11
                h = h.*(x.^2 -sigma(1)^2)/sigma(1)^4;
            case 22
                h = h.*(y.^2 -sigma(2)^2)/sigma(2)^4;
            case 33
                h = h.*(z.^2 -sigma(3)^2)/sigma(3)^4;
            case 12
                h = h.*(x.*y)/sigma(1)^2/sigma(2)^2;
            case 13
                h = h.*(x.*z)/sigma(1)^2/sigma(3)^2;
            case 23
                h = h.*(y.*z)/sigma(2)^2/sigma(3)^2;
            otherwise
                error('Specified direction not valid.');
        end
    otherwise
        error('Specified type not implemented.');
end

end