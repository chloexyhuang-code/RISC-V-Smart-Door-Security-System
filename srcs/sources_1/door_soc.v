`timescale 1ns / 1ps

module door_soc(
    input  wire clk,

    input  wire [3:0] sw,
    input  wire btn0,
    input  wire btn1,
    input  wire btn2,

    output wire [3:0] led,
    output wire [6:0] seg,
    output wire [3:0] an
);

    // 32-bit word memory¡A°t¦X 32-bit firmware.hex
    reg [31:0] memory [0:1023];

    initial begin
        $display("LOADING firmware.hex");
        $readmemh("firmware.hex", memory);
    end

    // reset generator
    reg [7:0] reset_cnt = 0;
    wire resetn = &reset_cnt;

    always @(posedge clk) begin
        if (!resetn)
            reset_cnt <= reset_cnt + 1;
    end

    // PicoRV32 memory interface
    wire        mem_valid;
    wire        mem_instr;
    reg         mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0]  mem_wstrb;
    reg  [31:0] mem_rdata;
    wire        trap;

    // I/O registers
    reg [3:0] led_reg  = 4'b0000;
    reg [3:0] seg_num  = 4'd0;
    reg [7:0] uart_reg = 8'd0;

    // Debug LED:
    // led[3] = trap
    // led[2] = resetn
    // led[1] = mem_valid
    // led[0] = mem_ready
   assign led = led_reg;

    assign an = 4'b1110;

    assign seg =
        (seg_num == 4'd0)  ? 7'b1000000 :
        (seg_num == 4'd1)  ? 7'b1111001 :
        (seg_num == 4'd10) ? 7'b0001000 :
        (seg_num == 4'd12) ? 7'b1000111 :
        (seg_num == 4'd13) ? 7'b1000110 :
        (seg_num == 4'd14) ? 7'b0000110 :
                              7'b1111111;

    picorv32 #(
    .ENABLE_COUNTERS(0),
    .ENABLE_COUNTERS64(0),
    .ENABLE_REGS_16_31(1),
    .ENABLE_REGS_DUALPORT(1),
    .TWO_STAGE_SHIFT(1),
    .BARREL_SHIFTER(0),

    .COMPRESSED_ISA(0),
    .ENABLE_MUL(0),
    .ENABLE_DIV(0),

    .CATCH_MISALIGN(1),
    .CATCH_ILLINSN(1),

    .PROGADDR_RESET(32'h00000000),
    .STACKADDR(32'h00001000)
) cpu (
        .clk(clk),
        .resetn(resetn),

        .trap(trap),

        .mem_valid(mem_valid),
        .mem_instr(mem_instr),
        .mem_ready(mem_ready),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_wstrb(mem_wstrb),
        .mem_rdata(mem_rdata),

        .irq(32'b0)
    );

    always @(posedge clk) begin
        mem_ready <= 1'b0;

        if (mem_valid && !mem_ready) begin
            mem_ready <= 1'b1;
            mem_rdata <= 32'h00000000;

            // INPUT register: 0x10000000
            if (mem_addr == 32'h10000000) begin
                mem_rdata <= {25'b0, btn2, btn1, btn0, sw};
            end

            // LED register: 0x10000004
            else if (mem_addr == 32'h10000004) begin
                mem_rdata <= {28'b0, led_reg};
                if (mem_wstrb != 4'b0000)
                    led_reg <= mem_wdata[3:0];
            end

            // SEG register: 0x10000008
            else if (mem_addr == 32'h10000008) begin
                mem_rdata <= {28'b0, seg_num};
                if (mem_wstrb != 4'b0000)
                    seg_num <= mem_wdata[3:0];
            end

            // UART log register: 0x1000000C
            else if (mem_addr == 32'h1000000C) begin
                mem_rdata <= {24'b0, uart_reg};
                if (mem_wstrb != 4'b0000)
                    uart_reg <= mem_wdata[7:0];
            end

            // RAM / instruction memory
            else begin
                mem_rdata <= memory[mem_addr[11:2]];

                if (mem_wstrb[0]) memory[mem_addr[11:2]][7:0]   <= mem_wdata[7:0];
                if (mem_wstrb[1]) memory[mem_addr[11:2]][15:8]  <= mem_wdata[15:8];
                if (mem_wstrb[2]) memory[mem_addr[11:2]][23:16] <= mem_wdata[23:16];
                if (mem_wstrb[3]) memory[mem_addr[11:2]][31:24] <= mem_wdata[31:24];
            end
        end
    end

endmodule