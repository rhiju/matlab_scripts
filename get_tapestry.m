function [data, construct_names ] = get_tapestry(  sequence, offset, ...
							     mutpos, ...
							     temperature, ONLY_LIBRARY1)

if ~exist( 'ONLY_LIBRARY1'); ONLY_LIBRARY1 = 0; end;

command = ['get_tapestry.py ', sequence,' -temperature ', num2str(temperature),'  -offset ',num2str( offset ),...
	   ' -mutpos '];

for k = mutpos
  command = [ command, ' ',num2str(k) ] ;
end

if ONLY_LIBRARY1
  command = [ command, ' -only_library1' ];
end

command = [ command, ' > data.txt' ];
system( command );

fid = fopen( 'data.txt' );

count = 0;
while ~feof( fid ) 

  l = fgetl( fid );
  cols = split_string( l );

  count = count+1;
  name = cols{1};
  fprintf(1, [name,'\n']);
  construct_names{ count } = name;
  for m = 1:length( cols )-1
    data(count,m) = str2num( cols{m+1} );
  end
  
end
fclose( fid );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
image( data*100 );

colormap( 1 - gray(100) );

gp = find( mod( [1:length( sequence )]+offset, 5 ) == 0 );
    
set( gca, 'yticklabel', char( construct_names ), ...
	  'ytick', [1:length(construct_names )],...
	  'xticklabel', gp+offset,...
	  'xtick',gp );

num_muts = length( mutpos );
l = [ 0, 1, 1+num_muts, 1+2*num_muts, 1+3*num_muts];
make_lines_horizontal( l, 'k' )

