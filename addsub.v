module addsub (
    input [15:0] A, B
    input A_S, //1 = add 0 = sub
    input sign, // 1 for signed, 0 for not

    output carry,
    output Y,
    output over
);

//unsigned extension bit
wire [16:0] a_u = {1'b0, A};
wire [16:0] b_u = {1'b0, B};

//signed extension bit
wire [16:0] a_s = $signed({A[15], A});
wire [16:0] b_s = $signed({B[15], B});

wire [8:0]        sum_u = A_S ? (A_u - B_u) : (A_u + B_u);
wire signed [8:0] sum_s = A_S ? (A_s - B_s) : (A_s + B_s);

wire signA = a_s[16];
wire signB = b_s[16];
wire signS = sum_s[16];

wire ov_add = (signA ^ signS) & (~(signA ^ signB));
wire ov_sub = (signA ^ signB) & (signA ^ signS);
wire ov_sum = A_S? ov_add:ov_sub;

assign Y = sign ? sum_s[15:0] : sum_u[15:0];
assign carry = sign ? 1'b0: sum_u[16];
assign over = sign ? ov_sum : 1'b0; 

endmodule