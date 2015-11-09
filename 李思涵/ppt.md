PSNR 全部换成 SNR QAQ

## p8 模块设计

### Step 2 电平映射

根据效率选取映射方式，将信号映射到复电平

### Step 3 模拟信道

模拟 AWGN 信道，按照给定的信噪比加噪声

## p9 `crc_encode`

选取多项式为 CRC12

x^12 + x^11 + x^3 + x^2 + x + 1

首先在序列的末尾填 0，直到序列长度变为帧长度的整数倍。

然后对每个帧补零后，用该多项式对每个帧进行模 2 除，将余数添加在该帧后作为校验和。

## p11 `sym_encode`

为了方便软解码，1/2 效率使用 4PSK，1/8 效率使用 8PSK。

图：`4PSK-8PSK.png`

## p12  `transmit`

使用 AWGN 信道，对复电平序列以一定的信噪比加上高斯白噪声。

其中实部和虚部的噪声为独立同分布的高斯分布。

## p15 `crc_decode`

先根据给定帧长，将符号序列的各个帧分割开来。

对每个帧用相同的多项式（CRC12）进行校验。

校验方法为，使用该多项式对帧进行模2除。若能被整除，则认为该帧传输正常，否则则认为该块错误。

## p17 误码图案

我觉得 `error_map_2db.png` 不错 QAQ

## p20 误块率与 SNR

`block_error_linear.png` 或者 `block_error_log.png`

## p22 复基带星座图

`4PSK.png`, `8PSK.png`

## 单元测试

使用 Communications System Toolbox 中的 `poly2trellis`（描述卷积码）， `convenc`（卷机码编码）， `vitdec`（维特比解码），对编解码进行了单元测试。

看看这个能不能当作卖点orz
