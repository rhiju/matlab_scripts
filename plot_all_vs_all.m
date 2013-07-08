function plot_all_vs_all( nalign, rms, pdbnames );

lines =figure_out_divisions( pdbnames);

figure(1)
clf;
imagesc( rms );
draw_lines( lines )
draw_axis_labels( pdbnames )

figure(2)
clf;
imagesc( -1*nalign );
draw_lines( lines )
draw_axis_labels( pdbnames )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lines = figure_out_divisions( pdbnames )

current_tag = pdbnames{1}(1:7);
lines = [];
for k = 2:length( pdbnames )
  tag = pdbnames{k}(1:7);

  if ~strcmp( tag, current_tag )
    lines = [lines k-1];    
  end

  current_tag = tag;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function draw_lines( lines )
hold on
ylim = get(gca,'ylim');
for i = lines
  plot( [ylim(1) ylim(2)], [i i]+0.5, 'k-' );
  plot(  [i i]+0.5, [ylim(1) ylim(2)], 'k-' );
end
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function draw_axis_labels( pdbnames );
set(gca,'yticklabel',char(pdbnames),'ytick',1:length(pdbnames),'fontsize',8)
set(gca,'xticklabel',char(pdbnames),'xtick',1:length(pdbnames),'xaxisloc','top','fontsize',8)
xticklabel_rotate;
