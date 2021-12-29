module cpu #( // Do not modify interface
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64,

    parameter STOP = 32'b11111111111111111111111111111111,

    parameter LD = 7'b0000011,
    parameter SD = 7'b0100011,
    parameter BRANCH = 7'b1100011,
    parameter ALU_IMM = 7'b0010011,
    parameter ALU = 7'b0110011,

    parameter BEQ = 3'b000,
    parameter BNE = 3'b001,

    parameter ADD_SUB = 3'b000,
    parameter XOR = 3'b100,
    parameter OR = 3'b110,
    parameter AND = 3'b111,
    parameter SLL = 3'b001,
    parameter SRL = 3'b101

)(
    input                   i_clk,
    input                   i_rst_n,
    input                   i_i_valid_inst, // from instruction memory
    input  [INST_W-1:0]     i_i_inst,       // from instruction memory
    input                   i_d_valid_data, // from data memory
    input  [DATA_W-1:0]     i_d_data,       // from data memory
    output                  o_i_valid_addr, // to instruction memory
    output [ADDR_W-1:0]     o_i_addr,       // to instruction memory
    output [DATA_W-1:0]     o_d_w_data,     // to data memory
    output [ADDR_W-1:0]     o_d_w_addr,     // to data memory
    output [ADDR_W-1:0]     o_d_r_addr,     // to data memory
    output                  o_d_MemRead,    // to data memory
    output                  o_d_MemWrite,   // to data memory
    output                  o_finish
);

