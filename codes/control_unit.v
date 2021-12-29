module control_unit #(    
    parameter LD = 7'b0000011,
    parameter SD = 7'b0100011,
    parameter BRANCH = 7'b1100011,
    parameter ALU_IMM = 7'b0010011,
    parameter ALU = 7'b0110011,
    parameter DONE = 7'b1111111
)(
    input               i_nop,
    input  [6:0]        i_opcode,
    output reg          o_branch,
    output reg          o_memRead,
    output reg          o_memToReg,
    output reg [1:0]    o_aluOp,
    output reg          o_memWrite,
    output reg          o_aluSrc,
    output reg          o_regWrite,
    output reg          o_finish
);

    always @(*) begin
        if(i_nop) begin
            // $display("control unit: no operations");
            o_branch <= 1'b0;
            o_memRead <= 1'b0;
            o_memToReg <= 1'b0;
            o_aluOp <=  2'b00;
            o_memWrite <= 1'b0;
            o_aluSrc <= 1'b0;
            o_regWrite <= 1'b0; 
            o_finish <= 1'b0;
        end else begin
            // $display("control unit: opcode: %b", i_opcode);
            case(i_opcode)
                LD: begin
                    o_branch <= 1'b0;
                    o_memRead <= 1'b1;
                    o_memToReg <= 1'b1;
                    o_aluOp <=  2'b00;
                    o_memWrite <= 1'b0;
                    o_aluSrc <= 1'b1;
                    o_regWrite <= 1'b1;
                    o_finish <= 1'b0;
                end
                SD: begin
                    // $display("control unit: store");
                    o_branch <= 1'b0;
                    o_memRead <= 1'b0;
                    o_memToReg <= 1'b0;
                    o_aluOp <=  2'b01;
                    o_memWrite <= 1'b1;
                    o_aluSrc <= 1'b1;
                    o_regWrite <= 1'b0;
                    o_finish <= 1'b0;
                end
                BRANCH: begin
                    // $display("control unit: branch");
                    o_branch <= 1'b1;
                    o_memRead <= 1'b0;
                    o_memToReg <= 1'b0;
                    o_aluOp <=  2'b10;
                    o_memWrite <= 1'b0;
                    o_aluSrc <= 1'b0;
                    o_regWrite <= 1'b0;
                    o_finish <= 1'b0;
                end
                ALU_IMM: begin
                    // $display("control unit: alu_imm");
                    o_branch <= 1'b0;
                    o_memRead <= 1'b0;
                    o_memToReg <= 1'b0;
                    o_aluOp <=  2'b00;
                    o_memWrite <= 1'b0;
                    o_aluSrc <= 1'b1;
                    o_regWrite <= 1'b1;
                    o_finish <= 1'b0;
                end
                ALU: begin
                    o_branch <= 1'b0;
                    o_memRead <= 1'b0;
                    o_memToReg <= 1'b0;
                    o_aluOp <=  2'b11;
                    o_memWrite <= 1'b0;
                    o_aluSrc <= 1'b0;
                    o_regWrite <= 1'b1;
                    o_finish <= 1'b0;
                end
                DONE: begin              // instruction end
                    o_branch <= 1'b0;
                    o_memRead <= 1'b0;
                    o_memToReg <= 1'b0;
                    o_aluOp <=  2'b00;
                    o_memWrite <= 1'b0;
                    o_aluSrc <= 1'b0;
                    o_regWrite <= 1'b0;
                    o_finish <= 1'b1;
                    // $display("control unit: finish");
                    // $display("control unit: opcode: %b", i_opcode);
                end 
                default: begin              // instruction end
                    o_branch <= 1'b0;
                    o_memRead <= 1'b0;
                    o_memToReg <= 1'b0;
                    o_aluOp <=  2'b00;
                    o_memWrite <= 1'b0;
                    o_aluSrc <= 1'b0;
                    o_regWrite <= 1'b0;
                    o_finish <= 1'b0;
                    // $display("control unit: opcode: %b", i_opcode);
                end 
            endcase
        end
    end
    
endmodule