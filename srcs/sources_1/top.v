module top(
    input wire clk,
    input wire [3:0] sw,
    input wire btn0,
    input wire btn1,
    input wire btn2,
    output wire [3:0] led,
    output wire [6:0] seg,
    output wire [3:0] an
);

    door_soc soc_inst (
        .clk(clk),
        .sw(sw),
        .btn0(btn0),
        .btn1(btn1),
        .btn2(btn2),
        .led(led),
        .seg(seg),
        .an(an)
    );

endmodule