clear; clc;

load fmcw_basic_a.mat;

%% 基本参数
c = 3e8;
B = 150e6;
Tchirp = 8e-6;
K = B / Tchirp;
Nr = 1024; Nd = 128;

X = reshape(x1, Nr, Nd); % 每列一个 chirp，共 Nd 条 chirp 样本
Y = fft(X, [], 1); % 对 X 的每列分别做 DTFS

%% 测距离
% 找到 Nd 条 chirp 中最大的幅值
% 由于物体时静止的，Nd 列中最大的位置即代表最确定距离的拍频
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

fb = (maxRow - 1) / Tchirp; % 拍频的频率
                            % a_k => 2pi*k/Nr（离散角频率）* fs（采样频率）=>
                            % 2pi*k/Tchirp（实际角频率）【fs=Nr/Tchirp】
R = c * fb / (2 * K); % 由拍频计算距离

%% 输出 & 作图
fprintf("拍频：%.2f Hz；距离：%.2f m\n", fb, R);

nx = (-floor(Nr/2):ceil(Nr/2)-1) / Tchirp * c / (2 * K);
plot(nx, abs(fftshift(Y(:, maxChirp)))); % DTFT 先通过 fftshift 对齐到原点
xlabel("距离（m）");
ylabel("DTFS 幅值");
grid on;
