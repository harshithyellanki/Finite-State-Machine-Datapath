module count_ones_fsm_plus_d #(
    parameter  int INPUT_WIDTH  = 8,
    localparam int OUTPUT_WIDTH = $clog2(INPUT_WIDTH + 1)
) (
    input  logic                    clk,
    input  logic                    rst,
    input  logic                    go,
    input  logic [ INPUT_WIDTH-1:0] in,
    output logic [OUTPUT_WIDTH-1:0] out,
    output logic                    done
);

  // TODO: Implement this module.
logic n_eq_0;
logic n_en;
logic n_sel;
logic count_en;
logic count_sel;
logic out_en;

count_ones_datapath #(
    .INPUT_WIDTH(INPUT_WIDTH)
) datapath (
    .clk(clk),
    .rst(rst),
    .in(in),
    .n_en(n_en),
    .n_sel(n_sel),
    .count_en(count_en),
    .count_sel(count_sel),
    .out_en(out_en),
    .out(out),
    .n_eq_0(n_eq_0)
);


count_ones_fsm controller (
    .clk(clk),
    .rst(rst),
    .go(go),
    .n_eq_0(n_eq_0),
    .done(done),
    .n_en(n_en),
    .out_en(out_en),
    .count_en(count_en),
    .n_sel(n_sel),
    .count_sel(count_sel)
);

endmodule
