
clc;clear;close all
%% 初始化窗口
screen = get(0,'ScreenSize'); % 获取屏幕大小
gmain = figure('Color',[1 1 1],'Name','魔法方块','unit','pixel','NumberTitle',...
    'off','MenuBar','none','Resize','off','DeleteFcn','clear all;clc;',...
    'Pos',[screen(3)/4,screen(4)/4,screen(3)*0.5,screen(4)*0.5]);
% 'Pos'后面为[窗口横坐标，窗口纵坐标，窗口宽度，窗口高度]，窗口起始坐标从左下角开始

set(gmain, 'KeyPressFcn', @keypress_callback) % 设置窗口的KeyPressFcn 属性

%% 界面初始化
board = [0.020 0.05 0.45 0.8];
board1 = [0.5 0.5 0.225 0.4];
board2 = [0.5 0.05 0.225 0.4];
board3 = [0.75 0.5 0.225 0.4];
board4 = [0.75 0.05 0.225 0.4];

subplot('position',board);
axis([0 10 0 10])
set(gca,'XTickLabel',[],'YTickLabel',[])
for i = 0:10
    line([i, i], [0, 10], 'Color','black') % 画格线
    line([0, 10], [i, i], 'Color','black')
end
% rectangle('Position', [1, 1, 1, 1], 'FaceColor', 'r') % 左下角坐标和长宽
grid on
axis square % 确保为正方形
% axis off % 隐藏坐标轴

subplot('position',board1);
axis([0 5 0 5])
set(gca,'XTickLabel',[],'YTickLabel',[])
xlabel('1')
grid on
% axis off

subplot('position',board2);
axis([0 5 0 5])
set(gca,'XTickLabel',[],'YTickLabel',[])
xlabel('2')
grid on
% axis off

subplot('position',board3);
axis([0 5 0 5])
set(gca,'XTickLabel',[],'YTickLabel',[])
xlabel('3')
grid on
% axis off

subplot('position',board4);
axis([0 13 0 13])
set(gca,'XTickLabel',[],'YTickLabel',[],'xcolor',[1,1,1],'ycolor',[1,1,1])
% grid on
xlabel('预览',Color='black')
% axis off

%% 按钮初始化
global new_game step_back
new_game = 0;
step_back = 0;
h1_pushbutton = uicontrol(gmain,'style','pushbutton','unit','normalized','string','新游戏',...
    'fontsize',20,'backgroundcolor',[0.9 0.8 0.8],...
    'ForegroundColor',[0.2 0.2 0.2],'position',[0.02 0.9 0.07 0.05],...
    'FontWeight','bold','callback',...
    'new_game=1');

h2_pushbutton = uicontrol(gmain,'style','pushbutton','unit','normalized','string','撤回',...
    'fontsize',20,'backgroundcolor',[0.9 0.8 0.8],...
    'ForegroundColor',[0.2 0.2 0.2],'position',[0.1 0.9 0.05 0.05],...
    'FontWeight','bold','callback',...
    'step_back = 1');

scores = 0;
pre_scores = 0;
score_textbox = uicontrol(gmain, 'style', 'text','unit','normalized',...
    'position', [0.2 0.9 0.15 0.05],'fontsize',20,'backgroundcolor',[0.9 0.8 0.8]);
set(score_textbox, 'string', sprintf('Scores:%d', scores));

%% 变量初始化
amazing_1 = zeros(5,5); % 口
amazing_1(1,1) = 1;

amazing_2 = zeros(5,5); % 口口
amazing_2(1:2,1) = 1;

amazing_3 = zeros(5,5); % 口
amazing_3(1,1:2) = 1;   % 口

amazing_4 = zeros(5,5); %   口
amazing_4(2,1:2) = 1;   % 口口
amazing_4(1:2,1) = 1;  


amazing_5 = zeros(5,5); % 口口
amazing_5(2,1:2) = 1;   %   口
amazing_5(1:2,2) = 1;

amazing_6 = zeros(5,5); % 口口
amazing_6(1,1:2) = 1;   % 口
amazing_6(1:2,2) = 1;

amazing_7 = zeros(5,5); % 口
amazing_7(1,1:2) = 1;   % 口口
amazing_7(1:2,1) = 1;

amazing_8 = zeros(5,5); %     口
amazing_8(3,1:3) = 1;   %     口
amazing_8(1:3,1) = 1;   % 口口口

