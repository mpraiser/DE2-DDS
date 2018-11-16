import numpy as np
import matplotlib.pyplot as plt
from sympy import *

bit_x = 13
bit_sin = 10

head=r'''-- Copyright (C) 1991-2009 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- Quartus II generated Memory Initialization File (.mif)
'''
x = np.arange(0, 2 * np.pi, 2 * np.pi / 2 ** bit_x)
sinx = np.sin(x)
sinx_round = np.around((2**(bit_sin)-1)/2 * sinx) + (2**(bit_sin)-1)/2  #10-bit DAC
with open("sin_table.mif", "w") as f:
    f.write(head)
    f.write("\n")
    f.write("WIDTH=" + str(bit_sin) + ";")
    f.write("DEPTH=" + str(2 ** bit_x) + ";")
    f.write("\n")
    f.write("ADDRESS_RADIX=UNS;\n")
    f.write("DATA_RADIX=UNS;\n")
    f.write("\n")
    f.write("CONTENT BEGIN\n")
    for i in range(len(sinx_round)):
        f.write("\t"+str(i)+"    :   "+str(int(sinx_round[i]))+";\n")
    f.write("END;")

plt.plot(x,sinx_round)
plt.show()
'''
sinx_round = sinx_round.reshape(( int(2 ** 16 / 8),8))
np.set_printoptions(suppress=true, threshold=np.nan)
print(sinx_round)
'''
