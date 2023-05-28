clc;clear;close all
%% 初始化窗口
screen = get(0,'ScreenSize'); % 获取屏幕大小
gmain = figure('Color',[1 1 1],'Name','神奇方块','unit','pixel','NumberTitle',...
    'off','MenuBar','none','Resize','off','DeleteFcn','clear all;clc;',...
    'Pos',[screen(3)/4,screen(4)/4,screen(3)*0.5,screen(4)*0.5]);
% 'Pos'后面为[窗口横坐标，窗口纵坐标，窗口宽度，窗口高度]，窗口起始坐标从左下角开始

set(gmain, 'KeyPressFcn', @keypress_callback) % 设置窗口的KeyPressFcn 属性

%% 界面初始化
board = subplot('position',[0.020 0.05 0.45 0.8]);

axis([0 10 0 10])
set(gca,'XTickLabel',[],'YTickLabel',[])
for i = 0:10
    line([i, i], [0, 10], 'Color','black') % 画格线
    line([0, 10], [i, i], 'Color','black')
end
rectangle('Position', [1, 1, 1, 1], 'FaceColor', 'r') % 左下角坐标和长宽
grid on
axis square % 确保为正方形
% axis off % 隐藏坐标轴

board1 = subplot('position',[0.5 0.5 0.225 0.4]);
axis([0 5 0 5])
set(gca,'XTickLabel',[],'YTickLabel',[])
grid on
% axis off

board2 = subplot('position',[0.5 0.05 0.225 0.4]);
axis([0 5 0 5])
set(gca,'XTickLabel',[],'YTickLabel',[])
grid on
% axis off

board3 = subplot('position',[0.75 0.5 0.225 0.4]);
axis([0 5 0 5])
set(gca,'XTickLabel',[],'YTickLabel',[])
grid on
% axis off

board4 = subplot('position',[0.75 0.05 0.225 0.4]);
axis([0 5 0 5])
set(gca,'XTickLabel',[],'YTickLabel',[])
grid on
% axis off

%% 按钮初始化
h1_pushbutton = uicontrol(gmain,'style','pushbutton','unit','normalized','string','新游戏',...
    'fontsize',20,'backgroundcolor',[0.9 0.8 0.8],...
    'ForegroundColor',[0.2 0.2 0.2],'position',[0.02 0.9 0.07 0.05],...
    'FontWeight','bold','callback',...
    '');

h2_pushbutton = uicontrol(gmain,'style','pushbutton','unit','normalized','string','撤回',...
    'fontsize',20,'backgroundcolor',[0.9 0.8 0.8],...
    'ForegroundColor',[0.2 0.2 0.2],'position',[0.1 0.9 0.05 0.05],...
    'FontWeight','bold','callback',...
    '');

%% 变量初始化
board_color = zeros(10,10); % 棋盘颜色 0 白色代表没有方块 1 红色 。。。
squares_1 = zeros(5,5); % 方块1的颜色，0 白色代表没有方块 1 红色 。。。
squares_2 = zeros(5,5); % 方块2的颜色，0 白色代表没有方块 1 红色 。。。
squares_3 = zeros(5,5); % 方块3的颜色，0 白色代表没有方块 1 红色 。。。
squares_4 = zeros(5,5); % 方块4的颜色，0 白色代表没有方块 1 红色 。。。
global choice;
choice = 1;


%% 初始化选择
subplot('position',[0.5 0.5 0.225 0.4]);
squares_1(1,1) = 1;
squares_1(1,2) = 1;
for i = 1:5
    for j = 1:5
        if squares_1(i,j) == 1
            rectangle('Position', [i-1, j-1, 1, 1], 'FaceColor', 'r') % 左下角坐标和长宽
        end
    end
end

subplot('position',[0.5 0.05 0.225 0.4]);
squares_2(1,1) = 1;
squares_2(2,1) = 1;
for i = 1:5
    for j = 1:5
        if squares_2(i,j) == 1
            rectangle('Position', [i-1, j-1, 1, 1], 'FaceColor', 'r') % 左下角坐标和长宽
        end
    end
end
%% 开始游戏
subplot('position',[0.020 0.05 0.45 0.8]);

while true
    waitforbuttonpress;
    [x, y, button] = ginput(1);  % 获取鼠标点击位置
    
    if button == 1  % 左键点击
        x = floor(x);
        y = floor(y);
        fprintf('x: %d, y: %d\n', x, y);
        if x >= 0 && x <= 10 && y >= 0 && y <= 10 % 判断是否在方格内
            if board_color(x+1,y+1) == 0  % 如果方格是白色则绘画
                board_color(x+1,y+1) = 1;
                global choice;
                fprintf('main c: %d\n', choice)
                if choice == 1
                    plot_squares(x,y,squares_1)
                elseif choice == 2
                    plot_squares(x,y,squares_2)
                end
            else
                rectangle('Position', [x, y, 1, 1], 'FaceColor', 'white')
                board_color(x+1,y+1) = 0;
            end
        end
    elseif button == 3  % 右键点击
        break  % 退出循环
    end
end



%% 函数

function plot_squares(x, y, squares)
    for i = 1:5
        for j = 1:5
            if squares(i,j) == 1
                fprintf('i:%d,j:%d\n', i, j);
                rectangle('Position', [x+i-1, y+j-1, 1, 1], 'FaceColor', 'red')
            end
        end
    end
end

% 定义键盘输入的回调函数
function keypress_callback(src, event)
    global choice;
    
    choice = str2num(event.Character);
    fprintf('cb c: %d\n', choice)
end

