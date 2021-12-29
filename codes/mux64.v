module mux64 #(
    parameter DATA_W = 64
)(
    input   [DATA_W-1:0]    i_data0,
    input   [DATA_W-1:0]    i_data1,
    input                   i_select,
    output  [DATA_W-1:0]    o_data
);

    assign o_data = (i_select == 0)? i_data0 : i_data1;
    
endmodule