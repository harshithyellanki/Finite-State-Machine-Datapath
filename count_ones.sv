module count_ones #(
    parameter  int    INPUT_WIDTH  = 32,
    parameter  string ARCH         = "fsmd_plus_d",               // fsmd_1p, fsmd_2p, fsm_plus_d
    localparam int    OUTPUT_WIDTH = $clog2(INPUT_WIDTH + 1)
) (
    input  logic                    clk,
    input  logic                    rst,
    input  logic                    go,
    input  logic [ INPUT_WIDTH-1:0] in,
    output logic [OUTPUT_WIDTH-1:0] out,
    output logic                    done
);

  if (ARCH == "fsmd_1p") begin : g_fsmd_1p
    count_ones_fsmd_1p #(.INPUT_WIDTH(INPUT_WIDTH)) i_count_ones (.*);
  end else if (ARCH == "fsmd_2p") begin : g_fsmd_2p
    count_ones_fsmd_2p #(.INPUT_WIDTH(INPUT_WIDTH)) i_count_ones (.*);
  end else if (ARCH == "fsm_plus_d") begin : g_fsm_plus_d
    count_ones_fsm_plus_d #(.INPUT_WIDTH(INPUT_WIDTH)) i_count_ones (.*);
  end else begin : g_error
    $error("Invalid architecture specified.");
  end

endmodule
