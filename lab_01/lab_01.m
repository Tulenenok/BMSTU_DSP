clc;
sigma = 1.5; % параметр гауссовского распределения (см. формулу)
L = 1;       % параметр прямоугольного импульса

% Дискретные сигналы
% n = input('Input number of samples: ');  % количество выборок
% dt = input('Input sample step: ');       % шаг дискретизации
n = 5
dt = 1

t_max = dt*(n-1)/2;  % половина диапазона времени для дискретизации
t = -t_max:dt:t_max; % вектор времени (с учетом введенного пользователем шага) 

gauss_discrete = exp(-(t/sigma).^2);  % сигнал Гаусса на основе вектора t
rect_discrete = zeros(size(t));       % создать вектор из 0 размера t
rect_discrete(abs(t) - L < 0) = 1;    % внутри интервала [-L, L] точкам присваивается значение 1

% Исходные сигналы
% все тоже самое, что и в дискретных, только шаг очень маленький
x = -t_max:0.005:t_max;
gauss_ref = exp(-(x/sigma).^2);
rect_ref = zeros(size(x));
rect_ref(abs(x) - L < 0) = 1;

% Восстановленные сигналы
gauss_restored = zeros(1, length(x));
rect_restored = zeros(1, length(x));
for i=1:length(x)
   for j = 1:n
       gauss_restored(i) = gauss_restored(i) + gauss_discrete(j) * sin((x(i)-t(j))/dt * pi) / ((x(i)-t(j))/dt * pi);
       rect_restored(i) = rect_restored(i) + rect_discrete(j) * sin((x(i)-t(j))/dt * pi) / ((x(i)-t(j))/dt * pi);
   end
end

figure;

subplot(2,1,1);
title('Прямоугольный импульс');
hold on;
grid on;
plot(x, rect_ref, 'k');
plot(x, rect_restored, 'b');
plot(t, rect_discrete, '.m');
legend('Исходная', 'Восстановленная', 'Дискретная');

subplot(2,1,2);
title('Сигнал Гаусса');
hold on;
grid on;
plot(x, gauss_ref, 'k');
plot(x, gauss_restored, 'b');
plot(t, gauss_discrete, '.m');