# Thunderbird Tail-Light Controller (FSM)

Verilog implementation and ModelSim testbench for a sequential Thunderbird tail-light finite state machine (FSM).

## Overview

This project models a Thunderbird tail-light controller using a state machine architecture (`000 Idle` through `111 Haz`) paired with combinational and sequential logic to drive left-turn, right-turn, and hazard lamp patterns.

## States & Signals

- **States:** `000 Idle`, `001 L1`, `010 L2`, `011 L3`, `100 R1`, `101 R2`, `110 R3`, and `111 Haz`
- **Control & Clock Signals:** `clk`, `clear`, `L` (left), `R` (right), `H` (hazard)
- **State / Next-State Signals:** `Q2`, `Q1`, `Q0` and `Q2next`, `Q1next`, `Q0next`
- **Lamp Outputs:** `Lc`, `Lb`, `La`, `Ra`, `Rb`, `Rc`

## Simulation in ModelSim

1. Create or open your ModelSim project and add the Verilog design and testbench files (`thunderbird_tb.v` and module source files).
2. Compile all source files in ModelSim.
3. Load `thunderbird_tb` for simulation and run the testbench (`run -all`) to inspect waveform behavior across reset, left-turn, right-turn, and hazard sequences.
