`default_nettype none

module top (
    input CLK,
    input PIN_1, //reset

    output LED, // signov
    output PIN_2,//carry
);
    //internal wires
    wire [15:0] ALU_INA, ALU_INB, ALU_OUTY;
    wire [3:0] read_address1, read_address2, write_address;
    wire [15:0] write_data, read_data1, read_data2;
    wire [15:0] pc_add_in, pc_add_out;
    wire [15:0] decoder_input;
    wire [3:0] decoder_op_code;
    wire [3:0] alu_op;
    wire [3:0] decoder_regsrc1, decoder_regsrc2, decoder_regdes;
    wire alu_signov, alu_carry;

    wire alu_ov;
    wire alu_done;
    wire carry;
    wire overflow;
    wire alu_incoming;
    wire write_en;
    wire pc_inc;
    wire pc_load;
    wire reset;
    wire CARRY;
    wire LED;

    // Connect the physical pins to internal logic
    assign reset = PIN_1;  // PIN_1 drives the reset
    assign CARRY = PIN_2;
    assign LED = overflow; // overflow drives the physical LED

    alu the_alu(
        .clk(CLK),
        .rst_n(reset),
        .incoming(alu_incoming),
        .A(ALU_INA),
        .B(ALU_INB),
        .operator(alu_op),
        .Y(ALU_OUTY),
        .carry(carry),
        .signov(alu_ov)
    );

    regfile the_regfile(
        .clk(CLK),
        .rst_n(reset),
        .write_en(write_en),
        .read_address1(read_address1),
        .read_address2(read_address2),
        .write_address(write_address),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    ); 

    program_counter the_pc(

        .clk(CLK),
        .rst_n(reset),
        .inc(pc_inc),
        .load(pc_load),
        .add_in(pc_add_in),
        .add_out(pc_add_out),
    );

    decoder the_decoder(
        .message(decoder_input),
        .op_code(decoder_op_code),
        .regsrc1(decoder_regsrc1),
        .regsrc2(decoder_regsrc2),
        .regdes(decoder_regdes)
    );

    control_unit the_control_unit(
        .clk(CLK),
        .rst_n(reset),
        .signov(alu_signov),
        .add_out(pc_add_out),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .alu_incoming(alu_done),
        .op_code(decoder_op_code),
        .regsrc1(decoder_regsrc1),
        .regsrc2(decoder_regsrc2),
        .regdes(decoder_regdes),
        .Y(ALU_OUTY),
        .carry(alu_carry),

        .A(ALU_INA),
        .B(ALU_INB),
        .alu_op(alu_op),
        .inc(pc_inc),
        .load(pc_load),
        .alu_incoming(alu_incoming),
        .add_in(pc_add_in),
        .write_address(write_address),
        .write_data(write_data),
        .carry_flag(CARRY),
        .overflow_flag(overflow)
    );

endmodule
