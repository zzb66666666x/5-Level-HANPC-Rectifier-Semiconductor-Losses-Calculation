# **5-Level-HANPC-Rectifier-Semiconductor-Losses-Calculation**

## **Introduction**

This MATLAB script calculates the **semiconductor losses** of a **5-level HANPC rectifier**.

Current ripple and DT are **not** considered.

***Linear*** method is used for interpolation.

All variables are in the form of SI Unit.

Due to **inputs** and **outputs**, the script has two versions, **Version A** and **Version B**.

---

## **Inputs and Outputs**

### **Version A**

#### **Inputs**

* Switch_kind
  * switch_voltage
* Lo
* f_switch
* I_amplitude
* Alpha

#### **Outputs**

* Po
* N_num1
* N_num2
* P_S_switch_25
* P_S_conduct_25
* Efficiency

### **Version B**

#### **Inputs**

* Switch_kind
  * switch_voltage
* Lo
* f_switch
* Po

#### **Outputs**

* Iorms
* Alpha
* N_num1
* N_num2
* P_S_switch_25
* P_S_conduct_25
* Efficiency

---

## **Data**

### **Inputs**

+ DATA
  - "DATA/EON"+switch_name+".txt"
  - "DATA/EOFF"+switch_name+".txt"
  - "DATA/VDS"+switch_name+".txt"
  - "DATA/VSD"+switch_name+".txt"

Note: switch_name=switch_material+switch_voltage, e.g.

* 1700
* 3300
* SIC1200
* SIC1700

### **Outputs**

#### **Version A**

resultsA.csv

#### **Version B**

resultsB.csv

---

## **Files**

### **Lists**

* calculatingA.m
* calculatingB.m
* DATA
  - "DATA/EON"+switch_name+".txt"
  - "DATA/EOFF"+switch_name+".txt"
  - "DATA/VDS"+switch_name+".txt"
  - "DATA/VSD"+switch_name+".txt"
* importingData.m
* mainA.m
* mainB.m

### **Dependency**

#### **Version A**

+ mainA.m
  - importingData.m
    - "DATA/EON"+switch_name+".txt"
    - "DATA/EOFF"+switch_name+".txt"
    - "DATA/VDS"+switch_name+".txt"
    - "DATA/VSD"+switch_name+".txt"
  - calculatingA.m

#### **Version B**

+ mainB.m
  - importingData.m
    - "DATA/EON"+switch_name+".txt"
    - "DATA/EOFF"+switch_name+".txt"
    - "DATA/VDS"+switch_name+".txt"
    - "DATA/VSD"+switch_name+".txt"
  - calculatingB.m

---

## **About**

By Xiwei Wang, Zhongbo Zhu

Version 1.0

2019.7.10