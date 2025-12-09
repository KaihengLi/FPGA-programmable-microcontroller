module alu(
    input clk,
    input rst_n,
    input incoming,
    input reg [15:0] A, B,
    input reg [4:0] operator,

    output reg [15:0] Y,
    output carry,
    output signov

)

wire c_addsub;
wire y_addsub;
wire v_addsub;



addsub u_add(
    .A(A), .B(B), .A_S(1'b1), .sign(1'b0),
    .carry(c_uadd), .Y(y_uadd), .over(v_uadd)
);

addsub u_sub(
    .A(A), .B(B), .A_S(1'b0), .sign(1'b0),
    .carry(c_usub), .Y(y_usub), .over(v_usub)
);

addsub s_add(    
    .A(A), .B(B), .A_S(1'b1), .sign(1'b1),
    .carry(c_sadd), .Y(y_sadd), .over(v_sadd)
);

addsub s_sub(    
    .A(A), .B(B), .A_S(1'b0), .sign(1'b1),
    .carry(c_ssub), .Y(y_ssub), .over(v_ssub)
);


reg [15:0] result;

always @(posedge clk or negedge rst_n) begin 
    twos <= operator [0]
    if (~rst_n) begin
        result <= 16'b0;
    end else begin 
        if (ready)begin
            case (operator[4:0])  
                0000: begin//add
                    Y = twos? y_sadd : y_uadd;
                    signov = twos? v_sadd : v_uadd;
                    carry = twos? c_sadd : c_uadd;
                end
                0001: begin//subtract
                    Y = sign? y_ssub : y_usub;
                    signov = sign? v_ssub : v_usub;
                    carry = sign? c_ssub : c_usub;
                end
                0010: begin //AND
                    result <= A&B;
                end
                0011: begin //OR
                    result <= A|B;
                end
                0100: begin //NOT
                    result <= ~A;
                end
                0101: begin //XOR
                    result <= A^B;
                end
                0111: begin //shift left
                    result <= {A[14:0],0};
                    carry <= 1;
                end
                1000: begin //shift right
                    result <= {0,A[15:1]};
                end
                1001: begin //less than
                    if (A < B) begin 
                        result <= 16'd1;  
                    end else begin 
                        result <= 16'b0;
                    end
                end
                1010: begin 
                    if (A = B) begin 
                        result <= 16'd1;  
                    end else begin 
                        result <= 16'b0;
                    end
                end
            endcase
        end
    end
end
endmodule