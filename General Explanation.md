# General Explanation

## Basic Concept

### 输入
来自电网的函数，如下面第一个波形的绿线。

![](MarkDown&#32;Picture/General&#32;Explanation/Waveform.jpg)

这个绿线是sin函数，也就是电网给的函数，我们把右侧向上平移了。

### 目的
把这个sin函数转化为相应的PWM波形，也就是图四中画的。在我们实际的项目中，我们输入的不是真正的sin函数，而是加上了共模之后的sin函数，这就是输入端相对于中点的电压。

![电路示意图](MarkDown&#32;Picture/General&#32;Explanation/Circuit.jpg)

---

## 开关的状态
加了共模之后的sin函数，和三角波进行比较，控制开关的开闭。

要注意，上图电路的开关分两类，一个是高频，一个是低频。

### 高频

![](MarkDown&#32;Picture/General&#32;Explanation/High&#32;Frequency&#32;Circuit.jpg)
 
这些是直接和0比较的，不是和载波三角波进行比较的，所以开关的状态是：

![](MarkDown&#32;Picture/General&#32;Explanation/High&#32;Frequency&#32;Switch.jpg)

前半部分，电路中从上到下1，3开通，后半部分2，4开通。

### 低频

![](MarkDown&#32;Picture/General&#32;Explanation/Low&#32;Frequency&#32;Circuit.jpg)
 
这些才是和三角波进行比较的部分；

![](MarkDown&#32;Picture/General&#32;Explanation/Low&#32;Frequency&#32;Switch.jpg)

波形如下，注意：一种颜色的波对应一组开关，一组开关中，开关的内部结构是不同的，有高电压接通，低电压接通两种。

---

## Q&A

### 哪些是变量？
* 我们要控制电流相对电压的相位，-10度到10度
* 要控制载波频率，从900到3600，步长50，单位赫兹
* 控制电流的幅值，100%，90%......20%
* 开关设备不一样

### 三相如何体现？
三相的损耗都是对称的，我们取其中一个，其他几个的损耗也是一样的。