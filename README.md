# DragonCore

## DragonCore is a **5-stage pipelined RV32I RISC-V processor** in SystemVerilog.

The design follows the classic in-order pipeline and supports full execution of the RV32I base integer instruction set. Beyond functional correctness, the project focuses on clean RTL architecture using modern SystemVerilog features to reduce wiring complexity and improve maintainability.

The core has been **simulated and verified in Vivado** and **successfully deployed on the Arty S7-25.

**Pipeline stages:**
- Instruction Fetch (IF)
- Instruction Decode (ID)
- Execute (EX)
- Memory Access (MEM)
- Write Back (WB)

---

## Features
- Implements all **RV32I base integer instructions** (R, I, S, B, and J types)
- Fully pipelined architecture with **forwarding and stall control**
- Separate **instruction and data memory modules** built from LUTs
- **Byte-enable logic** for store instructions
- Supports **clear/reset** signal and hazard resolution

---

## Verification
- **directed test cases** covering all instruction types
- Testbench includes **clock, reset, and realistic instruction sequences**
- Waveform analysis performed in **Vivado Simulator**
- Example assembly programs located in `tests/`
- Waveform captures available in `tb/waveforms/`

---

## FPGA Implementation
- **Target Board:** Arty S7-25 (Xilinx Spartan-7)
- **Implementation Tool:** Xilinx Vivado
- **Post-implementation Fmax:** ~100 MHz
- **Instruction & Data Memories:** Implemented using LUT-based distributed memory
- **Constraints File:** `xdc/arty_s7_25.xdc`

---

## Future Work
- RV64I support
- Instruction and data caches
- AXI-based memory interface
