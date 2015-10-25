# 第一次编程练习 - 卷积码编译码

## Part I

### 编码器

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

### 映射

- 输入：符号（logical array），效率（2/3）
- 输出：电平（complex array）

### 发射函数

结合上面两个

- 输入：原符号（logical array），是否收尾（logical），效率（2/3），是否CRC（logical）
- 输出：电平（complex array）

### 信道

- 输入：信号（complex array），信噪比（double）
- 输出：加噪声后电平（complex array）

### 硬判决

欧氏距离

- 输入：电平（complex array），效率（2/3）
- 输出：符号（logical array）

### CRC

#### crc_encode

- 输入：原符号（logical array）
- 输出：加 CRC 后符号（logical array）

#### crc_decode

25字节一组

- 输入：加 CRC 后符号（logical array）
- 输出：原符号（logical array），误块率（double）


## Part III

### 译码器

欧氏距离

硬判决，软判决

包括二进制 1/2 和 1/3 效率卷积码

- 输入：加噪声后电平（complex array），效率（2/3），硬判决（logical），CRC多项式（logical array）
- 输出：解码后符号（logical array），误块率（double）   
