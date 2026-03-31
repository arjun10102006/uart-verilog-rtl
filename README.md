<img width="914" height="357" alt="Screenshot 2026-03-27 221549" src="https://github.com/user-attachments/assets/c020ba89-43c2-47f2-9267-b13716e6f1bf" />
# UART Controller (Verilog RTL)

## Description
This project implements a UART controller using Verilog, including baud rate generator, transmitter, and receiver.

## Features
- UART transmission (LSB first)
- FSM-based receiver
- Baud rate generation
- Loopback verification

## Modules
- baud_gen.v – Generates baud tick
- uart_tx.v – Transmitter
- uart_rx.v – Receiver
- uart_top.v – Integration

## Simulation
- Verified using testbench
- Waveform confirms correct UART frame

## Tools
- Verilog HDL
- EDA Playground / Icarus Verilog
