clc;
close all;
clear all;

% Nhập bán kính r và cường độ dòng điện
r = input('Nhập bán kính vòng dây (m): '); 
I = input('Nhập cường độ dòng điện (A): ');
N = 100; % Số điểm trên vòng dây

mu0 = 4 * pi * 1e-7;  % Hằng số từ trường trong chân không

% Tạo tọa độ vòng dây tròn nằm trên mặt phẳng xy
theta = linspace(0, 2*pi, N);
Xw = r * cos(theta);  % Tọa độ x của vòng dây
Yw = r * sin(theta);  % Tọa độ y của vòng dây
Zw = zeros(size(Xw)); % Tọa độ z của vòng dây (vòng dây nằm trên mặt phẳng xy)

% Tạo lưới tọa độ cho các điểm trong không gian xung quanh vòng dây
[x, y, z] = meshgrid(linspace(-2*r, 2*r, 20), linspace(-2*r, 2*r, 20), linspace(-2*r, 2*r, 20));

% Khởi tạo các thành phần từ trường Bx, By, Bz
Bx = zeros(size(x));
By = zeros(size(y));
Bz = zeros(size(z));

% Tính từ trường tại từng điểm theo định lý Biot-Savart
for i = 1:N-1
    % Xác định phần tử dòng điện dl và vị trí trung điểm của đoạn dl
    dlx = Xw(i+1) - Xw(i);
    dly = Yw(i+1) - Yw(i);
    dlz = Zw(i+1) - Zw(i);
    midX = (Xw(i+1) + Xw(i)) / 2;
    midY = (Yw(i+1) + Yw(i)) / 2;
    midZ = (Zw(i+1) + Zw(i)) / 2;
    
    % Tính vector khoảng cách R từ trung điểm dl đến các điểm trong không gian
    Rx = x - midX;
    Ry = y - midY;
    Rz = z - midZ;
    R = sqrt(Rx.^2 + Ry.^2 + Rz.^2);
    
    % Tránh chia cho 0 (các điểm quá gần vòng dây)
    R(R == 0) = 1e-12;
    
    % Tích chéo giữa dl và R
    dBx = (I * mu0 / (4 * pi)) * (dly .* Rz - dlz .* Ry) ./ (R.^3);
    dBy = (I * mu0 / (4 * pi)) * (dlz .* Rx - dlx .* Rz) ./ (R.^3);
    dBz = (I * mu0 / (4 * pi)) * (dlx .* Ry - dly .* Rx) ./ (R.^3);
    
    % Cộng dồn từ trường từ từng phần tử dl
    Bx = Bx + dBx;
    By = By + dBy;
    Bz = Bz + dBz;
end

% Vẽ đồ thị 3D toàn cảnh vòng dây và từ trường
figure(1);
plot3(Xw, Yw, Zw, 'r', 'LineWidth', 2);
hold on;
quiver3(x, y, z, Bx, By, Bz, 1, 'Color', [0.5, 0.5, 0.5]); % Vector màu xám nhạt
axis equal;
xlabel('Trục x');
ylabel('Trục y');
zlabel('Trục z');
title('Từ trường B của vòng dây theo định lý Biot-Savart');
set(gcf, 'color', 'white');

% Chỉnh sửa góc nhìn để dễ quan sát
view(30, 30);

% Vẽ mặt phẳng xy
figure(2);
idz = ceil(size(z, 3) / 2); % Chỉ số ở giữa cho z = 0
quiver(x(:, :, idz), y(:, :, idz), Bx(:, :, idz), By(:, :, idz), 1, 'Color', [0.5, 0.5, 0.5]); % Vector màu xám nhạt
hold on;
plot(Xw, Yw, 'r', 'LineWidth', 1.5); % Vòng dây màu đỏ
axis equal;
xlabel('Trục x');
ylabel('Trục y');
title('Từ trường B trong mặt phẳng xy');
set(gcf, 'color', 'white');
