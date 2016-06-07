function plot_training_loss_vs_iter(regularizers, loss_iter, reg_counter, file_name, save_figure)
fig = figure('visible', 'off');

%%
loss_iter_ave = squeeze(mean(loss_iter, 2));
loss_iter_std = squeeze(std(loss_iter, 1, 2));
iter_nums     = find(loss_iter_ave(1, :));
loss_iter_ave = loss_iter_ave(:, iter_nums);
loss_iter_std = loss_iter_std(:, iter_nums);

%%
errorbar(repmat(iter_nums, reg_counter - 1,1)', loss_iter_ave', loss_iter_std', 'LineWidth', 2)
xlabel('Iteration number', 'FontSize', 14)
ylabel('Total oasis loss (all triplets)', 'FontSize', 14)
set(gcf, 'Color', [1 1 1])
set(fig, 'units','normalized','outerposition',[0 0 1 1])
legend_str = cellstr(num2str(regularizers'));
legend(legend_str)
axis tight

%% Save figure
if save_figure
    saveas(fig, fullfile('../Figures', [file_name, '_loss']), 'png')
end

end


%     iter_nums     = find(loss_iter_ave);
%     loss_iter_ave = loss_iter_ave(iter_nums);
%     loss_iter_std = loss_iter_std(iter_nums);
