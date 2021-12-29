module beq_detector #(
    parameter DATA_W = 64
)(
    input                   i_branch,
    input                   i_ne,       // if it is bne or beq
    input  [DATA_W-1:0]     i_rs1_data,
    input  [DATA_W-1:0]     i_rs2_data,
    output                  o_branch
);

    assign o_branch = (i_branch && ((i_ne && i_rs1_data != i_rs2_data) || (~i_ne && i_rs1_data == i_rs2_data)));
endmodule