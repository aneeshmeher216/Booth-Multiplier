module booth_multiplier #(parameter N = 5)(
  input clk, rst, start,
  input signed [N-1:0] M, Q,
  
  output signed [2*N-1:0] result
);

reg signed [2*N-1:0] temp_result;      // it indicates {accumulator, Q}             //accumulator
reg Q_1 ;
reg [$clog2(N):0] count;        //initializing count = N here is not synthesizable because N is a paramter
reg done;

reg state;
localparam IDLE = 0, START = 1;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        Q_1 <= 0;
        count <= 0;
        temp_result <= 0;
        state <= IDLE;
        done <= 1'b0;
    end
    
    else begin
        case(state)
            IDLE : begin
                    done <= 1'b0;
                    Q_1 <= 0;
                    count <= N;
                    temp_result <= {{N{1'b0}},Q};
                    if(start) state <= START;
            end
            
            START : begin
                if(count > 0) begin
                    
                    case({temp_result[0],Q_1}) 
//                    concatenation here breaks the signed nature of temp_result, so the arithmetic shift operator can't perform sign extension correctly
//                        2'b01 : temp_result <= {(temp_result[2*N-1:N] + M), temp_result[N-1:0]} >>> 1;
//                        2'b10 : temp_result <= ({(temp_result[2*N-1:N] + (~M + 1)), temp_result[N-1:0]}) >>> 1;    

                        2'b01 : temp_result <= (temp_result + (M<<N)) >>> 1;
                        2'b10 : temp_result <= (temp_result + ((~M + 1)<<N)) >>> 1;    //2's complement
                        default : temp_result <= temp_result >>> 1; 
                    endcase
                    
                    Q_1 <= temp_result[0];
                    count <= count - 1;
                end
                else
                    done <= 1'b1;
            end   
        endcase
    end
end
  
assign result = (done) ? temp_result : 0;

endmodule