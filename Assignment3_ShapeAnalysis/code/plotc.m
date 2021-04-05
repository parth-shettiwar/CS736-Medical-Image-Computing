%Just a function for connecting last and inital points in plots. 
%Reference https://stackoverflow.com/questions/8545077/connecting-final-and-initial-point-in-simple-x-y-plot-plotting-closed-curve-po
function plotc(x,y,varargin)  
    x = [x(:) ; x(1)];   
    y = [y(:) ; y(1)];  
    plot(x,y,varargin{:})  
end