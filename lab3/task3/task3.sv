module task3 (
    input  logic       CLOCK_50,
    input  logic [3:0] KEY,
    input  logic [9:0] SW,
    output logic [6:0] HEX0,
    output logic [6:0] HEX1,
    output logic [6:0] HEX2,
    output logic [6:0] HEX3,
    output logic [6:0] HEX4,
    output logic [6:0] HEX5,
    output logic [9:0] LEDR
);

    // your code here
    reg [7:0] ct_addr, ct_wrdata, ct_rddata, pt_addr, pt_wrdata, pt_rddata;
    reg ct_wren, pt_wren, en_arc4, rdy_arc4;
    reg [23:0] key;

    assign key = 'h1E4600;

    ct_mem ct (
        .address(ct_addr),
        .clock(CLOCK_50),
        .data(ct_wrdata),
        .wren(ct_wren),
        .q(ct_rddata)
    );
    pt_mem pt (
        .address(pt_addr),
        .clock(CLOCK_50),
        .data(pt_wrdata),
        .wren(pt_wren),
        .q(pt_rddata)
    );
    arc4 a4 (
        .clk(CLOCK_50),
        .rst_n(KEY[3]),
        .en(en_arc4),
        .rdy(rdy_arc4),
        .key(key),
        .ct_addr(ct_addr),
        .ct_rddata(ct_rddata),
        .pt_addr(pt_addr),
        .pt_rddata(pt_rddata),
        .pt_wrdata(pt_wrdata),
        .pt_wren(pt_wren)
    );

    // your code here




endmodule : task3
