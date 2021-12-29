module MEMWB #(
    parameter DATA_W = 64
)(
    input                       i_clk,
    input                       i_rst_n,
    input                       i_memToReg,
    input                       i_regWrite,
    input [DATA_W-1:0]          i_alu_out,
    input                       i_d_valid_data,
    input [DATA_W-1:0]          i_memory_data,
    input [4:0]                 i_rd_addr,
    input [31:0]                i_inst,
    // input                       i_ld_stall,

    output reg                  o_memToReg,
    output reg                  o_regWrite,
    output reg [DATA_W-1:0]     o_alu_out,
    output     [DATA_W-1:0]     o_memory_data,
    output reg [4:0]            o_rd_addr,
    output reg [31:0]           o_inst
);

    reg                  memToReg_tmp;
    reg                  regWrite_tmp;
    reg [DATA_W-1:0]     alu_out_tmp;
    reg [4:0]            rd_addr_tmp;
    reg [31:0]           inst_tmp;
    
    reg                  memToReg_tmp1;
    reg                  regWrite_tmp1;
    reg [DATA_W-1:0]     alu_out_tmp1;
    reg [4:0]            rd_addr_tmp1;
    reg [31:0]           inst_tmp1;

    reg [DATA_W-1:0]     o_memory_data_r, o_memory_data_w;

    assign o_memory_data = o_memory_data_r;

    // do we need to check if the data is ready?
    
    always @(*) begin
        if(i_d_valid_data) begin
            o_memory_data_w = i_memory_data;
        end else begin
            o_memory_data_w = o_memory_data_r;
        end
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if(~i_rst_n) begin
            o_memToReg      <= 1'b0;
            o_regWrite      <= 1'b0;
            o_alu_out       <= 64'b0;
            o_memory_data_r <= 64'b0;
            o_rd_addr       <= 5'b0;
            o_inst          <= 32'b0;
            
            memToReg_tmp    <= 1'b0;
            regWrite_tmp    <= 1'b0;
            alu_out_tmp     <= 64'b0;
            rd_addr_tmp     <= 5'b0;
            inst_tmp        <= 32'b0;
        end else begin
            memToReg_tmp    <= i_memToReg;
            regWrite_tmp    <= i_regWrite;
            alu_out_tmp     <= i_alu_out;
            rd_addr_tmp     <= i_rd_addr;
            inst_tmp        <= i_inst;

            memToReg_tmp1   <= memToReg_tmp;
            regWrite_tmp1   <= regWrite_tmp;
            alu_out_tmp1    <= alu_out_tmp;
            rd_addr_tmp1    <= rd_addr_tmp;
            inst_tmp1       <= inst_tmp;

            o_memToReg      <= memToReg_tmp1;
            o_regWrite      <= regWrite_tmp1;
            o_alu_out       <= alu_out_tmp1;
            o_memory_data_r <= o_memory_data_w;
            o_rd_addr       <= rd_addr_tmp1;
            o_inst          <= inst_tmp1;
        end
        // $display("in MEMWB: i_inst: %b\nalu_out: %d, rd_addr: %d, regWrite: %d\n", i_inst, i_alu_out, i_rd_addr, i_regWrite);
    end
    
endmodule