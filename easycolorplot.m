function imagex_color = easycolorplot(data, maxplot, x, y);
% imagex_color = easycolorplot(data, normbins, titles);
%
% data     = name of text file with GelQuant output peak areas; or .mat file with data.
% normbins = residues which are constant across the titration. 
% titles   = titles for the lanes (default 1,2,3, ...)
%

%fprintf(1, '1,2 = change contrast.      d = delete a lane. \n')
%fprintf(1, '  n = normalize to a lane.  o = don''t use a normalize lane \n'); 
%fprintf(1, '  r = reset.                q = quit\n');     

if ~exist( 'x' ) | isempty(x)
  x = 1:size(data,2);
end
if ~exist( 'y' )
  y = 1:size(data,1);
end
if ~exist( 'maxplot' )
  maxplot = max( max( abs(data) ) );
end

%Basic set up.
numres   = size(data,1);
numlanes = size(data,2);
whichpeaks = data(:,1);

data = data(:,[1:numlanes]);
data_orig = data;


data_norm = data;

imagex_color = ones(numres,numlanes,3);
for k=1:numlanes
  for j=1:numres
    colorplot = getcolor(data_norm(j,k),maxplot,maxplot);
    for n=1:3
      imagex_color(j,k,n) = colorplot(n);
    end
  end
end

plot(0,0,'w'); hold on; 
image(x, y, imagex_color); hold off

axis( [min(x) max(x) min(y) max(y)]);

%set(gca,'xtick',1:numlanes,'xticklabel',titles,'ytick',0:10:400,'ygrid','on');
%title([titleplot,' max prot/enhance: ', num2str(maxplot)]);

return;

[x,y,button] = ginput(1);


switch button
 case {'q','Q','z','Z'} %done! quit!
  breakloop = 1;
 case {'d','D'} %delete a lane
  newlanes = [1: round(x)-1 round(x)+1:numlanes];
  data = data(:,newlanes);
  %titles = titles(newlanes,:);
  numlanes = numlanes - 1;
  if (normlane > round(x))
    normlane = normlane - 1;
  end
 case {'r','R'} %reset
  data = data_orig;
  normlanepicked = 0;   
  numlanes = size(data,2);
 case {'n','N'} %pick lane to normalize with
  normlanepicked = 1;
  normlane = round(x);
 case{'o','O'} % don't normalize to a particular lane
  normlanepicked = 0;            
 case{'1'}
  maxplot = maxplot*sqrt(2);
 case{'2'}
  maxplot = maxplot/sqrt(2);
end



function  colorplot = getcolor(colorvalue, maxplot,maxplot2);
if (colorvalue>0)
    colorplot = [1, max(1-colorvalue/maxplot,0), max(1-colorvalue/maxplot,0)] ;
else  
    colorplot = [max(1+colorvalue/abs(maxplot2),0),  max(1+colorvalue/abs(maxplot2),0),1 ] ;
end

