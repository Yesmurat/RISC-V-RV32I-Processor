# DragonCore

DragonCore is a 5-stage parameterizable RISC-V soft-core designed in SystemVerilog.

The design follows the classic in-order pipeline and should support full execution of both RV32 & RV64 instruction sets.

**Note**: The project is currently in the process simulation and verification in Vivado.

In the end, the design should be successfully deployed on the Arty S7-25 FPGA board.

**Pipeline stages:**
- Instruction Fetch (IF)
- Instruction Decode (ID)
- Execute (EX)
- Memory Access (MEM)
- Write Back (WB)

---

## Features
- Implements all RV32 & RV64 instructions
- All key modules are parameterized
- Fully pipelined architecture with forwarding and stall control
- Separate instruction and data memory modules built using BRAM

---

## Verification
- assembly tests are located in `./tests` folder
- assembly test cases cover all instruction types
- Waveform analysis in **Vivado Simulator**

---

## FPGA Implementation
- **Target Board:** Arty S7-25 (Xilinx Spartan-7)
- **Implementation Tool:** Xilinx Vivado
- **Target Fmax:** ~100 MHz
- **Instruction & Data Memories:** Implemented using BRAM
- **Constraints File:** `./xdc/arty_s7_25.xdc`

---

## Future Work
- Being able to compile and run C programs on the core
- Instruction and data caches