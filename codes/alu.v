module alu #(
    parameter DATA_W = 64,

    parameter ADD = 3'b000,
    parameter SUB = 3'b001,
    parameter AND = 3'b010,
    parameter OR  = 3'b011,
    parameter XOR = 3'b100,
    parameter SLL = 3'b101,
    parameter SRL = 3'b110
)(
    input  [DATA_W-1:0]     i_data0,
    input  [DATA_W-1:0]     i_data1,
    input  [2:0]            i_alu_control,
    output reg [DATA_W-1:0] o_data,
    output                  o_zero
);

    // if the branch is done here, we need it
    assign o_zero = (o_data == 0)? 1 : 0;

    always @(*) begin
        case(i_alu_control)
            ADD: begin
                // $display("alu: %d + %d", i_data0, i_data1);
                o_data <= i_data0 + i_data1;
            end
            SUB: begin
                o_data <= i_data0 - i_data1;
            end
            OR: begin
                o_data <= i_data0 | i_data1;
            end
            AND: begin
                o_data <= i_data0 & i_data1;
            end
            XOR: begin
                o_data <= i_data0 ^ i_data1;
            end
            SLL: begin
                o_data <= i_data0 << i_data1;
            end
            SRL: begin
                o_data <= $signed(i_data0) >>> i_data1;
            end
        endcase
        // $display("alu: o_data : %d", o_data);
    end
    
endmodule