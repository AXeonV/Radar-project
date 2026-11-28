# Problem C

## 0x00 理论说明

### 测距离 R

静止目标的回波比发射信号晚 $\tau=2R/c$，其中 $c$ 是光速。

Chirp 内的瞬时频率 $f(t)=f_c+Kt$，因此混频后的拍频等于当前频率与回波频率之差：

$$
f_b = (f_c+Kt)-[f_c+K(t-\tau)] = K\tau = \frac{2KR}{c}
$$

$$
\boxed{
R = \frac{cf_b}{2K}
}
$$

目标运动时，由于多普勒效应导致回波的频率偏移 $f_d$，拍频对应偏移 $f_d$（两频率之差，回波正偏移一个值导致拍频负偏移一个值）。

考虑回波的频率就用 $f_c$ 近似，由于 $f_c$ 在 GHz 量级故 $f_d$ 误差很小：

$$
f_d = f_0 - f_0\frac{c-v_r}{c+v_r} = \frac{2v_rf_0}{c+v_r}
$$

从拍频中扣除多余的 $f_d$：

$$
\boxed{
R = \frac{c(f_b-f_d)}{2K}
}
$$

在 $v_r \approx 10\ \rm m/s$ 时，$f_d$ 在 0.1kHz 量级，而此题中 $f_b$ 在 kHz 量级，会存在 $>5\%$ 的误差，故需要考虑多普勒效应修正。

### 测速度 v

相邻两条 chirp 相隔 $T_{\rm chirp}$。在两条 chirp 内取同一个采样位置，目标距离变化为 $v_rT_{\rm chirp}$，回波的往返路程就变化 $2v_rT_{\rm chirp}$。

每改变一个波长 $\lambda=c/f_c$，相位变化 $2\pi$，因此：

$$
\frac{\Delta\phi}{2\pi}\lambda = 2 v_r T_{\rm chirp}
$$

$$
\boxed{
v_r = \frac{c\Delta\phi}{4\pi f_c T_{\rm chirp}}
}
$$

## 0x01 测量范围和分辨率

| 指标 | 公式 | Problem A / B（77 GHz） | Problem C / D（2.253 GHz） |
| --- | --- | ---: | ---: |
| 距离最大值 | $R_{\max}=cf_{b,\rm max}/(4K), f_{b,\rm max}=f_s/2$（Nyquist 频率） | $512.0\ \mathrm{m}$ | $324.1\ \mathrm{m}$ |
| 距离分辨率 | $(\Delta f_b)_{\rm min}=1/T_{\rm chirp}=(\Delta R)_{\rm min}2K/c$（DTFS 频点间隔） | $1.000\ \mathrm{m}$ | $0.843\ \mathrm{m}$ |
| 速度最大值 | $\lvert v_r\rvert_{\rm max} = c\lvert \Delta\phi\rvert_{\rm max}/(4\pi f_c T_{\rm chirp}), \lvert \Delta\phi\rvert_{\rm max}=\pi$（$\Delta\phi\in(-\pi, \pi)$） | $121.75\ \mathrm{m/s}$ | $2.164\ \mathrm{m/s}$ |
| 速度分辨率 | $(\Delta v)_{\rm min}=c(\Delta\phi)_{\rm min}/(4\pi f_c T_{\rm chirp}), (\Delta\phi)_{\rm min} 无理论下界$ | $\sim 0\ \mathrm{m/s}$ | $\sim 0\ \mathrm{m/s}$  |

## 0x02 两组雷达的比较

- **测量范围**：Problem A / B 能测量的距离和速度范围更大；
- **分辨率**：Problem C / D 能测量的距离分辨率更精细，速度分辨率相同都没有理论下界；

Problem C / D 中的 chirp 间隔更长，速度变化相较于 Problem A / B 会产生更明显的 $\Delta \phi$，因此能测的理论上限更小（更容易超过 $\pm \pi$），但它**对目标小速度的变化更加敏感**。