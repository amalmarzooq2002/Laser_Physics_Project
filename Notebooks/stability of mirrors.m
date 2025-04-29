filename = 'stability.gif'; % GIF file name
frame_delay = 1 / 30; % Frame delay for 30 FPS

% Parameters of the cavity:
rc2 = 24;
rc1 = 10000;
phi = 10;
phase = pi/2;
d = 14;

r0 = 2;
i = linspace(1, 100, 100);

x = [];
y = r0 * sin((pi/phi) * i + phase);

for k = 1:length(i)
    if mod(k, 2) == 0
        if rc2 < 0
            x(k) = -sqrt(rc2^2 - y(k)^2) + d - rc2; 
        else
            x(k) = sqrt(rc2^2 - y(k)^2) + d - rc2; 
        end
    else
        if rc1 < 0
            x(k) = -sqrt(rc1^2 - y(k)^2)  - rc1;
        else 
            x(k) = sqrt(rc1^2 - y(k)^2)  - rc1;
        end
    end
end

theta = linspace(-1 * pi/10, 1 * pi/10, 150);
xc2 = rc2 * cos(theta) + d - rc2;
yc2 = rc2 * sin(theta);

xc1 = rc1 * cos(theta) - rc1;
yc1 = rc1 * sin(theta);

min_y = min(y) - 1;
max_y = max(y) + 1;
min_x = min(x) - 1;
max_x = max(x) + 1;

% Configure figure aesthetics
fig = figure('Color', 'white');
axis([min_x max_x min_y max_y]);
grid on;
hold on;

for j = 1:length(i)
    % Clear only dynamic elements
    cla;

    % Plot cavity circles
    plot(xc2, yc2, 'LineWidth', 2, 'Color', 'black');
    plot(xc1, yc1, 'LineWidth', 2, 'Color', 'black');

    % Re-plot static elements
    axis([min_x max_x min_y max_y]);
    grid on;
    title('Cavity Stability Animation', 'FontSize', 14, 'FontWeight', 'bold');
    xlabel('x (cm)', 'FontSize', 12);
    ylabel('y (cm)', 'FontSize', 12);

    % Annotations
    %text(-rc1 - 20, r0 + 5, sprintf('R_1 = %.1f', rc1), 'Color', 'black', 'FontSize', 10);
    %text(d - 20, r0 + 5, sprintf('R_2 = %.1f', rc2), 'Color', 'black', 'FontSize', 10);
    %text((min_x + max_x) / 2, min_y + 10, sprintf('d = %.1f', d), ...
    %     'Color', 'black', 'FontSize', 10, 'HorizontalAlignment', 'center');

    % Plot motion trajectory
    plot(x(1:j), y(1:j), 'color', '#A020F0', 'LineWidth', 2);

    % Add marker for the current point
    scatter(x(j), y(j), 50, 'blue', 'filled');

    % Add a fading trail
    if j > 10
        trail_indices = max(1, j-10):j-1;
        trail_alpha = linspace(0.1, 0.8, length(trail_indices));
        for t = 1:length(trail_indices)
            scatter(x(trail_indices(t)), y(trail_indices(t)), 30, ...
                    [1, 0, 0] * trail_alpha(t), 'filled');
        end
    end

    % Capture the frame
    drawnow; % Ensure the figure is updated before capturing
    frame = getframe(fig);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256); % Convert to indexed image for GIF

    % Write to the GIF file
    if j == 1
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', frame_delay);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', frame_delay);
    end
end
