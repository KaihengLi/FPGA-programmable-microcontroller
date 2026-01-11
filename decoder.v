//message format 4 bit op code - 3 bit reg source 1 - 3 bit reg source 2 - 3 bit destination reg
module decoder(
    input reg [15:0] message,

    output reg [3:0] op_code,
    output reg [2:0] regsrc1, regsrc2, regdes,
);

always @(*) begin 
    op_code  <= message[15:9];
    regsrc1 <= message[8:6];
    regsrc2 <= message[5:3];
    regdes <= message[2:0];
end
endmodule