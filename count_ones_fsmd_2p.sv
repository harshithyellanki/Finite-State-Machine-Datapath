module count_ones_fsmd_2p #(
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
  typedef enum logic[1:0] {
    START,
    COMPUTE,
    RESTART,
    XXX = 'x
  } state_t;


  state_t state_r , next_state;
  logic done_r, next_done;
  logic [$bits(in)-1:0]  n_r, next_n;
  logic [$bits(out)-1:0]  out_r, next_out;
  logic [$bits(out)-1:0] count_r, next_count;

  assign out = out_r;
  assign done = done_r;

  always_ff@(posedge clk or posedge rst) begin
    if(rst) begin
      done_r <= 1'b0;
      count_r <= '0;
      out_r <= '0;
      n_r <= '0;
      state_r <= START;


    end else begin
      done_r <= next_done;
      out_r <= next_out;
      n_r <= next_n;
      count_r <= next_count;
      state_r <= next_state;
    end

  end

  always_comb begin
    next_done = done_r;
    next_out = out_r;
    next_n = n_r;
    next_count = count_r;
    next_state = state_r;


    case (state_r)
      START :  begin
        next_done = 1'b0;
        next_out = '0;
        next_n = in;
        next_count = '0;


        if(go) begin
          next_state = COMPUTE;
        end
      end

        COMPUTE : begin
          if(next_n != 0) begin
            next_n = next_n & (next_n - 1);
            next_count = next_count + 1'b1;
          
          
          end else begin
            next_state = RESTART;
          end
        end


        RESTART : begin
          next_out = next_count;
          next_done = 1'b1;
          next_count = '0;
          next_n = in;


          if(go) begin
            next_done = 1'b0;
            next_state = COMPUTE;
          end

        end


        default: next_state = XXX;

      endcase

    end










endmodule
