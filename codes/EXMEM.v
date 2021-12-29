module EXMEM #(
    parameter DATA_W = 64
)(
    input                       i_clk,
    input                       i_rst_n,
    input                       i_memRead,
    input                       i_memToReg,
    input                       i_memWrite,
    input                       i_regWrite,
    input [DATA_W-1:0]          i_alu_out,
    input [DATA_W-1:0]          i_rs2_data,
    input [4:0]                 i_rd_addr,
    input [DATA_W-1:0]          i_alu_data1,
    input [31:0]                i_inst,

    output reg                  o_memRead,
    output reg                  o_memToReg,
    output reg                  o_memWrite,
    output reg                  o_regWrite,
    output reg [DATA_W-1:0]     o_alu_out,
    output reg [DATA_W-1:0]     o_rs2_data,
    output reg [4:0]            o_rd_addr,
    output reg [DATA_W-1:0]     o_alu_data1,
    output reg [31:0]           o_inst
);

    always @(posedge i_clk or negedge i_rst_n) begin
        if(~i_rst_n) begin
            o_memRead   <= 1'b0;
            o_memToReg  <= 1'b0;
            o_memWrite  <= 1'b0;
            o_regWrite  <= 1'b0;
            o_alu_out   <= 64'b0;
            o_rs2_data  <= 64'b0;
            o_rd_addr   <= 5'b0;
            o_alu_data1 <= 64'b0;
            o_inst      <= 32'b0;
        end else begin
            o_memRead   <= i_memRead;
            o_memToReg  <= i_memToReg;
            o_memWrite  <= i_memWrite;
            o_regWrite  <= i_regWrite;
            o_alu_out   <= i_alu_out;
            o_rs2_data  <= i_rs2_data;
            o_rd_addr   <= i_rd_addr;
            o_alu_data1 <= i_alu_data1;
            o_inst      <= i_inst;
        end
        // $display("EXMEM: inst: %b\nmemRead: %d, memWrite: %d, o_alu_out: %d\n", i_inst, i_memRead, i_memWrite, i_alu_out);
    end
    
endmodule