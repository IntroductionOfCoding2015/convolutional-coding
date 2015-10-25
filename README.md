# 第一次编程练习 - 卷积码编译码

## Part I

### 编码器 `conv_encode`

包括二进制 1/2 和 1/3 效率卷积码

- 输入：原符号（logical array），是否收尾（logical），效率（2/3），CRC多项式（logical array）
- 输出：编码后符号（logical array）

### 画图

- 1/2, 1/3, 硬/软判决误比特率 - 信道信噪比
- 10个典型误码图案
- 文件传输失败率 - 信噪比
- 文件整体差错率 - 信道信噪比
- 信道发端/收端复基带星座图


## Part II

### 符号 - 电平映射

1/2 效率使用 4PSK，1/8 效率使用 8PSK。

#### 映射 `sym_encode`

- 输入：符号（logical array），效率（2/3）
- 输出：电平（complex array）

#### 解映射（硬判决） `sym_decode`

根据欧氏距离

- 输入：电平（complex array），效率（2/3）
- 输出：符号（logical array）

### 信道 `transmit`

- 输入：信号（complex array），信噪比（double）
- 输出：加噪声后电平（complex array）

### 发射函数 `conv_send`

结合上面两个

- 输入：原符号（logical array），是否收尾（logical），效率（2/3），CRC多项式（logical array）
- 输出：电平（complex array）

### 接收函数 `conv_receive`

`conv_decode` 的别名。

### CRC

#### 编码 `crc_encode`

会在序列末尾填 0，直到序列长度变为帧长度的整数倍。

- 输入：原符号（logical array），CRC多项式（logical array），
  帧长度（课件中为 25 * 8）
- 输出：加 CRC 后符号（logical array）

#### 解码 `crc_decode`

25字节一组

- 输入：加 CRC 后符号（logical array），CRC多项式（logical array），
  帧长度（课件中为 25 * 8）
- 输出：原符号（logical array），误块率（double）


## Part III

### 译码器 `conv_decode`

欧氏距离

硬判决，软判决

包括二进制 1/2 和 1/3 效率卷积码

- 输入：加噪声后电平（complex array），是否收尾（logical），效率（2/3），CRC多项式（logical array），硬判决（logical）
- 输出：解码后符号（logical array），误块率（double）   
