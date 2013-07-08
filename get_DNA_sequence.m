function DNA_sequence = get_DNA_sequence( start_sequence );

T7_promoter = 'TTCTAATACGACTCACTATA';
DNA_sequence = T7_promoter;
for i = 1:length( start_sequence )
  if ( start_sequence(i) == 'U' ) 
    DNA_sequence = [ DNA_sequence, 'T' ];
  else
    DNA_sequence = [ DNA_sequence, start_sequence(i) ];
  end
end

