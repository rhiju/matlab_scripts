function [ rms, nalign, pdbnames ] = show_all_vs_all( file )

fid = fopen( file );

count = 0;

while ~feof( fid )
  l = fgetl( fid );
  
  if length(l) > 3 

    count = count+1;
    cols = split_string( l );

    if length( cols ) > 2
      pdbname = cols{1};
      pdbnames{count} = pdbname;
      
      if ~isempty( strfind( cols{2}, '.' ) ) %its a float
	for m = 2:length( cols )
	  rms(m-1,count) = str2num( cols{ m } );
	end
      else    
	for m = 2:length( cols )
	  nalign(m-1,count) = str2num( cols{ m } );
	end
      end
    end
    
  else  
    count = 0;
  end

end

plot_all_vs_all( nalign, rms, pdbnames );
