module alu_control #(
    parameter ADD = 3'b000,
    parameter SUB = 3'b001,
    parameter AND = 3'b010,
    parameter OR  = 3'b011,
    parameter XOR = 3'b100,
    parameter SLL = 3'b101,
    parameter SRL = 3'b110
)(
    input  [2:0]        i_func3,
    input  [6:0]        i_func7,
    input  [1:0]        i_aluOp,
    output reg [2:0]    o_alu_control
);

    always @(*) begin
        if(i_aluOp == 2'b00) begin              // I-type
            case(i_func3)
                3'b011: begin                   // load
                    o_alu_control <= ADD;
                end
                3'b000: begin
                    o_alu_control <= ADD;
                end
                3'b100: begin
                    o_alu_control <= XOR;
                end
                3'b110: begin
                    o_alu_control <= OR;
                end
                3'b111: begin
                    o_alu_control <= AND;
                end
                3'b001: begin
                    o_alu_control <= SLL;
                end
                3'b101: begin
                    o_alu_control <= SRL;
                end
                default: begin
                    o_alu_control <= ADD;
                end
            endcase
        end else if(i_aluOp == 2'b01) begin     // SD
            o_alu_control <= ADD;
        end else if(i_aluOp == 2'b10) begin     // BRANCH
            o_alu_control <= SUB;
        end else begin                          // R-type, i_aluO- == 2'b11
            case(i_func3)
                3'b000: begin
                    o_alu_control <= (i_func7[5] == 1)? SUB : ADD;
                end
                3'b100: begin
                    o_alu_control <= XOR;
                end
                3'b110: begin
                    o_alu_control <= OR;
                end
                3'b111: begin
                    o_alu_control <= AND;
                end
                default: begin
                    o_alu_control <= ADD;
                end
            endcase
        end
    end
    
endmodule