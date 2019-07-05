# 5-Level-HANPC-Rectifier-Semiconductor-Losses-Calculation
## Introduction
This script calculates the **semiconductor losses** of a **5-level HANPC rectifier**.

Current ripple and DT are **not** considered.

All variables are in the form of SI Unit.

---

I want to divide the work by different parts. 
1. Define the coefficients.
2. Write the equations.
3. Define a few functions to get information we need from the raw data (by polynomial function fitting method).
4. Generate the input (in another matlab file).
5. Get the result.