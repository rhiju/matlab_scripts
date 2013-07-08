function h = plotline( x, colorcode )

coverage = x(:,1);

color_input = 1;
if ~exist( 'colorcode' )
  color_input = 0;
  colorcode = jet( size( x,2) );
end

for i = 2:size( x,2 )
  y = x(:,i);
  gp = find( y > 0.25 );

  if  color_input
    h =plot( x(gp,1),y(gp),'color',colorcode);
  else
    h =plot( x(gp,1),y(gp),'color',colorcode(i,:));
  end
  
hold on
end

  
hold off