module tb_ahb_slave_interface;

/////////////////////////////////////////////////
// Inputs
/////////////////////////////////////////////////

reg         hclk;
reg         hresetn;
reg         hwrite;
reg         hreadyin;
reg [31:0]  hwdata;
reg [31:0]  haddr;
reg [31:0]  prdata;
reg [1:0]   htrans;

/////////////////////////////////////////////////
// Outputs
/////////////////////////////////////////////////

wire [31:0] hrdata;
wire [31:0] haddr1;
wire [31:0] haddr2;
wire [31:0] hwdata1;
wire [31:0] hwdata2;

wire        hwrite_reg;
wire        hwrite_reg1;
wire        valid;

wire [2:0]  temp_selx;

/////////////////////////////////////////////////
// DUT
/////////////////////////////////////////////////

ahb_slave_interface DUT(

    .hclk(hclk),
    .hresetn(hresetn),
    .hwrite(hwrite),
    .hreadyin(hreadyin),

    .hwdata(hwdata),
    .haddr(haddr),
    .prdata(prdata),

    .htrans(htrans),

    .hrdata(hrdata),
    .haddr1(haddr1),
    .haddr2(haddr2),
    .hwdata1(hwdata1),
    .hwdata2(hwdata2),

    .hwrite_reg(hwrite_reg),
    .hwrite_reg1(hwrite_reg1),
    .valid(valid),

    .temp_selx(temp_selx)

);

/////////////////////////////////////////////////
// Clock Generation
/////////////////////////////////////////////////

always #5 hclk = ~hclk;

/////////////////////////////////////////////////
// Stimulus
/////////////////////////////////////////////////

initial
begin

    hclk     = 0;
    hresetn  = 0;
    hwrite   = 0;
    hreadyin = 0;
    htrans   = 2'b00;
    haddr    = 32'd0;
    hwdata   = 32'd0;
    prdata   = 32'd0;

    /////////////////////////////////////////
    // RESET
    /////////////////////////////////////////

    #20;
    hresetn = 1;

    /////////////////////////////////////////
    // SINGLE WRITE
    /////////////////////////////////////////

    #10;

    hreadyin = 1'b1;
    hwrite   = 1'b1;
    htrans   = 2'b10;
    haddr    = 32'h8000_0004;
    hwdata   = 32'h1234_5678;

    #20;

    /////////////////////////////////////////
    // SINGLE READ
    /////////////////////////////////////////

    hwrite = 1'b0;
    htrans = 2'b10;
    haddr  = 32'h8400_0008;
    prdata = 32'hAAAA_5555;

    #20;

    /////////////////////////////////////////
    // BURST WRITE
    /////////////////////////////////////////

    hwrite = 1'b1;

    htrans = 2'b10;
    haddr  = 32'h8800_0000;
    hwdata = 32'h1111_1111;

    #10;

    htrans = 2'b11;
    haddr  = 32'h8800_0004;
    hwdata = 32'h2222_2222;

    #10;

    htrans = 2'b11;
    haddr  = 32'h8800_0008;
    hwdata = 32'h3333_3333;

    #10;

    htrans = 2'b11;
    haddr  = 32'h8800_000C;
    hwdata = 32'h4444_4444;

    #30;

    /////////////////////////////////////////
    // INVALID ADDRESS
    /////////////////////////////////////////

    hwrite = 1'b0;
    htrans = 2'b10;
    haddr  = 32'h7000_0000;

    #20;

    $stop;

end

endmodule
