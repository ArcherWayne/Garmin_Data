clc
clear 
close all

% 备注: 想要绘制的数据
% 距离/心率/配速/坡度调整配速
% 步频/垂直振幅比/平均触地时间
% 功率

Activities = readmatrix('Activities.csv');

Dates = datetime(Activities(1:end, 2), 'ConvertFrom', 'excel');

Distance = Activities(1:end, 5);
Calories = Activities(1:end, 6);
Duration = Activities(1:end, 7);
AverageHR = Activities(1:end, 8);
MaxHR = Activities(1:end, 9);
AverageCadence = Activities(1:end, 11);
MaxCadence = Activities(1:end, 12);
AveragePace = Activities(1:end, 13);
BestPace = Activities(1:end, 14);
TotalAscent = Activities(1:end, 15);
TotalDecent = Activities(1:end, 16);
AverageStep = Activities(1:end, 17);
AverageVerticalStrideRatio = Activities(1:end, 18);
AverageVerticalSwing = Activities(1:end, 19);
AverageGroundContactTime = Activities(1:end, 20);
AverageSlopeAdjustedPace = Activities(1:end, 21);
AveragePower = Activities(1:end, 24);
MaxPower = Activities(1:end, 25);

testpace = ReadPaceData(BestPace);

WeeklyTotalDistance = GetWeekDataTotal(Dates, Distance);
% 总跑量
DrawBarPlot(Dates, Distance, '周跑量/km')
% DrawBarPlot(Dates, AverageHR, '平均心率/bts')

%% 
% 按照星期求解周总量
function weekdatatotal = GetWeekDataTotal(dates, data)
	weeks = week(dates);
	months = month(dates);
	weekdatatotal = accumarray([months(:) weeks(:)], data(:));
end

% 绘制按周分布的三维柱状图
function DrawBarPlot(dates, values, zlabelstring)

	% 获取年份、月份和每月的第几周
	years = year(dates);
	months = month(dates);
	weeks = week(dates);

	% 计算每月的第几周
	startOfMonth = dates - days(day(dates) - 1); % 每个月的第一天
	weekInMonth = week(dates) - week(startOfMonth) + 1; % 月内的周数
	weekInMonth(weekInMonth > 5) = 5;

	% 按年份、月份和月内周数分组并求和
	[uniqueYears, ~, yearIdx] = unique(years);
	[uniqueMonths, ~, monthIdx] = unique(months);

	% 最大周数设置为5周
	maxWeeks = 5;
	weeklySum = zeros(length(uniqueYears), length(uniqueMonths), maxWeeks);

	% 将数据填入三维数组
	for i = 1:length(values)
		y = yearIdx(i);
		m = monthIdx(i);
		w = weekInMonth(i);
		weeklySum(y, m, w) = weeklySum(y, m, w) + values(i);
	end

	% 使用 bar3 函数绘制三维柱状图
	figure;
	for y = 1:length(uniqueYears)
		subplot(1, length(uniqueYears), y); % 为每一年创建一个子图
		bar3(squeeze(weeklySum(y, :, :))'); % 转置数据以适应 bar3 的要求
		xlabel('月份');
		ylabel('月内周数');
		zlabel(zlabelstring);
		title(['年份: ', num2str(uniqueYears(y))]);
		set(gca, 'XTick', 1:length(uniqueMonths), 'XTickLabel', {'1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'});
		set(gca, 'YTick', 1:maxWeeks);
		set(gca, 'FontName', 'Microsoft YaHei', 'FontSize', 12, 'FontWeight', 'bold', 'FontAngle', 'italic');
	end
end

% 绘制心率与配速的关系图
function DrawHRandPacePlot(dates, AverageHR, MaxHR, AveragePace, BestPace)
	figure;
	yyaxis left
	bar(dates, AverageHr)
	ylabel('心率/bpm')

	yyaxis right
	bar(dates, AveragePace)
	ylabel('配速')
end

% 读取配速数据
function durationStrArray = ReadPaceData(durationString)
	% 定义一个函数来将常规数字转换为持续时间格式
	function durationStr = convertToDuration(num)
		minutes = floor(num); % 取整数部分作为分钟
		seconds = round((num - minutes) * 60); % 取小数部分转换为秒
		durationStr = sprintf('%d''%d''''', minutes, seconds); % 格式化为持续时间字符串
	end

	% 使用数组对每个持续时间常规数字进行转换
	durationStrArray = arrayfun(@convertToDuration, durationString, 'UniformOutput', false);
end