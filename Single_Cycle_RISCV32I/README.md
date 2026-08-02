# Single Cycle RISC-V RV32I Processor

A **32-bit Single Cycle RISC-V Processor** designed in **SystemVerilog**, implementing the complete **RV32I Base Integer Instruction Set Architecture (ISA)**. The processor executes every instruction in a single clock cycle using a modular RTL architecture.

## Features

- ✅ Complete RV32I Base Integer ISA implementation
- ✅ Fully synthesizable SystemVerilog RTL
- ✅ Modular processor architecture
- ✅ Custom SystemVerilog testbench

## Supported Instructions

- **R-Type:** ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
- **I-Type:** ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
- **Load:** LB, LH, LW, LBU, LHU
- **Store:** SB, SH, SW
- **Branch:** BEQ, BNE, BLT, BGE, BLTU, BGEU
- **Jump:** JAL, JALR
- **Upper Immediate:** LUI, AUIPC

## Project Structure

```
Single_Cycle_RISCV32I/
├── RTL/
├── Testbench/
├── Memory/
├── Docs/
└── README.md
```

## Tools Used

- QuestaSim and Visualizer™ Debug Environment

## Future Improvements

- 5-Stage Pipelined RISC-V Processor
- RV32M Extension (Multiply/Divide)
- Cache Memory
- AXI Interface

## Acknowledgments

The architecture and design methodology for this project were inspired by the following textbooks, which served as the primary references throughout the implementation:

- **Digital Design and Computer Architecture: RISC-V Edition**  
  *Sarah L. Harris and David Harris*

- **Computer Organization and Design: The Hardware/Software Interface (2nd Edition)**  
  *David A. Patterson and John L. Hennessy*

The processor RTL was independently designed and implemented in **SystemVerilog** based on the concepts presented in these references.

---

## Author

**Sai Charan**

M.Tech – VLSI & Embedded Systems   
RTL Design | Design Verification | SystemVerilog | RISC-V | UVM
