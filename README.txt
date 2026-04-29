Low-Pass FIR Filter RTL Project

Overview
This repository contains a small signed fixed-point low-pass FIR filter example using Verilog RTL, a simple self-checking testbench, and MATLAB stimulus generation support.

Why this project matters
- shows basic DSP-oriented RTL design
- demonstrates fixed-point signed arithmetic
- includes a simple verification flow instead of waveform-only validation
- works well as a compact academic-to-portfolio bridge project

Current design scope
- 4-tap low-pass FIR filter
- signed 16-bit input and output datapath
- signed fixed-point coefficients
- synchronous output with resettable delay chain

Main files
- src/Verilog Code/FIR_Filter.v : FIR RTL
- Test/FIR_Filter_tb.sv : self-checking testbench
- src/Matlab Code/Filter_data.m : MATLAB stimulus generation script

Verification
- directed self-checking testbench
- checks expected filtered output sample by sample
- includes both positive and negative input values

Important note
This project is now positioned as a compact low-pass FIR example. It should not be described as a Butterworth implementation unless the coefficients and design flow are updated accordingly.

Good next improvements
- use a larger tap count
- derive coefficients from a proper filter design flow
- add impulse and step-response tests
- include waveform screenshots and expected output plots
