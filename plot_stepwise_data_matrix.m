function plot_stepwise_data_matrix( sequence, all_data, all_data_contributions,...
				    i_range, j_range,xmax);

clf;
colorcode = [0 0 1; 1 0 0];

I_LENGTH = length( i_range );
J_LENGTH = length( j_range );

if ~exist('xmax')
  xmax = 4;
end

for i = i_range

  pos_in_i_range = find( i_range == i );
  
  for j = j_range
    
    pos_in_j_range = find( j_range == j );

    if ( pos_in_i_range <= size( all_data, 1 ) && pos_in_j_range <= size( all_data, 2 ) )

    i_shift = pos_in_i_range; % - min( i_range ) + 1;
    j_shift = pos_in_j_range; %j - min( j_range ) + 1;
    
    plotindex = j_shift + J_LENGTH * ( i_shift - 1);

    data_contributions = all_data_contributions{ pos_in_i_range, ...
		    pos_in_j_range };

    for k = 1: length( data_contributions )
      subplot(I_LENGTH,J_LENGTH, plotindex);
      data = data_contributions{k};

      if isfield( data, 'scores' ) 
	rms_col  = find( strcmp( data.score_labels, 'backbone_rms' ) );
	score_col  = find( strcmp( data.score_labels, 'score' ) );
	plot( data.scores( :, rms_col ), data.scores( :, score_col) , ...	      
	    '.','markersize',1,'color',colorcode(k,:) );      
	hold on;
      end
    end
    
    data = all_data{ pos_in_i_range, ...
		     pos_in_j_range };
    if isfield( data, 'scores' ) 
      subplot(I_LENGTH,J_LENGTH, plotindex);
      rms_col  = find( strcmp( data.score_labels, 'backbone_rms' ) );
      if  isempty(rms_col)
	rms_col  = find( strcmp( data.score_labels, 'all_rms' ) );
      end
      score_col  = find( strcmp( data.score_labels, 'score' ) );      
      plot( data.scores( :, rms_col ), data.scores( :, score_col) , ...
	    'ko','markersize',3 );      
    
      y_lim = get(gca,'ylim');
      ylim( min( data.scores(:,score_col) ) +[-1 6]);
      y_lim = get(gca,'ylim');
      
      hold on
      plot( [2 2],y_lim,'k');

      xlim([0 xmax]);
      set(gca,'xtick',[],'ytick',[]);

    end


        
    if ( abs(i-j) > 1 & ~isempty( data ) & length(sequence)>0)
      subplot(I_LENGTH,J_LENGTH, plotindex);
      y_lim = get(gca,'ylim');
      x_lim = get(gca,'xlim');

      stoppos = [ mean(x_lim), y_lim(1)+0.0 ];
      startpos  = [ mean(x_lim), y_lim(1)-1.5 ];
      h = arrow( startpos, stoppos,'length',4 );
      set(h,'facecolor','r','edgecolor','r','linewidth',2);

      stoppos = [ x_lim(1)+0.0, mean(y_lim) ];
      startpos  = [ x_lim(1)-1.5, mean(y_lim) ];
      h = arrow( startpos, stoppos,'length',4);
      set(h,'facecolor','b','edgecolor','b','linewidth',2);
    
    end

    if ~isempty( data )
      subplot(I_LENGTH,J_LENGTH, plotindex);

      if length( sequence ) > 0
	seq_plot = '';
	for k = min(i_range):max(j_range)
	  if ( k >= i && k <= j )
	    seq_plot = [seq_plot,sequence(k)];
	  else
	    seq_plot = [seq_plot,' '];
	  end
	end
	y_lim = get(gca,'ylim');
	h = text( 0, y_lim(1)+0.5, seq_plot ); 
	set(h,'fontsize',8,'fontname','courier','fontweight','bold', ...
	      'color',[1 0.5  0]);
      end
      h = text( 0, y_lim(2)+1.0, [num2str(i),'_',num2str(j)] ); 
      set(h,'interpreter','none','fontsize',8,'fontname','helvetica','fontweight','bold','color','m');
    end
    
    hold off

    end
  end
end

