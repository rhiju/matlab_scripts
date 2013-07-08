function plot_hubbard( hubbard_txt_files )

for i = 1:length( hubbard_txt_files )
  data = load( hubbard_txt_files{i} );
  all_data{ i } = data;
end

clf

colorcode = [ 0 0 0; 1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 0 1];

%predraw one curve to make legend come out right
for i = 1:length( hubbard_txt_files )
  h = plotline(  all_data{i}(:,1:2), colorcode(i,:) ); hold on
  if ( i == 1) 
    set(h,'linewidth',2)
  end
end

% Draw all curves
for i = 1:length( hubbard_txt_files )
  h = plotline(  all_data{i}, colorcode(i,:) ); hold on

  if ( i == 1) 
    set(h,'linewidth',2)
  end

end

hold off

h = legend(  hubbard_txt_files, 2 );
set(h,'interpreter','none');

axis([0 100 0 16]);
set(gca,'fontsize',12,'fontweight','bold','linewidth',2);

ylabel( 'Distance Cutoff (Angstroms)')
xlabel( 'Percent of Residues (C\alpha)');

hold off
