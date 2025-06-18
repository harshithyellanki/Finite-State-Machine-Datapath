module count_ones_datapath #(
    parameter int INPUT_WIDTH = 32,
    localparam int OUTPUT_WIDTH = $clog2(INPUT_WIDTH + 1)
) (
    input  logic                    clk,
    input  logic                    rst,
    input  logic [INPUT_WIDTH-1:0]  in,
    input  logic                    n_en,
    input  logic                    n_sel,
    input  logic                    count_en,
    input  logic                    count_sel,
    input  logic                    out_en,
    output logic [OUTPUT_WIDTH-1:0] out,
    output logic                    n_eq_0
);

    logic [INPUT_WIDTH-1:0] n_r, n_next;
    logic [OUTPUT_WIDTH-1:0] count_r, count_next;

        
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            n_r     <= '0;
            count_r <= '0;
          //  out     <= '0;
        end else begin
          /*  if (n_en) */      n_r <= n_next;
           /*if (count_en) */  count_r <= count_next;
          
            //out <= count_r;
        end
    end

    always_comb begin
        if (out_en) begin
            out = count_r; // Use '=' for combinational assignments
        end else begin
            out = 0;       // Ensure `out` is reset to 0 when `out_en` is not asserted
        end
    end


    always_comb begin
        n_next = n_r;
        count_next = count_r;
        if (n_en) begin
            n_next = n_sel ? in : (n_r & (n_r - 1));

            if ((n_eq_0 == 0) && (n_sel == 0)) count_next = count_r + 1; 
            //count_next = count_r + 1;

        end
        if (count_en && count_sel) count_next = '0; 

        


    end

    assign n_eq_0 = (n_r == 0);
    

endmodule