amazing_9 = zeros(5,5); % 口口口
amazing_9(3,1:3) = 1;   %     口
amazing_9(1:3,3) = 1;   %     口

amazing_10 = zeros(5,5); % 口口口
amazing_10(1,1:3) = 1;   % 口
amazing_10(1:3,3) = 1;   % 口

amazing_11 = zeros(5,5); % 口
amazing_11(1,1:3) = 1;   % 口
amazing_11(1:3,1) = 1;   % 口口口

amazing_12 = zeros(5,5); % 口口口口
amazing_12(1:4,1) = 1;
                         % 口
amazing_13 = zeros(5,5); % 口
amazing_13(1,1:4) = 1;   % 口
                         % 口

amazing_14 = zeros(5,5); % 口口口口口
amazing_14(1:5,1) = 1;
                         % 口
amazing_15 = zeros(5,5); % 口
amazing_15(1,1:5) = 1;   % 口
                         % 口
                         % 口

amazing_16 = zeros(5,5); % 口口
amazing_16(1:2,1:2) = 1; % 口口

amazing_17 = zeros(5,5); % 口口口
amazing_17(1:3,1:3) = 1; % 口口口
                         % 口口口

amazings = {amazing_17, amazing_16, amazing_15, amazing_14, amazing_13, ...
            amazing_12, amazing_11, amazing_10, amazing_9, amazing_8, amazing_7, ...
            amazing_6, amazing_5, amazing_4, amazing_3, amazing_2, amazing_1};

board_color = zeros(14,14); % 棋盘颜色 0 白色代表没有方块 1 红色 。。。
board_color(11:14,:) = 1;
board_color(:,11:14) = 1;

colours = ["red" "yellow" "green" "blue"];  % 棋盘颜色 1 红色 2 黄色 3 绿色 4 蓝色
num_colour = 4;

squares_1 = cell2mat(amazings(randi([1, 17], 1, 1)))*randi(num_colour);
squares_2 = cell2mat(amazings(randi([1, 17], 1, 1)))*randi(num_colour);
squares_3 = cell2mat(amazings(randi([1, 17], 1, 1)))*randi(num_colour);

squares_4 = cell2mat(amazings(randi([1, 17], 1, 1)))*randi(num_colour);
squares_5 = cell2mat(amazings(randi([1, 17], 1, 1)))*randi(num_colour);
squares_6 = cell2mat(amazings(randi([1, 17], 1, 1)))*randi(num_colour);

all_mat = zeros(10,25);
all_mats(1) = {all_mat}; 

global choice;
choice = 1;

gamover1 = 3;
gamover2 = 0;

%% 开始游戏
while true
    % 新游戏按钮
    if new_game == 1
        board_color(1:10,1:10) = zeros(10,10);
        subplot('position',board);
        plot_squares(0,0,board_color,colours);
                
        squares_1 = squares_4;
        squares_2 = squares_5;
        squares_3 = squares_6;
        squares_4 = cell2mat(amazings(randi([1, 17], 1, 1)))*randi(num_colour);
        squares_5 = cell2mat(amazings(randi([1, 17], 1, 1)))*randi(num_colour);
        squares_6 = cell2mat(amazings(randi([1, 17], 1, 1)))*randi(num_colour);
        new_game = 0;
        scores = 0;
        set(score_textbox, 'string', sprintf('Scores:%d', scores));
    end

    if step_back == 1
        all_mat = cell2mat(all_mats(end-1));
        
        board_color(1:10,1:10) = all_mat(1:10,1:10);
        subplot('position',board);
        plot_squares(0,0,board_color,colours);

        squares_1 = all_mat(1:5,11:15);
        squares_2 = all_mat(1:5,16:20);
        squares_3 = all_mat(1:5,21:25);
        squares_4 = all_mat(6:10,11:15);
        squares_5 = all_mat(6:10,16:20);
        squares_6 = all_mat(6:10,21:25);
        scores = pre_scores;
        set(score_textbox, 'string', sprintf('Scores:%d', scores));
        step_back = 0;
    end

    % 判定预览是否为空，为空则刷新
    if all(all((squares_1 == zeros(5,5)))) && all(all((squares_2 == zeros(5,5)))) && all(all((squares_3 == zeros(5,5))))
        squares_1 = squares_4;
        squares_2 = squares_5;
        squares_3 = squares_6;
        squares_4 = cell2mat(amazings(randi([1, 17], 1, 1)))*randi(num_colour);
        squares_5 = cell2mat(amazings(randi([1, 17], 1, 1)))*randi(num_colour);
        squares_6 = cell2mat(amazings(randi([1, 17], 1, 1)))*randi(num_colour);
    end

    % 绘制预览
    subplot('position',board1);
    plot_squares(0,0,squares_1,colours)
    subplot('position',board2);
    plot_squares(0,0,squares_2,colours)
    subplot('position',board3);
    plot_squares(0,0,squares_3,colours)
    
    subplot('position',board4);
    plot_squares(1,7,squares_4,colours)
    plot_squares(1,1,squares_5,colours)
    plot_squares(7,7,squares_6,colours)


    waitforbuttonpress;
    [x, y, button] = ginput(1);  % 获取鼠标点击位置
    if button == 1  % 左键点击
        x = floor(x);
        y = floor(y);
