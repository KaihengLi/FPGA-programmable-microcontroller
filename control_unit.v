`default_nettype none
module control_unit (
    input clk,
    input rst_n,
    input signov,
    input [3:0] add_out,
    input [15:0] read_data1,
    input [15:0] read_data2,
    input alu_done,
    input [6:0] op_code,
    input [3:0] regsrc1, regsrc2, regdes,
    input [15:0] Y,
    input carry,

    output reg [15:0] A, B,
    output reg [3:0] alu_op,
    output reg inc,
    output reg load,
    output reg alu_incoming,
    output reg [3:0] read_address1, read_address2,
    output reg [3:0] add_in,
    output reg [3:0] write_address,
    output reg [15:0] write_data,
    output reg carry_flag,
    output reg overflow_flag
);

//parameter FETCH   = 3'd0;
parameter DECODE  = 3'd0;
parameter EXECUTE = 3'd1;
//parameter EXECUTEWAIT = 3'd2;
parameter WRITEBACK = 3'd3;
reg alu_stall;

reg [2:0] current_state;
reg [2:0] next_state;

always @(posedge clk or negedge rst_n) begin
    if (rst_n) begin 
        A <= 16'b0;
        B <= 16'b0;
        write_data <= 16'b0;
        read_address1 <= 4'b0;
        read_address2 <= 4'b0;
        write_address <= 4'b0;
        alu_op <= 4'b0;
        alu_incoming <= 1'b0;
        overflow_flag <= 1'b0;
        carry_flag <= 1'b0;

        inc <= 0;
        load <= 0;
        add_in <= 0;
        next_state <= 3'd0;
    end else begin 
    case(current_state)
    DECODE: begin 
        read_address1 <= regsrc1;
        read_address2 <= regsrc2;
        next_state <= EXECUTE;
    end

    EXECUTE:begin
        alu_incoming <= 1;
        A <= read_data1;
        B <= read_data2;
        alu_op <= op_code [3:0];
        if (alu_done) begin 
            next_state <= WRITEBACK;
        end
    end
    WRITEBACK:begin
        write_address <= regdes;
        overflow_flag <= signov;
        carry_flag <= carry;
        if(signov) begin 
            write_data <= (A[15] && B[15]) ? 16'h8000 : 16'h7FFF;
        end else begin 
            write_data <= Y;
        end
    end
    endcase
    current_state <= next_state;
    end
end

endmodule