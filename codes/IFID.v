module IFID #(
    parameter INST_W = 32,
    parameter ADDR_W = 64
)(
    input                       i_clk,
    input                       i_rst_n,
    input  [INST_W-1:0]         i_inst,
    input                       i_valid_inst,
    input  [ADDR_W-1:0]         i_inst_addr,
    input                       i_flush,
    output reg [INST_W-1:0]     o_inst,
    output reg [ADDR_W-1:0]     o_inst_addr,
    output                      o_next_inst
);

    reg o_next_inst_r, o_next_inst_w;

    assign o_next_inst = o_next_inst_r;

    always @(*) begin
        if(i_inst != o_inst) begin
            o_next_inst_w = 1;
        end else begin
            o_next_inst_w = 0;
        end
    end

    always@(posedge i_clk or negedge i_rst_n) begin
        if(~i_rst_n) begin
            o_inst <= 32'b0;
            o_inst_addr <= 64'b0;
            o_next_inst_r <= 1'b0;
        end
        else if (i_flush) begin     // nop
            // $display("i flush in ifid");
            o_inst <= 32'b0;
            o_inst_addr <= 64'b0;
            o_next_inst_r <= 1'b0;
        end else begin                  // store for next stage 
            o_inst <= i_inst;
            o_inst_addr <= i_inst_addr;
            o_next_inst_r <= o_next_inst_w;       
        end
    end

endmodule