module count_ones_fsmd_1p #(
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

typedef enum logic [1:0] {
  START,
  COMPUTE,
  RESTART,
  XXX = 'x
} state_t;


state_t state_r;

logic [$bits(in)-1:0]  n_r;
logic [$bits(out)-1:0]  out_r;
logic [$bits(out)-1:0] count_r;
logic         done_r;


assign out = out_r;
assign done = done_r;

always_ff@(posedge clk or posedge rst) begin
  if ((rst)) begin
    out_r <= '0;
    done_r <= 1'b0;
    count_r <= '0;
    n_r <= '0;
    state_r <= START;
  end else begin
    done_r <= 1'b0;


    case(state_r)
      START: begin
        done_r <= 1'b0;
        out_r <= '0;
        
        count_r <= '0;
        n_r <= in;

        if(go) state_r <= COMPUTE;
      end



      COMPUTE: begin
        if(n_r!=0) begin
          n_r <= n_r & (n_r-1);
          count_r <= count_r + 1'b1;

        end else begin
          state_r <= RESTART;
        end

      end



      RESTART: begin
        out_r <= count_r;
        done_r <= 1'b1;
        count_r <= '0;
        n_r <= in;

        if(go) begin
          done_r <= 1'b0;
          state_r <= COMPUTE;
        end




      end 
        default: state_r <= XXX;
    endcase
  end






end



endmodule
