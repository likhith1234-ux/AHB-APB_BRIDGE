module tb_apb_controller;

/////////////////////////////////////////////////
// Inputs
/////////////////////////////////////////////////

reg         hclk;
reg         hresetn;
reg         hwrite;
reg         hwrite_reg;
reg         valid;

reg [31:0]  haddr;
reg [31:0]  haddr1;
reg [31:0]  haddr2;

reg [31:0]  hwdata;
reg [31:0]  hwdata1;
reg [31:0]  hwdata2;

reg [31:0]  prdata;

reg [2:0]   tempselx;

/////////////////////////////////////////////////
// Outputs
/////////////////////////////////////////////////

wire        pwrite;
wire        penable;
wire        hr_readyout;

wire [2:0]  psel;

wire [31:0] paddr;
wire [31:0] pwdata;

/////////////////////////////////////////////////
// DUT
/////////////////////////////////////////////////

apb_controller DUT(

    .hclk(hclk),
    .hresetn(hresetn),
    .hwrite(hwrite),
    .hwrite_reg(hwrite_reg),
    .valid(valid),

    .haddr(haddr),
    .haddr1(haddr1),
    .haddr2(haddr2),

    .hwdata(hwdata),
    .hwdata1(hwdata1),
    .hwdata2(hwdata2),

    .prdata(prdata),

    .tempselx(tempselx),

    .pwrite(pwrite),
    .penable(penable),
    .hr_readyout(hr_readyout),

    .psel(psel),
    .paddr(paddr),
    .pwdata(pwdata)

);

/////////////////////////////////////////////////
// Clock
/////////////////////////////////////////////////

always #5 hclk = ~hclk;

/////////////////////////////////////////////////
// Stimulus
/////////////////////////////////////////////////

initial
begin

    hclk       = 0;
    hresetn    = 0;

    hwrite     = 0;
    hwrite_reg = 0;
    valid      = 0;

    haddr      = 32'd0;
    haddr1     = 32'd0;
    haddr2     = 32'd0;

    hwdata     = 32'd0;
    hwdata1    = 32'd0;
    hwdata2    = 32'd0;

    prdata     = 32'd0;

    tempselx   = 3'b000;

    /////////////////////////////////////////
    // RESET
    /////////////////////////////////////////

    #20;
    hresetn = 1;

    /////////////////////////////////////////
    // SINGLE READ
    /////////////////////////////////////////

    #10;

    valid      = 1;
    hwrite     = 0;
    hwrite_reg = 0;

    haddr       = 32'h8000_0004;
    haddr1      = 32'h8000_0004;
    haddr2      = 32'h8000_0000;

    tempselx    = 3'b001;

    #30;

    /////////////////////////////////////////
    // SINGLE WRITE
    /////////////////////////////////////////

    valid       = 1;
    hwrite      = 1;
    hwrite_reg  = 1;

    haddr1      = 32'h8400_0000;
    hwdata      = 32'h1234_5678;
    hwdata1     = 32'h1234_5678;

    tempselx    = 3'b010;

    #40;

    /////////////////////////////////////////
    // BURST WRITE
    /////////////////////////////////////////

    valid       = 1;
    hwrite      = 1;
    hwrite_reg  = 1;

    haddr1      = 32'h8800_0000;
    hwdata      = 32'h1111_1111;
    hwdata1     = 32'h1111_1111;
    tempselx    = 3'b100;

    #10;

    haddr1      = 32'h8800_0004;
    hwdata      = 32'h2222_2222;

    #10;

    haddr1      = 32'h8800_0008;
    hwdata      = 32'h3333_3333;

    #10;

    haddr1      = 32'h8800_000C;
    hwdata      = 32'h4444_4444;

    #40;

    /////////////////////////////////////////
    // IDLE
    /////////////////////////////////////////

    valid       = 0;
    hwrite      = 0;
    hwrite_reg  = 0;
    tempselx    = 3'b000;

    #30;

    $stop;

end

endmodule
