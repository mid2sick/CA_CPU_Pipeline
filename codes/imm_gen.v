module imm_gen #(
    parameter INST_W = 32,
    parameter ADDR_W = 64,
    
    parameter LD = 7'b0000011,
    parameter SD = 7'b0100011,
    parameter BRANCH = 7'b1100011,
    parameter ALU_IMM = 7'b0010011,
    parameter ALU = 7'b0110011
)(
    input       [INST_W-1:0]     i_inst,
    output reg  [ADDR_W-1:0]     o_imm
);

    always @(i_inst) begin
        case(i_inst[6:0])
            LD, ALU_IMM: begin
                o_imm <= { {52{i_inst[31]}}, i_inst[31:20]};
            end
            SD: begin
                o_imm <= { {52{i_inst[31]}}, i_inst[31:25], i_inst[11:7]};
            end
            BRANCH: begin
                o_imm <= { {52{i_inst[31]}}, i_inst[31], i_inst[7], i_inst[30:25], i_inst[11:8]};
            end
            ALU: begin
                o_imm <= 64'b0;
            end
            default: begin
                o_imm <= 64'b0;
            end
        endcase
    end
    
endmodule