clear; clc;

%% 基本参数
c = 3e8;
fc = 2.253e9;
B = 178e6;
Tchirp = 1/65;
fs = 50e3;
K = B / Tchirp;
Nr = floor(fs * Tchirp); Nd = 128;

%% 模拟合成
% 一个目标的匀速运动
R0 = 60.3; % 第一个 chirp 开始时的距离（m）
v0 = 0.30; % 径向速度（m/s），远离为正

% 模拟发射和回波，混频生成 IF 样本
tInC = (1:Nr)' / fs; % 每条 chirp 内的采样时刻，列向量
tCSt = (0:Nd-1) * Tchirp; % 每条 chirp 的起始时刻，行向量
tau = 2 * (R0 + v0 * (tInC + tCSt)) / c; % tInC + tCSt 定位总运动时间
                                         % 发生混频的两个波时间差为 tau
                                         % Nr * Nd 矩阵
phi = @(s) 2*pi * (fc*s + K*s.^2/2); % phi(s): f(s) = fc + Ks 的相位
X = 0.5 * exp(1j * (phi(tInC) - phi(tInC - tau))); % 合成不同时刻的 IF 样本
                                                   % Nr * Nd 矩阵
% 注意：这里通过计算相位合成的 X 已经携带多普勒效应带来的频移

%% 测速度
v = zeros(1, Nd-1);
for chirp = 2:Nd
    % 计算相邻两 chirp 之间的相位差，对齐第一个样本，保证时间间隔为 Tchirp
    dphi = angle(X(1, chirp) * conj(X(1, chirp - 1)));
    % 由相位差计算径向速度 v
    v(chirp - 1) = (c / fc) * dphi / (4*pi * Tchirp);
end

%% 测距离（考虑多普勒效应）
fd = fc - fc * (c - v) / (c + v); % 回波的多普勒频移

Y = fft(X, [], 1); % 对 X 的每列分别做 DTFS
% 找到 Nd 条 chirp 中最大的幅值
% 近似物体静止求 R，以下类似 Problem_A
maxA = -Inf;
maxRow = 1;
maxChirp = 1;
for chirp = 1:Nd
    for row = 1:ceil(Nr/2) % 后半段是对称的，幅值相同
        A = abs(Y(row, chirp));
        if (A > maxA)
            maxA = A;
            maxRow = row;
            maxChirp = chirp;
        end
    end
end

fb = (maxRow - 1) * fs / Nr; % 拍频的频率，fs/Nr=1/Tchirp，与 Problem_A 等价
R = c * (fb - fd) / (2 * K); % 从拍频中扣除多普勒频移，计算距离
tRef = tCSt(maxChirp) + mean(tInC); % tCSt(maxChirp)：选中 chirp 起始时间
                                    % mean(tInc)：用中点估算 chirp 内信号
                                    % 发出到触碰所用时间
Rini = R - v(1) * tRef; % 扣除选中 chirp 触碰到目标的时间内目标的移动得到初始距离

%% 输出 & 作图
fprintf("拍频：%.2f Hz；多普勒频移：%.2f Hz\n", fb, fd);
fprintf("触碰时距离：%.2f m；初始距离：%.2f m\n", R, Rini);
fprintf("径向速度：%.2f m/s\n", v(1));

subplot(2, 1, 1);
nx = ((-floor(Nr/2):ceil(Nr/2)-1) * fs / Nr - fd) * c / (2 * K);
plot(nx, abs(fftshift(Y(:, maxChirp))));
xlabel("距离（m）");
ylabel("DTFS 幅值");
grid on;

subplot(2, 1, 2);
plot(2:Nd, round(v, 3), '.-');
xlabel("chirp（#）");
ylabel("径向速度（m/s）");
grid on;
