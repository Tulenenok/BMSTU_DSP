function lab_08()
    F = 3; 
    dt = 0.05;
    x = -F:dt:F;

    yx = mygaussignal(x);           % сгенерирует гауссовский сигнал
    uxbase = mygaussignal(x);
    ux = mygaussignal(x);
    N = length(yx);                 % длина сигнала (количество точек/элементов)

    a = 0.25;                       % множитель для генерации случайного шума
    epsv = 0.05;                    % порог для фильтрации

    px = a .* rand(1, 7);           % создает вектор из 7 случайных чисел в диапазоне от 0 до 1, умноженных на a (0.25)

    pos = [25, 35, 40, 54, 67, 75, 95]; 
    pxx = length(pos);

    % шум добавляется в определенные позиции pos изначального гауссовского сигнала
    for i = 1 : 1 : pxx
        ux(pos(i)) = ux(pos(i)) + px(i); 
        uxbase(pos(i)) = uxbase(pos(i)) + px(i); 
    end

    for i = 1 : 1 : N
        % Для каждого элемента вычисляется среднее значение его и двух его соседей слева и двух справа
        smthm = mean(ux, i); 
        % Если текущее значение элемента ux(i) больше сглаженного значения, то его значение заменяется на сглаженное значени
        if (abs(ux(i) - smthm) > epsv)
            ux(i) = smthm; 
        end
    end

    figure
    title(['MEAN-функция фильтрации']);
    hold on; 
    plot(x, yx);
    plot(x, uxbase); 
    plot(x, ux); 
    legend('Исходный гауссовский сигнал', 'Искаженных сигнал', 'Сглаженный сигнал');
    hold off; 

     % заново генерируем сигналы и шум
    uxbase = mygaussignal(x);
    ux = mygaussignal(x);

    for i = 1 : 1 : pxx
        ux(pos(i)) = ux(pos(i)) + px(i); 
        uxbase(pos(i)) = uxbase(pos(i)) + px(i); 
    end

    % проделываем такую же операцию как с mean, только теперь используем медианное значение
    for i = 1 : 1 : N
        smthm = med(uxbase, i); 
        if (abs(ux(i) - smthm) > epsv)
            ux(i) = smthm; 
        end
    end

    figure 
    title(['MED-функция фильтрации']);
    hold on; 
    plot(x, yx);
    plot(x, uxbase);
    plot(x, ux);
    legend('Исходный гауссовский сигнал', 'Искаженных сигнал', 'Сглаженный сигнал');
    hold off;
end

function y = mean(ux, i)
    % Функция ищет среднее 5 точкек (2 слева, переданное значение, 2 справа)
    r = 0;
    imin = i - 2; 
    imax = i + 2; 
    for j = imin : 1 : imax
        if (j > 0 && j < (length(ux) + 1))
            r = r + ux(j); 
        end
    end
    r = r / 5; 
    y = r; 
end

function y = med(ux, i)
    % Функция смотрит на элементы слева и справа от текущего элемента (ux(i)) и возвращает меньшее из этих двух
    imin = i - 1; 
    imax = i + 1; 
    ir = 0; 
    if (imin < 1)
        % мы находимся в начале списка, поэтому не можем посмотреть на элемент слева и вместо этого возвращаем элемент справа
        ir = ux(imax); 
    else
        if (imax > length(ux))
            % мы находимся в конце списка и не можем посмотреть на элемент справа, поэтому вместо этого возвращаем элемент слева
            ir = ux(imin); 
        else
            if (ux(imax) > ux(imin))
                ir = ux(imin); 
            else
                ir = ux(imax); 
            end
        end
    end
    y = ir; 
end

function y = mygaussignal(x)
    a = 1;
    sigma = 1; 
    y = a * exp(-x.^2 / sigma ^ 2); 
end