%         fprintf('x: %d, y: %d\n', x, y);
        if x >= 0 && x < 10 && y >= 0 && y < 10 % 判断是否在方格内
            % 用逻辑数组判定是否有空余位置
            board_color_part = board_color(x+1:x+5,y+1:y+5);
            board_color_part_logic = logical(board_color_part);
            squares = zeros(5,5);
            if choice == 1
                squares = squares_1;
            elseif choice == 2
                squares = squares_2;
            elseif choice == 3
                squares = squares_3;
            end
            squares_logic = logical(squares);
            sum_squares = board_color_part + squares;
            sum_squares_logic = logical(sum_squares);

            % 如果符合条件，就填补,并清空已填补预览
            if board_color_part_logic + squares_logic == sum_squares_logic
                board_color(x+1:x+5,y+1:y+5) = sum_squares;
                if choice == 1
                    squares_1 = zeros(5,5);
                elseif choice == 2
                    squares_2 = zeros(5,5);
                elseif choice == 3
                    squares_3 = zeros(5,5);
                end
            end

            % 判断是否填满一行或者一列
            board_color_logic = logical(board_color(1:10,1:10));
            num_row = 0;
            num_col = 0;
            for i = 1:10
                if sum(board_color_logic(i,:))==10
                    board_color(i,1:10) = 0;
                    num_row  =  num_row + 1;
                end
                if sum(board_color_logic(:,i))==10
                    board_color(1:10,i) = 0;
                    num_col = num_col + 1;
                end
            end
            % 分数计算，消去的行数加上消去的列数减去重叠部分
            pre_scores = scores;
            scores = scores + 10 * (num_row + num_col) - num_row * num_col;
            set(score_textbox, 'string', sprintf('Scores:%d', scores));


            % 重新上色
            subplot('position',board);
            for i = 1:10
                for j = 1:10
                    if board_color(i,j) == 0
                        rectangle('Position', [i-1, j-1, 1, 1], 'FaceColor', 'white') % 左下角坐标和长宽
                    else
                        rectangle('Position', [i-1, j-1, 1, 1], 'FaceColor', colours(board_color(i,j))) % 左下角坐标和长宽
                    end
                end
            end

            %储存当前状态
            all_mat(1:10,1:10) = board_color(1:10,1:10);
            all_mat(1:5,11:15) = squares_1;
            all_mat(1:5,16:20) = squares_2;
            all_mat(1:5,21:25) = squares_3;
            all_mat(6:10,11:15) = squares_4;
            all_mat(6:10,16:20) = squares_5;
            all_mat(6:10,21:25) = squares_6;
            all_mats(end+1) = {all_mat};
            
        end
    elseif button == 3  % 右键点击
        break  % 退出循环
    end
end
%% 函数

function plot_squares(x,y,squares, colours)
    for i = 1:size(squares,1)
        for j = 1:size(squares,2)
            if squares(i,j) == 0
%                 fprintf('i:%d,j:%d\n', i, j);
                rectangle('Position', [x+i-1, y+j-1, 1, 1], 'FaceColor', 'white')
            else
                rectangle('Position', [x+i-1, y+j-1, 1, 1], 'FaceColor', colours(squares(i,j)))
            end
        end
    end
end

% 定义键盘输入的回调函数
function keypress_callback(src, event)
    global choice;
    choice = str2num(event.Character);
end

