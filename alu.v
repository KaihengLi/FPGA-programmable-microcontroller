`default_nettype none

module alu(
    input clk,
    input rst_n,
    input incoming,
    input [15:0] A, B,
    input [3:0] operator,

    output reg [15:0] Y,
    output reg carry,
    output reg signov,
    output reg alu_done
);

    wire c_uadd, v_uadd;
    wire [15:0] y_uadd;

    wire c_usub, v_usub;
    wire [15:0] y_usub;

    wire c_sadd, v_sadd;
    wire [15:0] y_sadd;

    wire c_ssub, v_ssub;
    wire [15:0] y_ssub;



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
    //twos <= operator[0]? 1:0;
    if (~rst_n) begin
        result <= 16'b0;
    end else begin 
        if (incoming)begin
            case (operator[4:0])  
                0000: begin//add unsigned
                    Y <= y_uadd;
                    signov <= v_uadd;
                    carry <= c_uadd;
                end
                0001: begin//subtract unsigned
                    Y <= y_usub;
                    signov <= v_usub;
                    carry <= c_usub;
                end
                1011:begin 
                    Y <= y_sadd;
                    signov <= v_sadd;
                    carry <= c_sadd;
                end
                1100:begin 
                    Y <= y_ssub;
                    signov <= v_ssub;
                    carry <= c_ssub;
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
                    if (A == B) begin 
                        result <= 16'd1;  
                    end else begin 
                        result <= 16'b0;
                    end
                end
            endcase
            alu_done <= 1'b1;
        end
    end
end
endmodule