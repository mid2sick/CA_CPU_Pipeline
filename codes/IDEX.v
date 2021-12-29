module IDEX #(
    parameter INST_W = 32,
    parameter ADDR_W = 64,
    parameter DATA_W = 64
)(
    input                       i_clk,
    input                       i_rst_n,
    input                       i_memRead,
    input                       i_memToReg,
    input  [1:0]                i_aluOp,
    input                       i_memWrite,
    input                       i_aluSrc,
    input                       i_regWrite,
    input  [DATA_W-1:0]         i_rs1_data,
    input  [DATA_W-1:0]         i_rs2_data,
    input  [DATA_W-1:0]         i_imm,
    input  [INST_W-1:0]         i_inst,
    // input                       i_ld_stall,


    output reg                  o_memRead,
    output reg                  o_memToReg,
    output reg [1:0]            o_aluOp,
    output reg                  o_memWrite,
    output reg                  o_aluSrc,
    output reg                  o_regWrite,
    output reg [DATA_W-1:0]     o_rs1_data,
    output reg [DATA_W-1:0]     o_rs2_data,
    output reg [DATA_W-1:0]     o_imm,
    output reg [INST_W-1:0]     o_inst
);

    always @(posedge i_clk or negedge i_rst_n) begin
        if(~i_rst_n) begin
            o_memRead  <= 1'b0;
            o_memToReg <= 1'b0;
            o_aluOp    <= 2'b0;
            o_memWrite <= 1'b0;
            o_aluSrc   <= 1'b0;
            o_regWrite <= 1'b0;
            o_rs1_data <= 64'b0;
            o_rs2_data <= 64'b0;
            o_imm      <= 64'b0;
            o_inst     <= 32'b0;
        end else begin
            o_memRead  <= i_memRead;
            o_memToReg <= i_memToReg;
            o_aluOp    <= i_aluOp;
            o_memWrite <= i_memWrite;
            o_aluSrc   <= i_aluSrc;
            o_regWrite <= i_regWrite;
            o_rs1_data <= i_rs1_data;
            o_rs2_data <= i_rs2_data;
            o_imm      <= i_imm;
            o_inst     <= i_inst;
        end
    end
    
endmodule