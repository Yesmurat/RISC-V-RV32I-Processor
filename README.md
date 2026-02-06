# Dragon RISC-V Core

Dragon is an educational, open-source 32-bit RISC-V processor core written in SystemVerilog.
The core features a parameterizable design suitable for embedded control applications and implements the RV32I base integer instruction set.

**Project Status**: Currently under simulation and verification in Vivado. Future work includes FPGA deployment & adding ability to run C programs via UART.

---

## Architecture

**Pipeline Design**: Classic 5-stage in-order pipeline
- **IF** - Instruction Fetch
- **ID** - Instruction Decode
- **EX** - Execute
- **MEM** - Memory Access
- **WB** - Write Back

**Hazard Handling**:
- Data forwarding between pipeline stages
- Stall logic for load-use hazards
- Branch/jump flush control

---

## Features

- **ISA Support**: RV32I base integer instruction set
- **Parameterizable Design**: Configurable data width and key module parameters
- **Pipeline Optimizations**: Full forwarding paths and hazard detection unit
- **Memory Architecture**: Separate instruction and data memories using BRAM

---

## Project Structure
```
dragon-riscv/
├── rtl/              # SystemVerilog source files
├── tests/            # Assembly test programs
├── sim/              # Simulation scripts
|── tb/               # Testbench
├── xdc/              # FPGA constraint files
└── docs/             # Documentation
```

---

## Verification

**Test Suite**: Located in `./tests/`
- Covers all RV32I instruction types (R, I, S, B, U, J)
- Individual instruction test cases
- Pipeline hazard scenarios

**Simulation**: Vivado Simulator
- Waveform-based verification
- Functional correctness validation

---

## FPGA Implementation

**Target Platform**:
- Board: Arty S7-25 (Xilinx Spartan-7)
- Tools: Xilinx Vivado
- Target Clock: ~100 MHz
- Memory: BRAM-based instruction and data memories
- Constraints: `./xdc/constraints.xdc`

<!-- **Status**: Design ready for synthesis (pending verification completion) -->

---

## Getting Started

### Prerequisites
- Xilinx Vivado (version 2025.1 or later)
- RISC-V toolchain for assembly (optional, for custom tests)

### Simulation
<!-- ```bash
# Instructions for running simulation
# cd sim/
# Add your simulation commands here
``` -->
...

### FPGA Synthesis
<!-- ```bash
# Instructions for synthesis and implementation
# Add your build commands here
``` -->
...

---

## Future Work

- [ ] Complete RV32I verification
- [ ] Ability to compile and run C programs (not just assembly)
- [ ] M extension (Integer Multiplication and Division)
- [ ] Instruction and data caches
- [ ] Additional ISA extensions (A, C, etc.)
<!-- - [ ] Performance optimizations -->

---

## Documentation

For detailed design documentation, see:
- [Microarchitecture Overview](docs/architecture.md)
- [ISA Implementation Details](docs/isa.md)
- [Verification Plan](docs/verification.md)

---

## License

Unless otherwise noted, everything in this repository is covered by the MIT License (see [License](./LICENSE) for full text).

---

## Acknowledgments

This project was developed as an educational exercise in CPU design and RISC-V architecture.