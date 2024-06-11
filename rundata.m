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

% 总跑量
DistanceWeeklyTotal = GetWeeklyDataTotal(Dates, Distance);
DrawBarPlot(Dates, DistanceWeeklyTotal, '周跑量/km');
WeeklyCalories = GetWeeklyDataTotal(Dates,	Calories);

%% 

% 按照星期求解周总量
function weeklydatatotal = GetWeeklyDataTotal(dates, data)
	years = year(dates);
	months = month(dates);
	weeks = week(dates);

	startOfMonth = dates - days(day(dates) - 1);
	weekInMonth = week(dates) - week(startOfMonth) + 1;
	weekInMonth(weekInMonth > 5) = 5;

	[uniqueYears, ~, yearIdx] = unique(years);
	[uniqueMonths, ~, monthIdx] = unique(months);

	maxWeeks = 5;
	weeklydatatotal = zeros(length(uniqueYears), length(uniqueMonths), maxWeeks);

	for i = 1:length(data)
		y = yearIdx(i);
		m = monthIdx(i);
		w = weekInMonth(i);
		weeklydatatotal(y, m, w) = weeklydatatotal(y, m, w) + data(i);
	end
end


% 按照星期求解周平均
function weeklydataaverage = GetWeeklyDataAverage(dates, data)
	years = year(dates);
	months = month(dates);
	weeks = week(dates);

	startOfMonth = dates - days(day(dates) - 1);
	weekInMonth = week(dates) - week(startOfMonth) + 1;
	weekInMonth(weekInMonth > 5) = 5;

	[uniqueYears, ~, yearIdx] = unique(years);
	[uniqueMonths, ~, monthIdx] = unique(months);

	maxWeeks = 5;
	weeklydatatotal = zeros(length(uniqueYears), length(uniqueMonths), maxWeeks);
	weeelydataaverage = zeros(length(uniqueYears), length(uniqueMonths));

	for i = 1:length(data)
		y = yearIdx(i);
		m = monthIdx(i);
		w = weekInMonth(i);
		weeklydatatotal(y, m, w) = weeklydatatotal(y, m, w) + data(i);
	end
end


% 绘制按周分布的三维柱状图
function DrawBarPlot(dates, weeklyData, zlabelstring)
	years = year(dates);
	months = month(dates);
	weeks = week(dates);

	startOfMonth = dates - days(day(dates) - 1);
	weekInMonth = week(dates) - week(startOfMonth) + 1;
	weekInMonth(weekInMonth > 5) = 5;

	[uniqueYears, ~, yearIdx] = unique(years);
	[uniqueMonths, ~, monthIdx] = unique(months);

	maxWeeks = 5;

	figure;
	for y = 1:length(uniqueYears)
		subplot(1, length(uniqueYears), y); 
		bar3(squeeze(weeklyData(y, :, :))'); 
		xlabel('月份');
		ylabel('月内周数');
		zlabel(zlabelstring);
		title(['年份: ', num2str(uniqueYears(y))]);
		set(gca, 'XTick', 1:length(uniqueMonths), 'XTickLabel', {'1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'});
		set(gca, 'YTick', 1:maxWeeks);
		set(gca, 'FontName', 'Microsoft YaHei', 'FontSize', 12, 'FontWeight', 'bold', 'FontAngle', 'italic');
	end
end

% 读取配速相关数据
function PaceString = ConvertPaceDataAsString(data)
	PaceString = cell(length(data), 1); 
	for i = 1:length(data)
		dt = datestr(datetime(data(i), 'ConvertFrom', 'excel'));
		PaceString{i} = dt(end-7:end-3); 
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

