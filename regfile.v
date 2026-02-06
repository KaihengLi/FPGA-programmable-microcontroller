`default_nettype none

module regfile (
    input clk,
    input rst_n,
    input write_en,
    input [3:0] read_address1,
    input [3:0] read_address2,
    input [3:0] write_address,
    input [15:0] write_data,

    output reg [15:0] read_data1,
    output reg [15:0] read_data2
);
reg [15:0] file_reg [15:0];
integer i;

always @(posedge clk or negedge rst_n)begin 
    if(~rst_n)begin 
        for (i = 0; i < 2; i = i + 1)
            file_reg[i] <= 16'b0;        
    end else begin 
        if(write_en) begin 
            file_reg[write_address] = write_data;
        end
    end
    read_data1 <= file_reg[read_address1];
    read_data2 <= file_reg[read_address2];
end

endmodule