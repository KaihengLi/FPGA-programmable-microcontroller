//message format 4 bit op code - 3 bit reg source 1 - 3 bit reg source 2 - 3 bit destination reg
`default_nettype none

module decoder(
    input [15:0] message,

    output reg [3:0] op_code,
    output reg [3:0] regsrc1, regsrc2, regdes,
);

always @(*) begin 
    op_code  <= message[15:12];
    regsrc1 <= message[11:8];
    regsrc2 <= message[7:4];
    regdes <= message[3:0];
end
endmodule