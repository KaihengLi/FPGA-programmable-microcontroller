module regfile (
    input clk,
    input rst_n,
    input write_en,
    input [3:0] read_address1,
    input [3:0] read_address2,
    input [3:0] write_address,
    input [15:0] write_data,

    output [15:0] read_data1,
    output [15:0] read_data2
);
reg [3:0] file_reg [15:0];

always @(posedge clk or negedge rst_n)begin 
    if(~rst_n)begin 
        integer i;
        for (i = 0; i < 2; i = i + 1)
            regs[i] <= 16'b0;        
    end else begin 
        if(write_en) begin 
            file_reg[write_address] = write_data;
        end
    end
end

assign read_data1 = file_reg[read_address1];
assign read_data2 = file_reg[read_address2];
endmodule