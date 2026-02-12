# Dragon RISC-V Core

Dragon is an educational, open-source 32-bit RISC-V processor core written in SystemVerilog.
The core features a parameterizable design and implements the RV32I base integer instruction set.

**Project Status**: Currently under simulation and verification in Vivado. Future work includes FPGA deployment & adding ability to run C programs via UART.

---

## Core Architecture
![Architecture](./architecture.svg)

Core follows the design of 5-stage pipelined processor (Figure 7.61) from "Digital Design & Computer Architecture: RISC-V Edition" with additional custom logic, control, and blocks (load extend, write extend, branch unit, etc.) to cover the whole 32-bit integer instruction set.

The design follows classic 5-stage in-order pipeline: IF -> ID -> EX -> MEM -> WB.
Hazards are handled by Hazard Unit, which receives source & destination registers from ID, EX, MEM, and WB stages. Hazard Unit solves data hazards with forwarding using `ForwardAE` and `ForwardBE` signals to control mux selection in EX stage.
Flushing is used for branch & jump instructions, and stalling is used to prevent load-use hazards.

Refer to microarchitecture for more detailed view of the core ([microarchitecture](./microarchitecture.svg))

---

## Features

- RV32 Integer Instruction Set support
- Parameterizible data width and key module parameters
- Hazard Unit with forwarding, stalling, and flushing logic
- Separate instruction and data memories using BRAM

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

## Simulation & Verification

The tests consist of two assembly programs, `rv32.s` and `rv64.s` (for future extension), for RV32 and RV64 instruction sets, which are located in [tests](./tests/). Alongside assembly tests there is also a linker script that is needed to turn assembly code into binary. Both tests cover all instruction types (R, I, S, B, U, J) and hazard scenarios. Individual instruction test cases are on the way. Simulation is performed in Vivado Simulator. Functional correctness of the design is validated with waveform-based verification. If you decide to write your own tests, the following link provides a web-based RISC-V assembler that can be used to turn assembly code into binary: [assembler](https://riscvasm.lucasteske.dev/)

---

## FPGA Implementation

**Target Platform**:
- Board: Arty S7-25
- Tools: Xilinx Vivado
- Target Clock: ~100 MHz
- Memory: BRAM-based instruction and data memories
- Constraints: `./xdc/constraints.xdc`
- Status: Awaiting behavioral verification completion before synthesis

<!-- **Status**: Design ready for synthesis (pending verification completion) -->

---

## Getting Started

### Prerequisites
- Xilinx Vivado (version 2025.1 or later)
- RISC-V toolchain for assembly (optional, for custom tests)

### Clone:
```
    git clone https://github.com/Yesmurat/Dragon.git
```

### FPGA Synthesis
<!-- ```bash
# Instructions for synthesis and implementation
# Add your build commands here
``` -->
Instructions will be provided after behavioral verification is complete...

---

## Future Work

- [ ] Complete RV32I verification
- [ ] Ability to compile and run C programs (not just assembly)
- [ ] M extension (Integer Multiplication and Division)
- [ ] Instruction and data caches
- [ ] Additional ISA extensions (A, C, etc.)

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