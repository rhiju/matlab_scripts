function b = basename( filename )
% b = basename( filename )

cols = split_string( filename, '/' );
b = cols{end};
