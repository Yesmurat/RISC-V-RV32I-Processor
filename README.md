# DragonCore

## DragonCore is a **5-stage pipelined RV64I RISC-V processor** in SystemVerilog.

The design follows the classic in-order pipeline and supports full execution of the RV64I base integer instruction set. Beyond functional correctness, the project focuses on clean RTL architecture using modern SystemVerilog features to reduce wiring complexity and improve maintainability.

The core has been **simulated and verified in Vivado** and **successfully deployed on the Arty S7-25.

**Pipeline stages:**
- Instruction Fetch (IF)
- Instruction Decode (ID)
- Execute (EX)
- Memory Access (MEM)
- Write Back (WB)

---

## Features
- Implements all **RV64I base integer instructions** (R, I, S, B, and J types)
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
- **Instruction & Data Memories:** Implemented using Block RAM
- **Constraints File:** `xdc/arty_s7_25.xdc`

---

## Future Work
- Instruction and data caches
- Atomic Extension Support
- Mult/Div Unit support
- AXI-based memory interface
