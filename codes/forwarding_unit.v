module forwarding_unit (
    input [4:0]         i_IDEX_rs1_addr,
    input [4:0]         i_IDEX_rs2_addr,
    input [4:0]         i_EXMEM_rd_addr,
    input               i_EXMEM_regWrite,
    input [4:0]         i_MEMWB_rd_addr,
    input               i_MEMWB_regWrite,
    // input               i_d_valid_data,

    output reg [1:0]    o_forwardA,
    output reg [1:0]    o_forwardB
    // output reg          o_stall
);

    always @(*) begin
        // forward A
        if(i_EXMEM_regWrite && i_IDEX_rs1_addr == i_EXMEM_rd_addr && i_IDEX_rs1_addr != 0) begin
            // $display("forward A!");
            o_forwardA = 2'b10;
        end else if(i_MEMWB_regWrite && i_IDEX_rs1_addr == i_MEMWB_rd_addr && i_IDEX_rs1_addr != 0) begin
            o_forwardA = 2'b01;
        end else begin
            o_forwardA = 2'b00;
        end

        // forward B
        if(i_EXMEM_regWrite && i_IDEX_rs2_addr == i_EXMEM_rd_addr && i_IDEX_rs2_addr != 0) begin
            o_forwardB = 2'b10;
        end else if(i_MEMWB_regWrite && i_IDEX_rs2_addr == i_MEMWB_rd_addr && i_IDEX_rs2_addr != 0) begin
            o_forwardB = 2'b01;
        end else begin
            o_forwardB = 2'b00;
        end
    end
    
endmodule