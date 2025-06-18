module count_ones_fsm (
    input  logic clk,
    input  logic rst,
    input  logic go,
    input  logic n_eq_0,
    output logic done,
    output logic n_en,
    output logic out_en,
    output logic count_en,
    output logic n_sel,
    output logic count_sel
);

    typedef enum logic [1:0] {START, COMPUTE, RESTART} state_t;
    state_t state_r, next_state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) 
            state_r <= START;
        else 
            state_r <= next_state;
    end

    always_comb begin
        // Default values
        n_en = 0;
        n_sel = 0;
        count_en = 0;
        count_sel = 0;
        out_en = 0;
        done = 0;  
        next_state = state_r; 

        case (state_r)
            START: begin
                if (go) begin
                  //  done = 0;
                    n_en = 1;
                    n_sel = 1;
                    count_en = 1;
                    count_sel = 1; 
                    out_en = 0;
                    next_state = COMPUTE;
                end
            end


            COMPUTE: begin
                n_en = 1;
                count_en = 1;
                if (n_eq_0) begin
                    
                     done = 1;
                     out_en = 1'b1;
                    // out_en = 1;
                   // if(go && done) out_en = 1;
                    if(go) begin
                        next_state = RESTART;

                        //out_en = 0;
                    end
                end 
            end

        /*    COMPUTE: begin
                n_en = 1;
                count_en = 1;
                if (n_eq_0) begin
                    done = 1;  // Computation complete
                    out_en = 1;
                    next_state = RESTART; // Handle immediate restart
                end
                
            end
*/
            RESTART: begin
                
               // out_en = 0;
               // done = 1;
                count_en = 1;
                count_sel = 1;
                

               // if (go && done
                //if(go && done) done = 0;
                done = 0;
                n_en = 1;
                n_sel = 1;
                count_en = 1;
                count_sel = 1; 
                next_state = COMPUTE;
               // end 
                
             //   done = 0;
            
            
            end
        
        endcase
    end

endmodule
