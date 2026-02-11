# Dragon RISC-V Core

Dragon is an educational, open-source 32-bit RISC-V processor core written in SystemVerilog.
The core features a parameterizable design implements the RV32I base integer instruction set.

**Project Status**: Currently under simulation and verification in Vivado. Future work includes FPGA deployment & adding ability to run C programs via UART.

---

## Core Architecture
![Architecture](./architecture.svg)

## Architecture
Core follows the design of 5-stage pipelined processor (Figure 7.61) from "Digital Design & Computer Architecture: RISC-V Edition" with additional custom logic, control, and blocks (load extend, write extend, branch unit, etc.) to cover the whole 32-bit integer instruction set.

Design follows classis 5-stage in-order pipeline: IF -> ID -> EX -> MEM -> WB
Hazards are hanlded by separate Hazard Unit which receives source & destination registers from ID, EX, MEM, and WB stages. Hazard Unit solves data hazards with forwarding using `ForwardAE` and `ForwardBE` signals to control mux selection in EX stage.
Flushing is used for branch & jump instructions, and stalling is used to prevent load-use hazards.

Refer to microarchitecture for more detailed view of the core (![microarchitecture](microarchitecture.svg))

---

## Features

- **ISA Support**: RV32I base integer instruction set
- **Parameterizable Design**: Configurable data width and key module parameters
- **Pipeline Optimizations**: Full forwarding paths and hazard detection unit
- **Memory Architecture**: Separate instruction and data memories using BRAM

---

## Project Structure
```
Dragon/
├── rtl/              # SystemVerilog source files
├── tests/            # Assembly test programs with linker script
├── sim/              # Simulation scripts
|── tb/               # Testbench
├── xdc/              # constraint file
└── docs/             # Documentation
```

---

## Verification

**Test Suite**: Located in `./tests/`
- Two assembly programs to test rv32 and rv64 instructions
- Tests cover all instruction types (R, I, S, B, U, J)
- Pipeline hazard scenarios are included in the tests
- Individual instruction test cases are on way...

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

Everything in this repository is covered by the MIT License (see [License](./LICENSE) for full text).

---

## Acknowledgments

This project was developed as an educational exercise in CPU design and RISC-V architecture.