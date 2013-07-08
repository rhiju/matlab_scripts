function [q,I] = get_crysol( pdb, FORCE_CALCULATE );
% [q,I] = get_crysol( pdb [,  FORCE_CALCULATE] );
%
% simple wrapper around crysol.
%
%

if ~exist( 'FORCE_CALCULATE', 'var' ) FORCE_CALCULATE = 0; end;

tag = strrep( pdb, '.pdb','');
int_file = [tag, '00.int'];

if ~exist( int_file, 'file' ) | FORCE_CALCULATE
  delete( [tag,'0*'] );
  system( ['crysol ', pdb, ' /lm 20' ] );
end

fid = fopen( int_file );

fgetl( fid ); % skip first line
line = fgetl( fid );

q = [];
I = [];

while ~feof( fid )  
  cols = str2num( line );
  q = [q, cols(1) ];
  I = [I, cols(2) ];
  line = fgetl( fid );
end
fclose( fid );
