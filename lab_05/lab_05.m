function lab_05
    A = 1.0;
    sigma = 0.5;
    mult = 5;
    step = 0.005;
    t = -mult:step:mult;

    x0 = gauspls(t,A,sigma);

    NA = 0;
    NS = 0.05;
    n1 = normrnd(NA,NS,[1 length(x0)]);
    x1 = x0+n1;

    count = 7;
    M = 0.4;
    n2 = impnoise(length(x0),count,M);
    x2 = x0+n2;

    [B,A] = butter(6,0.05,'low');
    G = gaussfilt(4,20,'low');
    BB = buttfilt(6,20,'low');

    figure(1)
    plot(t,x0,t,x1,t,x2);
    title('Исходные сигналы');
    legend('Без помех','Помеха по Гауссу','Импульсная помеха');

    figure(2)
    plot(t,x0,t,x1-filtfilt(G,1,x1));
    title('Гауссовский фильтр');
    legend('Без помех','Помеха по Гауссу');
   
    figure(3)
    plot(t,x0, t,x2-filtfilt(G,1,x2));
    title('Гауссовский фильтр');
    legend('Без помех', 'Импульсная помеха');

    figure(4)
    plot(t,x0,t,x1-filtfilt(BB,1,x1));
    title('Фильтр Баттеруорта');
    legend('Без помех','Помеха по Гауссу');

    figure(5)
    plot(t,x0,t,x2-filtfilt(BB,1,x2));
    title('Фильтр Баттеруорта');
    legend('Без помех','Импульсная помеха');
end

function y = gauspls(x,A,s)
	y = A * exp(-(x/s).^2);
end

function y = impnoise(size,N,mult)
    step = floor(size/N);
    y = zeros(1,size);
    for i = 1:floor(N/2)
        y(round(size/2)+i*step) = mult*(0.5+rand);
        y(round(size/2)-i*step) = mult*(0.5+rand);
    end
end

function y = buttfilt(D,size,type)
    x = linspace(-size/2,size/2,size);
    if (strcmp(type,'low'))
        y = 1./(1+(x./D).^4);
    elseif (strcmp(type,'high'))
        y = 1./(1+(D./x).^4);
    else
        y = x*sum(x);
    end
    y = y/sum(y);
end

function y = gaussfilt(sigma,size,type)
    x = linspace(-size/2,size/2,size);
    if (strcmp(type,'low'))
        y = exp(-x.^2/(2*sigma^2));
    elseif (strcmp(type,'high'))
        y = 1 - exp(-x.^2/(2*sigma^2));
    else
        y = x*sum(x);
    end
    y = y/sum(y);
end

