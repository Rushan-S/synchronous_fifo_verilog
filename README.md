synchronous fifo

Synchronous FIFO implemented in Verilog. 8-bit wide, 32 entries deep.

Built this as part of learning RTL design — covers the core stuff: circular buffer, read/write pointers, occupancy counter, and status flags.

Details

- 8-bit data width, 32-deep circular buffer
- Full, empty, almost-full, almost-empty flags
- Simultaneous read/write handled without corruption
- Overflow and underflow protected

Simulation

Verified on ModelSim. Testbench covers sequential writes and reads, fill to full, drain to empty, simultaneous read/write, flag transitions, and pointer wrap-around.

##Run it

```bash
vlog fifo.v fifo_tb.v
vsim fifo_tb
run -all
```

*Verilog · ModelSim · Intel Quartus*
