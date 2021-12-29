// to deal with load hazard
module hazard_detector (
    input           i_memRead,
    input [4:0]     i_rs1_addr,
    input [4:0]     i_rs2_addr,
    input [4:0]     i_rd_addr,
    
    output          o_stall,
    output          o_nop,
    output          o_hazard
);

    assign o_stall = (i_memRead && ((i_rs1_addr == i_rd_addr) || (i_rs2_addr == i_rd_addr)));
    assign o_nop = o_stall;
    assign o_hazard = ~o_stall;
    
endmodule