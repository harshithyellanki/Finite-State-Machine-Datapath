Here's a rewritten version of the second document, formatted and refined to exactly match the style and clarity of the first polished version:

---

# Finite-State Machine + Datapath

## Objective

The objective of this lab is to implement a finite-state machine integrated with a datapath to count the number of asserted bits in an input word. This is accomplished using multiple SystemVerilog architectural styles.

## Tools Used

* Questa
* Vivado

## Pseudocode

Below is the high-level pseudocode for the core algorithm used to count the number of `1`s (asserted bits) in a given input. Understanding this logic is key before proceeding with implementation.

```c
// Inputs: go, in (INPUT_WIDTH bits)
// Outputs: out (clog2(INPUT_WIDTH+1) bits), done

// Reset values (add any others if needed)
out = 0;
done = 0;

while (1) {
    while (go == 0); // Wait for go signal
    done = 0;
    count = 0;

    n_r = in; // Store input in a register

    // Main algorithm
    while (n_r != 0) {
        n_r = n_r & (n_r - 1);
        count++;
    }

    // Output result and signal completion
    output = count;
    done = 1;
}
```

### Important `done` Signal Constraints

* The `done` signal must remain asserted until the circuit is restarted (i.e., `go` is asserted again while `done` is still high).
* Once restarted, `done` must be de-asserted on the following clock cycle.

---

## Part 1: 1-process FSMD

Implemented a **single-process FSMD** where both control logic and datapath operations are handled within the same always block. This version was tested using the `count_ones_tb` testbench with the `ARCH` parameter set to `"fsmd_1p"`. The design was synthesized using Vivado and confirmed to work correctly.

### Deliverables

* `images/part1_sim.{jpg,png}` – Simulation results (test pass/fail summary)
* `images/part1_syn.{jpg,png}` – Vivado synthesis screenshot

---

## Part 2: 2-process FSMD

Refactored the design into a **two-process FSMD** model, separating the control logic and datapath operations into two distinct always blocks. Verified functionality using the same testbench with `ARCH = "fsmd_2p"`, and synthesized the design using Vivado.

### Deliverables

* `images/part2_sim.{jpg,png}` – Simulation results (test pass/fail summary)
* `images/part2_syn.{jpg,png}` – Vivado synthesis screenshot

---

## Part 3: FSM + Datapath

### Datapath

Implemented a standalone **datapath module** to carry out the `count_ones` operation. This was implemented in `count_ones_datapath.sv`.

### FSM

Designed a **2-process FSM** to control the datapath, implemented in `count_ones_fsm.sv`. The FSM generates control signals for the datapath based on the current state and input signals.

### FSM + Datapath Integration

Integrated both modules structurally in `count_ones_fsm_plus_d.sv`. This modular structure makes the design clean and scalable. Testing was performed using the same testbench with `ARCH = "fsm_plus_d"`.

> An easily interchangeable `ARCH` parameter is used for simulation and synthesis to switch between different design implementations for efficient debugging.

### Deliverables

* `images/part3_datapath.{jpg,png,pdf}` – Datapath block diagram/schematic
* `images/part3_sim.{jpg,png}` – Simulation results (test pass/fail summary)
* `images/part3_syn.{jpg,png}` – Vivado synthesis screenshot

---

## Repository Structure

```bash
├── images
│   ├── part1_sim.jpg
│   ├── part1_syn.jpg
│   ├── part2_sim.jpg
│   ├── part2_syn.jpg
│   ├── part3_datapath.pdf
│   ├── part3_sim.jpg
│   └── part3_syn.jpg
├── src
│   ├── count_ones.sv
│   ├── count_ones_datapath.sv
│   ├── count_ones_fsm.sv
│   ├── count_ones_fsm_plus_d.sv
│   ├── count_ones_fsmd_1p.sv
│   └── count_ones_fsmd_2p.sv
├── tests
│   └── count_ones_tb.sv
├── README.md
└── sources.txt
```

---

