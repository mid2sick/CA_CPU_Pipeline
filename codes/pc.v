module pc #(
    parameter INST_W = 32,
    parameter ADDR_W = 64
)(
    input                       i_clk,
    input                       i_rst_n,
    input                       i_change,
    input                       i_no_hazard,
    input       [ADDR_W-1:0]    i_inst_addr,
    output reg  [ADDR_W-1:0]    o_inst_addr,
    output reg                  o_valid_inst_addr
);

    reg [2:0] clk_cnt;
    

    always @(posedge i_clk or negedge i_rst_n) begin
        if(~i_rst_n) begin
            o_inst_addr <= 64'b0;
            o_valid_inst_addr <= 1'b1;
            clk_cnt <= 0;
        end else begin
            if(i_no_hazard != 0) begin
                if(clk_cnt >= 4) begin  // if clk_cnt == 4
                    o_inst_addr <= i_inst_addr;
                    o_valid_inst_addr <= 1'b1;
                    clk_cnt = 0;
                end else begin
                    o_inst_addr <= o_inst_addr;
                    o_valid_inst_addr <= 1'b0;
                    clk_cnt ++;
                end
            end else begin
                o_inst_addr <= o_inst_addr;
                o_valid_inst_addr <= 1'b0;
                clk_cnt ++;
            end
        end
    end


endmodule