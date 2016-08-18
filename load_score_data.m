function [data, tags] = load_score_data( file )
% [data, tags] = load_score_data( file )
%
%  data is a structure with two fields:
%   data.scores
%   data.score_labels
%

fid = fopen( file  );
data.scores = [];
data.score_labels = {};
tags = {};

found_score_labels = 0;

count = 0;

while ~feof( fid ) & ~found_score_labels
  l = fgetl( fid );
  
  if length(l) < 2 % problem!
    data = {};
    return;
  end

  cols = split_string( l );
  
  if length( cols ) > 0 & strcmp( cols{1}, 'SCORE:' )
    if (~found_score_labels )
      found_score_labels = 1;
      score_labels = { cols{2: (length(cols)-1)} };
    end
  end
end

fclose( fid );


%%%%%%%%%%%%%%%%%%%%
keyword = 'SCORE';
scorenums = [1:length( score_labels)] + 1;

command = ['grep ',keyword,' ',file,' | ',...
	   'awk ''{print $',num2str(scorenums(1))];
for i = 2: length( scorenums)
  command = [command, ',$',num2str(scorenums(i))];
end
command = [command,...
	   '}'' | grep -v inp | ',...
	   'grep -v R | grep -v H | grep -v score | grep -v pdb | grep -v descr | ', ...
	    ' grep -v total | grep -v S_ > data.txt'];
   
system(command);


scores = load('data.txt');

data.scores = scores;
data.score_labels = score_labels;

%%%%%%%%%%%%%%%%%%%%
command = ['grep ',keyword,' ',file,' | ',...
	   'awk ''{print $',num2str(scorenums(end)+1),'}'' | grep -v description > tags.txt'];
system(command);
tags = read_constructs( 'tags.txt' );

system( 'rm tags.txt' );
system( 'rm data.txt' );