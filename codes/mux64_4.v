module mux64_4 #(
    parameter DATA_W = 64
)(
    input [DATA_W-1:0]          i_data0,
    input [DATA_W-1:0]          i_data1,
    input [DATA_W-1:0]          i_data2,
    input [DATA_W-1:0]          i_data3,
    input [1:0]                 i_select,

    output reg [DATA_W-1:0]     o_data
);

    always @(*) begin
        case(i_select)
            2'b00: begin
                o_data = i_data0;
            end
            2'b01: begin
                o_data = i_data1;
            end
            2'b10: begin
                o_data = i_data2;
            end
            default: begin
                o_data = i_data3;
            end
        endcase
        // $display("in forwardData mux: o_data = %d, d0: %d, d1: %d, d2: %d", o_data, i_data0, i_data1, i_data2);
    end
    
endmodule