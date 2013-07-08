function h_symbol = color_varna_eps( varna_eps_info, d, maxplot, maxplot2, seqpos );

if isstr( varna_eps_info )
  [h_symbol] = load_varna_eps( varna_eps_info );
  %h_symbol = h_symbol( 3:2:end ); % these are the colored circles.
else
  h_symbol = varna_eps_info;
end  
  
if ~exist( 'seqpos' )
  seqpos = 1:length(d);
end

for m = 1:length( h_symbol )
  set( h_symbol(m), 'facecolor',[0.5 0.5 0.5] );  
end

for i = 1:length( d )
  colorplot =getcolor( d(i), maxplot, maxplot2 );
  set( h_symbol(seqpos(i)), 'facecolor',colorplot );
end

axis off
set(gcf,'color','w' );

return;

function  colorplot = getcolor(colorvalue, maxplot,maxplot2);
if (colorvalue>0)
    colorplot = [1, max(1-colorvalue/maxplot,0), max(1-colorvalue/maxplot,0)] ;
else  
    colorplot = [max(1+colorvalue/abs(maxplot2),0),  max(1+colorvalue/abs(maxplot2),0),1 ] ;
end


