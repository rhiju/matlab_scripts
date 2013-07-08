function [all_data, all_data_contributions, i_range, j_range ] = ...
    load_stepwise_data_matrix( sequence, filepath, i_range , j_range  );

SEQ_LENGTH = length( sequence );

if ~exist('i_range') 
  MIN_RES = 1;
  MAX_RES = SEQ_LENGTH;
  i_range = MIN_RES:(MAX_RES-1);
  j_range = 2:MAX_RES;
  all_data = cell(SEQ_LENGTH,SEQ_LENGTH);
else
  all_data = cell( length( i_range), length(j_range) );
end


i_range_out = [];
j_range_out = [];
for i = i_range
  pos_in_i_range = find( i_range == i );
  for j =  j_range
    pos_in_j_range = find( j_range == j );
    
    filename = [filepath,'/region_',num2str(i),...
		'_',num2str(j),...
		'_sample.cluster.out'];
    
    if exist( filename )
      fprintf(1,'Reading in %s\n',filename );
      all_data{pos_in_i_range,pos_in_j_range} = load_score_data( filename );
      i_range_out = [ i_range_out i ];
      j_range_out = [ j_range_out j ];
    end
    
    
    pathdir = [filepath,'/REGION_',num2str(i),'_', ...
	       num2str(j),'/'];
    outfilenames = dir( [pathdir,'start_from*inimize.low4000.sc'] );
    data = {};
      for k = 1:size( outfilenames, 1 )
	filename = [pathdir,outfilenames(k).name];
	fprintf(1,'Reading in %s\n',filename );
	data{k} = load_score_data( filename );
      end
      all_data_contributions{pos_in_i_range,pos_in_j_range} = data;
      
  end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_range_out = sort(unique( i_range_out ));
j_range_out = sort(unique( j_range_out ));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rearrange data
for pos_in_i_range = 1:length(i_range_out);
  i = i_range_out( pos_in_i_range );

  for pos_in_j_range = 1:length(j_range_out);
    j = j_range_out( pos_in_j_range );
    
    all_data_out{ pos_in_i_range, pos_in_j_range } = all_data{ i,j};
    all_data_contributions_out{ pos_in_i_range, pos_in_j_range } = all_data_contributions{ i,j};
  
  end
end

all_data = all_data_out;
all_data_contributions = all_data_contributions_out;
i_range = i_range_out;
j_range = j_range_out;