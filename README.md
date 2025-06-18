
#Finite-State Machine + Datapath

## Objective
The objective of this lab is to use a finite-state machine integrated with a datapath to calculate the number of asserted bits in a given input using several different SystemVerilog models.

## Tools Used
- Questa
- Vivado


## Pseudocode
Study the following pseudocode to make sure you understand the basic algorithm for efficiently calculating the number of asserted bits in a given input.

```c
// inputs: go, in (INPUT_WIDTH bits)
// outputs: out (clog2(INPUT_WIDTH+1) bits), done

// reset values (add any others that you might need)
out = 0;
done = 0;

while(1) {
    while (go == 0); // wait for go to start circuit
    done = 0;
    count = 0;

    n_r = in; // store input in register

    // main algorithm
    while(n_r != 0) {
      n_r = n_r & (n_r – 1);
      count ++;
    }

    // assign output and assert done
    output = count;
    done = 1;
}
```

#### Important constraints for the `done` output signal:
- The `done` output should remain asserted until the application is started again, which is represented by `go` being asserted while `done` is asserted.
- The `done` output should be cleared the cycle after go is asserted.


## Part 1: 1-process FSMD
Designed a single-process FSMD that integrates control and datapath logic within one always block. The module was verified using the count_ones_tb testbench with the ARCH parameter set to "fsmd_1p". Synthesis was completed successfully in Vivado. The project includes simulation and synthesis screenshots for this architecture.

![](.data/syn_example.png)

### Deliverables
- `images/part1_sim.{jpg,png}` - Simulation screenshot (showing resulting number of tests passing/failing)
- `images/part1_syn.{jpg,png}` - Synthesis screenshot 


## Part 2: 2-process FSMD
Refactored the design into a two-process FSMD model where control logic and datapath logic are separated into distinct always blocks. Tested using the same testbench with ARCH set to "fsmd_2p". The module was synthesized using Vivado targeting the same FPGA part. Screenshots of simulation and synthesis results are included.

### Deliverables
- `images/part2_sim.{jpg,png}` - Simulation screenshot (showing resulting number of tests passing/failing)
- `images/part2_syn.{jpg,png}` - Synthesis screenshot


## Part 3: FSM + Datapath

### Datapath
Designed a dedicated datapath to implement the count_ones algorithm and created a corresponding finite state machine to control it. The datapath was implemented in count_ones_datapath.sv, and the FSM was implemented in count_ones_fsm.sv using a two-process model. These were structurally connected in count_ones_fsm_plus_d.sv. The module was tested with the testbench using ARCH set to "fsm_plus_d". The datapath design schematic, simulation results, and synthesis screenshots are all included in the project.

### FSM
Created a __2-process__ finite-state machine in the provided [count_ones_fsm](src/count_ones_fsm.sv) file that utilizes my custom datapath to implement the algorithm.

### FSM+D
Connected my FSM and datapath together structurally in the [count_ones_fsm_plus_d](src/count_ones_fsm_plus_d) file.

Created a easily interchangable arch parameter to make the debugging easier.
When running the testbench and synthesis, make sure to change the `ARCH` parameter to `"fsm_plus_d"`.


### Deliverables
- `images/part3_datapath.{jpg,png,pdf}` - Datapath schematic
- `images/part3_sim.{jpg,png}` - Simulation screenshot (showing resulting number of tests passing/failing)
- `images/part3_syn.{jpg,png}` - Synthesis screenshot 

#Repository Structure

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

