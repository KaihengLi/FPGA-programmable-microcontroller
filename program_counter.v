module(
    input rst_n,
    input clk,
    input inc,
    input load,
    input reg [15:0] add_in,

    output reg [15:0] add_out
);
endmodule

always@(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin 
        add_out <= 16'b0;
    end else if (inc) begin 
        add_out <= add_out + 1;
    end else if (load) begin 
        add_out <= add_in;
    end
end