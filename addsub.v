`default_nettype none

module addsub (
    input [15:0] A, 
    input [15:0] B,
    input A_S, //1 = add 0 = sub
    input sign, // 1 for signed, 0 for not

    output reg carry,
    output reg [15:0] Y,
    output reg over
);

//unsigned extension bit
wire [16:0] a_u = {1'b0, A};
wire [16:0] b_u = {1'b0, B};

//signed extension bit
wire [16:0] a_s = $signed({A[15], A});
wire [16:0] b_s = $signed({B[15], B});

wire [15:0]        sum_u = a_s ? (a_u - b_u) : (a_u + b_u);
wire signed [16:0] sum_s = a_s ? (a_s - b_s) : (a_s + b_s);

signA <= a_s[16];
signB <= b_s[16];
signS <= sum_s[16];

ov_add <= (signA ^ signS) & (~(signA ^ signB));
ov_sub <= (signA ^ signB) & (signA ^ signS);
ov_sum <= A_S? ov_add:ov_sub;

Y <= sign ? sum_s[15:0] : sum_u[15:0];
carry <= sign ? 1'b0: sum_u[16];
over <= sign ? ov_sum : 1'b0; 

endmodule