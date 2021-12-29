module register #(
    parameter DATA_W = 64
)(
    input                       i_clk,
    input                       i_rst_n,
    input       [4:0]           i_rs1_addr,
    input       [4:0]           i_rs2_addr,
    input       [4:0]           i_rd_addr,
    input       [DATA_W-1:0]    i_rd_data,
    input                       i_regWrite,
    input                       i_memToReg,
    // input                       i_ld_stall,
    output  [DATA_W-1:0]        o_rs1_data,
    output  [DATA_W-1:0]        o_rs2_data
);

    reg signed [DATA_W-1:0]     register[0:31];
    reg                         memToReg_tmp;
    reg        [4:0]            rd_addr_tmp;
    integer i, cnt = 0;

    // forwarding the data if used
    assign o_rs1_data = (i_regWrite && i_rs1_addr == i_rd_addr)? i_rd_data : register[i_rs1_addr];
    assign o_rs2_data = (i_regWrite && i_rs2_addr == i_rd_addr)? i_rd_data : register[i_rs2_addr];
    
    always @(posedge i_clk or negedge i_rst_n) begin
        memToReg_tmp <= i_memToReg;
        rd_addr_tmp <= i_rd_addr;
        if(~i_rst_n) begin
            for(i = 0; i <= 31; i ++)
                register[i] <= 0;
        end else if(i_regWrite && i_rd_addr != 0) begin
            register[i_rd_addr] <= i_rd_data;
            
            /*if(i_rd_addr == 29 || i_rd_addr == 30 || i_rd_addr == 31) begin
                $display("register: let reg[%d] = %d", i_rd_addr, i_rd_data);
            end*/
        end
        // end
    end
endmodule