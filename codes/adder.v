module adder #(
    parameter DATA_W = 64
)(
    input                   i_clk,
    input                   i_rst_n,
    input  [DATA_W-1:0]     i_data0,
    input  [DATA_W-1:0]     i_data1,
    output [DATA_W-1:0]     o_data
);
    /*
    reg [DATA_W/2:0] tmp0_r, tmp0_w;
    reg [DATA_W/2:0] tmp1_r, tmp1_w;
    reg [DATA_W-1:0] o_data_r, o_data_w;
    
    assign o_data = o_data_r;

    always @(*) begin
        tmp0_w = i_data0[DATA_W/2-1:0] + i_data1[DATA_W/2-1:0];
        tmp1_w = i_data0[DATA_W-1:DATA_W/2] + i_data1[DATA_W-1:DATA_W/2] + tmp0_r[DATA_W/2];
        o_data_w = {tmp1_r[DATA_W/2-1:0], tmp0_r[DATA_W/2-1:0]};
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if(~i_rst_n) begin
            tmp0_r <= 0;
            tmp1_r <= 0;
            o_data_r <= 0;
        end else begin
            tmp0_r <= tmp0_w;
            tmp1_r <= tmp1_w;
            o_data_r <= o_data_w;
        end
    end
    */
    assign o_data = i_data0 + i_data1;

endmodule