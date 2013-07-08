function plot_stepwise_data_serial( sequence, all_data, ...
				    all_data_contributions,...
				    i_range, j_range, xmax, input_color);
%clf;
colorcode = [0 0 1; 1 0 0];
plotindex = 0;

if ~exist( 'i_range' )
  i_range = [1:size(all_data,1)];
  j_range = [1:size(all_data,2)];
end

if ~exist( 'xmax' )
  xmax = 2;
end

i_min = length( all_data );
j_max = 1;
what_to_plot = [];
lengths = [];
for i = i_range
  pos_in_i_range = find( i_range == i );
  
  for j = j_range
    
    pos_in_j_range = find( j_range == j );
    
    if ( pos_in_i_range <= size( all_data, 1 ) && ...
	 pos_in_j_range <= size( all_data, 2 ) )
      data = all_data{ pos_in_i_range, pos_in_j_range };
      if isfield( data, 'scores' ) 
	if ( i < i_min )
	  i_min = i;
	end
	if ( j > j_max )
	j_max = j;
	end
	what_to_plot = [ what_to_plot; i, j ];
	lengths = [lengths, abs(i-j) ];
      end
    end
  end
end

[dummy, sortindex] = sort(lengths);
what_to_plot = what_to_plot( sortindex, : );
numplots = size( what_to_plot, 1 );

numcols = 5;
numrows = ceil(numplots/numcols);

for q = 1:numplots;
  i = what_to_plot(q,1);
  j = what_to_plot(q,2);

  pos_in_i_range = find( i_range == i );
  pos_in_j_range = find( j_range == j );

  data = all_data{ pos_in_i_range, pos_in_j_range };
  if isfield( data, 'scores' ) 
    plotindex = plotindex + 1;
    subplot(numrows,numcols,plotindex )
    
    rms_col  = find( strcmp( data.score_labels, 'backbone_rms' ) );
    if isempty( rms_col ) 
      rms_col  = find( strcmp( data.score_labels, 'all_rms' ) );
    end
    score_col  = find( strcmp( data.score_labels, 'score' ) );
    h = plot( data.scores( :, rms_col ), data.scores( :, score_col) , ...
	  'ko','markersize',3 );      
    if ( exist('input_color') )
      set( h, 'color', input_color );
    end
    
    
    y_lim = get(gca,'ylim');
    %ylim( min( data.scores(:,score_col) ) +[-1 7.5]);
    minscore = min(data.scores(:,score_col));
    if ishold
      y_lim = [ min( y_lim(1), minscore - 1 ), ...
		max( y_lim(2), minscore + 7.5) ];
    else
      y_lim = minscore + [-1 7.5];
    end
    ylim( y_lim )
    
    hold on
    plot( [xmax xmax],y_lim,'k');
    
    xlim([0 10]);
    set(gca,'xtick',[],'ytick',[]);
    
    if length( sequence ) > 0
      seq_plot = [];
      for k = i_min:j_max
	if ( k >= i && k <= j )
	  seq_plot = [seq_plot,sequence(k)];
	else
	  seq_plot = [seq_plot,' '];
	end
      end
      y_lim = get(gca,'ylim');
      x_lim = get(gca,'xlim');
      h = text( 0, y_lim(1)+0.5, seq_plot ); 
      set(h,'fontsize',6,'fontname','courier','fontweight','bold', ...
	    'color',[1 0.5  0]);
    end
    
    x_lim = get(gca,'xlim');
    if (~exist('input_color') ) 
      h = text( x_lim(1), y_lim(2)+ (y_lim(2)-y_lim(1))*0.1, [num2str(i),'_',num2str(j)] ); 
      set(h,'interpreter','none','fontsize',8,'fontname','courier','fontweight','bold','color','m');
    end
  end
  
  
  if (~exist('input_color') ) 
    hold off
  end
  
end

