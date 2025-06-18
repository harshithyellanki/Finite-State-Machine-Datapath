// Greg Stitt
// University of Florida

module count_ones_tb #(
  parameter  int    NUM_TESTS    = 10000,
  parameter  int    INPUT_WIDTH  = 32,
 // parameter  string ARCH         = "fsmd_1p",               // fsmd_1p, fsmd_2p, fsm_plus_d
  localparam int    OUTPUT_WIDTH = $clog2(INPUT_WIDTH + 1)
);

localparam int TIMEOUT_CYCLES = INPUT_WIDTH * 5;

logic clk = '0;
initial begin
  forever #5 clk <= ~clk;
end

task automatic done_or_timeout(ref logic signal, input logic value, input int timeout_cycles);
  fork
    begin
      fork
        begin
          repeat (timeout_cycles) @(posedge clk);
          $fatal(1, "Timed out.");
        end
      join_none
      @(posedge clk iff signal === value);
      disable fork;
    end
  join
endtask

logic rst, go, done;
logic [INPUT_WIDTH-1:0] in;
logic [OUTPUT_WIDTH-1:0] out, correct_out;

count_ones_fsmd_2p#(
    .INPUT_WIDTH(INPUT_WIDTH)
   // .ARCH(ARCH)
) dut (
    .*
);

int passed, failed;

initial begin
  $timeformat(-9, 0, " ns", 10);
  passed = 0;
  failed = 0;

  // Reset the circuit
  rst <= 1'b1;
  go  <= 1'b0;
  in  <= '0;
  repeat (5) @(posedge clk);

  // Clear reset
  rst <= 1'b0;
  @(posedge clk);

  // Run the tests
  for (int i = 0; i < NUM_TESTS - 2; i++) begin
    // Start the test with a random input
    in <= $urandom;
    go <= 1'b1;
    @(posedge clk);
    go <= 1'b0;

    // Wait until completion.
    done_or_timeout(done, 1'b1, TIMEOUT_CYCLES);

    // Validate
    correct_out = $countones(in);
    if (out !== correct_out) begin
      $error("out = %0d instead of %0d for in = 0x%h.", out, correct_out, in);
      failed++;
    end else begin
      passed++;
    end
  end

  // Test all 0s
  in <= '0;
  go <= 1'b1;
  @(posedge clk);
  go <= 1'b0;

  // Wait until completion.
  done_or_timeout(done, 1'b1, TIMEOUT_CYCLES);

  // Validate
  correct_out = $countones(in);
  if (out !== correct_out) begin
    $error("out = %0d instead of %0d for in = 0x%h.", out, correct_out, in);
    failed++;
  end else passed++;

  // Test all 1s
  in <= '1;
  go <= 1'b1;
  @(posedge clk);
  go <= 1'b0;

  // Wait until completion.
  done_or_timeout(done, 1'b1, TIMEOUT_CYCLES);

  // Validate
  correct_out = $countones(in);
  if (out !== correct_out) begin
    $error("out = %0d instead of %0d for in = 0x%h.", out, correct_out, in);
    failed++;
  end else passed++;

  // Report stats.
  $display("-------------- TEST RESULTS -------------");
  $display("\tPassed: %0d/%0d", passed, NUM_TESTS);
  $display("\tFailed: %0d/%0d", failed, NUM_TESTS);
  $display("-----------------------------------------");
  $finish;
end

// Check to make sure done cleared within a cycle. Go is anded with done
// because go should have no effect when the circuit is already active.
assert property (@(posedge clk) disable iff (rst) go && done |=> !done)
else $error("`done` must be cleared the clock cycle after `go` is asserted.");

// Check to make sure done is only cleared one cycle after go is asserted 
// (i.e. done is left asserted indefinitely).
assert property (@(posedge clk) disable iff (rst) $fell(done) |-> $past(go, 1))
else $error("`done` should not be cleared unless `go` was asserted on the previous clock cycle.");

endmodule
