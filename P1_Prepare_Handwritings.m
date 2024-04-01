% 중간고사 점수, 기말고사 점수, Pass/Fa11 여부를 분류/예측하기 위한 데이터
clc; clear; close all;

% 텍스트 파일로부터 테이블 형식의 데이터 읽어오기
data = readtable('D1-Pass-or-Fail.txt');
X = table2array(data(:, 1:end-1));
y = table2array(data(:, end));

disp(size(X))
disp(size(y))
clearvars data
%% 예제1) Positive와 Negative를 y값을 기준으로 구분하여 3차원 공간에 플로팅
% y 값을 기준으로 양성+과 음성-을 구분하여 논리 인덱싱
pos = find (y == 1);
neg = find (y == 0);
% 양성과 음성을 별도로 plotting
% scatter3(X (pos, 1), X(pos, 2), y (pos), 'o' , 'LineWidth', 2); hold on;
% scatter3(X(neg, 1), X(neg, 2), y (neg), 'x' , 'LineWidth', 2); hold off;
% grid on; grid minor;

stem3(X (pos, 1), X(pos, 2), y (pos), 'o' , 'LineWidth', 2); hold on;
stem3(X(neg, 1), X(neg, 2), y (neg), 'x' , 'LineWidth', 2); hold off;
grid on; grid minor;

%% 1) 필기체 데이터 준비하기
% 20x20 픽셀로 표현되는 필기체 데이터를 0-9에 mapping하기 위한 데이터
clc; clear; close all;

% 텍스트 파일로부터 테이블 형식의 데이터 읽어오기
data = readtable('D2-Hand-Writings.csv');
X = table2array(data(:, 1:end-1));
y = table2array(data(:, end));

disp(size(X))
disp(size(y))
clearvars data

%% 2) 필기체 데이터 랜덤하게 일부를 뽑아 화면에 출력하기
m1 = size(y, 1);
rand_id = randperm(m1);
sel = X(rand_id(1:100), :);

displayData(sel);
sel_y = y(rand_id(1:100));

clearvars m1 rand_id sel

%% Add) 필기체를 디스플레이 하는 함수
function [h, display_array] = displayData(X, example_width)
% Set example_width automatically if not passed in
if ~exist('example_width', 'var') || isempty(example_width) 
	example_width = round(sqrt(size(X, 2)));
end

% Gray Image
colormap(gray);

% Compute rows, cols
[m, n] = size(X);


example_height = (n / example_width);

% Compute number of items to display
display_rows = floor(sqrt(m));
display_cols = ceil(m / display_rows);

% Between images padding
pad = 1;

% Setup blank display
display_array = - ones(pad + display_rows * (example_height + pad), ...
                       pad + display_cols * (example_width + pad));

% Copy each example into a patch on the display array
curr_ex = 1;
for j = 1:display_rows
	for i = 1:display_cols
		if curr_ex > m 
			break; 
		end
		% Copy the patch
		
		% Get the max value of the patch
		max_val = max(abs(X(curr_ex, :)));
		display_array(pad + (j - 1) * (example_height + pad) + (1:example_height), ...
		              pad + (i - 1) * (example_width + pad) + (1:example_width)) = ...
						reshape(X(curr_ex, :), example_height, example_width) / max_val;
		curr_ex = curr_ex + 1;
	end
	if curr_ex > m
		break; 
	end
end

% Display Image
h = imagesc(display_array, [-1 1]);

% Do not show axis
axis image off

drawnow;

end