// homework
    // wires and registers
    reg [2:0]               finish_cnt;
    wire                    o_finish_w;
    reg                     o_finish_r;
    wire [ADDR_W-1:0]       o_d_addr;

    // continuous assignment (always active)
    // note that in assign, left side is always a wire
    assign o_d_r_addr = o_d_addr;
    assign o_d_w_addr = o_d_addr;
    assign o_finish = o_finish_r;

    // stage IF
    pc pc(
        .i_clk                  (i_clk),
        .i_rst_n                (i_rst_n),
        .i_no_hazard            (hazard_detector.o_hazard),
        .i_change               (IFID.o_next_inst),
        .i_inst_addr            (pc_choose.o_data), 
        .o_inst_addr            (o_i_addr),
        .o_valid_inst_addr      (o_i_valid_addr)
    );

    adder add_pc_next(
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_data0        (pc.o_inst_addr),
        .i_data1        (64'b100),
        .o_data         ()
    );

    IFID IFID(
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_inst         (i_i_inst),
        .i_valid_inst   (i_i_valid_inst),
        .i_inst_addr    (pc.o_inst_addr),
        .i_flush        (beq_detector.o_branch),
        .o_inst         (),
        .o_inst_addr    (),
        .o_next_inst    ()
    );

    // stage ID

    hazard_detector hazard_detector(
        .i_memRead      (IDEX.o_memRead),
        .i_rs1_addr     (IFID.o_inst[19:15]),
        .i_rs2_addr     (IFID.o_inst[24:20]),
        .i_rd_addr      (IDEX.o_inst[11:7]),

        .o_stall        (),
        .o_nop          (),
        .o_hazard       ()
    );

    imm_gen imm_gen(
        .i_inst         (IFID.o_inst),
        .o_imm          ()
    );

    control_unit control_unit(
        .i_nop          (hazard_detector.o_nop),
        .i_opcode       (IFID.o_inst[6:0]),
        .o_branch       (),
        .o_memRead      (),
        .o_memToReg     (),
        .o_aluOp        (),
        .o_memWrite     (),
        .o_aluSrc       (),
        .o_regWrite     (),
        .o_finish       (o_finish_w)
    );

    register register(
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_rs1_addr     (IFID.o_inst[19:15]),
        .i_rs2_addr     (IFID.o_inst[24:20]),
        .i_rd_addr      (MEMWB.o_rd_addr),
        .i_rd_data      (write_reg.o_data),
        .i_regWrite     (MEMWB.o_regWrite),
        .i_memToReg     (MEMWB.o_memToReg),
        .o_rs1_data     (),
        .o_rs2_data     ()
    );

    beq_detector beq_detector(
        .i_branch       (control_unit.o_branch),
        .i_ne           (IFID.o_inst[12]),
        .i_rs1_data     (register.o_rs1_data),
        .i_rs2_data     (register.o_rs2_data),
        .o_branch       ()
    );

    adder add_pc_branch(
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_data0        (IFID.o_inst_addr),
        .i_data1        ($signed(imm_gen.o_imm) <<< 1),     // <<< performs sign extension
        .o_data         ()
    );

    mux64 pc_choose(
        .i_data0        (add_pc_next.o_data),
        .i_data1        (add_pc_branch.o_data),
        .i_select       (beq_detector.o_branch),
        .o_data         ()
    );

    IDEX IDEX(
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_memRead      (control_unit.o_memRead),
        .i_memToReg     (control_unit.o_memToReg),
        .i_aluOp        (control_unit.o_aluOp),
        .i_memWrite     (control_unit.o_memWrite),
        .i_aluSrc       (control_unit.o_aluSrc),
        .i_regWrite     (control_unit.o_regWrite),
        .i_rs1_data     (register.o_rs1_data),
        .i_rs2_data     (register.o_rs2_data),
        .i_imm          (imm_gen.o_imm),
        .i_inst         (IFID.o_inst),

        .o_memRead      (),
        .o_memToReg     (),
        .o_aluOp        (),
        .o_memWrite     (),
        .o_aluSrc       (),
        .o_regWrite     (),
        .o_rs1_data     (),
        .o_rs2_data     (),
        .o_imm          (),
        .o_inst         ()
    );

    // stage EX
    
    
    mux64 alu_data1_choose(
        .i_data0        (forwardB.o_data),
        .i_data1        (IDEX.o_imm),
        .i_select       (IDEX.o_aluSrc),
        .o_data         ()
    );

    alu_control alu_control(
        .i_func3        (IDEX.o_inst[14:12]),
        .i_func7        (IDEX.o_inst[31:25]),
        .i_aluOp        (IDEX.o_aluOp),
        .o_alu_control  ()
    );

    alu alu(
        .i_data0        (forwardA.o_data),
        .i_data1        (alu_data1_choose.o_data),
        .i_alu_control  (alu_control.o_alu_control),
        .o_data         ()
    );

    EXMEM EXMEM(
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_memRead      (IDEX.o_memRead),
        .i_memToReg     (IDEX.o_memToReg),
        .i_memWrite     (IDEX.o_memWrite),
        .i_regWrite     (IDEX.o_regWrite),
        .i_alu_out      (alu.o_data),
        .i_rs2_data     (forwardB.o_data),
        .i_rd_addr      (IDEX.o_inst[11:7]),
        .i_alu_data1    (alu_data1_choose.o_data),
        .i_inst         (IDEX.o_inst),
        // .i_ld_stall     (forwarding_unit.o_stall),

        .o_memRead      (o_d_MemRead),
        .o_memToReg     (),
        .o_memWrite     (o_d_MemWrite),
        .o_regWrite     (),
        .o_alu_out      (o_d_addr),
        .o_alu_data1    (),
        .o_rs2_data     (o_d_w_data),
        .o_rd_addr      (),
        .o_inst         ()
    );

    // stage MEM

    MEMWB MEMWB(
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_regWrite     (EXMEM.o_regWrite),
        .i_memToReg     (EXMEM.o_memToReg),
        .i_alu_out      (EXMEM.o_alu_out),
        .i_d_valid_data (i_d_valid_data),
        .i_memory_data  (i_d_data),
        .i_rd_addr      (EXMEM.o_rd_addr),
        .i_inst         (EXMEM.o_inst),
        // .i_ld_stall     (forwarding_unit.o_stall),

        .o_regWrite     (),
        .o_memToReg     (),
        .o_alu_out      (),
        .o_memory_data  (),
        .o_rd_addr      (),
        .o_inst         ()
    );

    // stage WB

    mux64 write_reg(
        .i_data0        (MEMWB.o_alu_out),
        .i_data1        (MEMWB.o_memory_data),
        .i_select       (MEMWB.o_memToReg),
        .o_data         ()
    );

    // forwarding
    forwarding_unit forwarding_unit(
        .i_IDEX_rs1_addr        (IDEX.o_inst[19:15]),
        .i_IDEX_rs2_addr        (IDEX.o_inst[24:20]),
        .i_EXMEM_rd_addr        (EXMEM.o_rd_addr),
        .i_EXMEM_regWrite       (EXMEM.o_regWrite),
        .i_MEMWB_rd_addr        (MEMWB.o_rd_addr),
        .i_MEMWB_regWrite       (MEMWB.o_regWrite),
        .o_forwardA             (),
        .o_forwardB             ()
    );

    mux64_4 forwardA(
        .i_data0        (IDEX.o_rs1_data),
        .i_data1        (write_reg.o_data),
        .i_data2        (EXMEM.o_alu_out),
        .i_data3        (64'b0),
        .i_select       (forwarding_unit.o_forwardA),
        .o_data         ()
    );

    mux64_4 forwardB(
        .i_data0        (IDEX.o_rs2_data),
        .i_data1        (write_reg.o_data),
        .i_data2        (EXMEM.o_alu_out),
        .i_data3        (64'b0),
        .i_select       (forwarding_unit.o_forwardB),
        .o_data         ()
    );

    always @(*) begin
        if(o_finish_w && finish_cnt == 0) begin
            finish_cnt ++;
        end
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if(~i_rst_n) begin
            finish_cnt <= 0;
        end else begin
            if(finish_cnt > 0) begin
                finish_cnt <= finish_cnt + 1;
            end
            if(finish_cnt >= 3) begin
                o_finish_r <= 1'b1;
            end else begin
                o_finish_r <= 1'b0;
            end
        end
    end

endmodule
