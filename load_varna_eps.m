function [h_symbol,h_text, h_line] = load_varna_eps( filename );

fid = fopen( filename );

l = fgetl( fid );
line_count = 0;
text_count = 0;
symbol_count = 0;

pos1 = [0 0];
pos2 = [0 0];
linewidth = 1.0;
rgbcolor = [0.0 0.0 0.0 ];

h_text = [];
h_symbol = [];
h_lines = [];
while ~feof( fid )
  
  if length( l ) > 0

    cols = split_string( l );
    
    if length( cols ) > 0 
      if sum( strcmp(cols, 'moveto') ) > 0
	pos1 = [str2num( cols{1} ), str2num( cols{2} ) ];
      elseif sum( strcmp(cols, 'lineto') )  > 0
	pos2 = [str2num( cols{1} ), str2num( cols{2} ) ];
	line_count = line_count + 1;
	h_line( line_count ) = plot( [pos1(1) pos2(1)], [pos1(2) pos2(2)], 'color', rgbcolor, 'linewidth', linewidth );	
	hold on
	h = h_line;
      elseif sum( strcmp(cols, 'setlinewidth') )  > 0
	linewidth = str2num(cols{1});
      elseif sum( strcmp(cols, 'setrgbcolor') )  > 0
	rgbcolor = [ str2num(cols{1}), str2num(cols{2}), str2num(cols{3}) ];
      elseif sum( strcmp(cols, 'txtcenter') )  > 0
	text_count = text_count+1;
	h_text( text_count ) = text( pos1(1), pos1(2), cols{1}(2:end-1) );
	set(h_text,'fontsize',8,'fontweight','bold','horizontalalignment','center','clipping','on' );
	%fprintf( 'Found text at: %d, %d\n', pos1(1), pos1(2) );
	h = h_text;
	
	% this acts as a filter to find circles that really go with the text.
	for m = 1:length( h_symbol )
	  pos_symbol = get(h_symbol(m),'Position');
	  d =  norm( pos1 - (pos_symbol( [1 2] )+0.5*pos_symbol([3 4])) );
	  if d < 1
	    found_text_with_symbol(m) = 1;
	    break;
	  end
	end

      elseif sum( strcmp(cols, 'arc') )  > 0
	radius = str2num( cols{3} );
	pos1 = [ str2num(cols{1}), str2num( cols{2} ) ];

	if ( norm(pos1)> 0 )
	  %fprintf( 'Found circle at: %d, %d\n', pos1(1), pos1(2) );
	  
	  symbol_count = symbol_count + 1;
	  h_symbol( symbol_count ) = ...
	      rectangle('Position', [pos1(1)-radius,pos1(2)-radius,2*radius,2*radius],...
			'Curvature', [1 1 ]);
	  %pause;
	  h = h_symbol;
	  found_text_with_symbol( symbol_count ) = 0;
	end
      elseif sum( strcmp(cols, 'fill') )  > 0
	if length( h_symbol ) > 0
	  set(h_symbol( end ),'facecolor',rgbcolor);
	end
      end
    end
  
  end

  l = fgetl( fid );

end

h_symbol = h_symbol( find( found_text_with_symbol ) );

axis equal