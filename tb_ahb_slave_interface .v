module tb_ahb_slave_interface;

reg         hclk;
reg         hresetn;
reg         hwrite;
reg         hreadyin;
reg  [1:0]  htrans;
reg  [31:0] haddr;
reg  [31:0] hwdata;
reg  [31:0] prdata;

wire        valid;
wire        hwrite_reg;
wire [2:0]  temp_selx;
wire [31:0] haddr_1;
wire [31:0] haddr_2;
wire [31:0] hwdata_1;
wire [31:0] hrdata;

/////////////////////////////////////////////////
// DUT
/////////////////////////////////////////////////

AHB_Slave_Interface DUT(
    .hclk(hclk),
    .hresetn(hresetn),
    .hwrite(hwrite),
    .hreadyin(hreadyin),
    .htrans(htrans),
    .haddr(haddr),
    .hwdata(hwdata),
    .prdata(prdata),

    .valid(valid),
    .hwrite_reg(hwrite_reg),
    .temp_selx(temp_selx),
    .haddr_1(haddr_1),
    .haddr_2(haddr_2),
    .hwdata_1(hwdata_1),
    .hrdata(hrdata)
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

    hclk      = 0;
    hresetn   = 0;
    hwrite    = 0;
    hreadyin  = 0;
    htrans    = 2'b00;
    haddr     = 32'd0;
    hwdata    = 32'd0;
    prdata    = 32'd0;

    #20;
    hresetn = 1;

    /////////////////////////////////////
    // WRITE TRANSFER
    /////////////////////////////////////

    #10;
    hwrite   = 1'b1;
    hreadyin = 1'b1;
    htrans   = 2'b10;
    haddr    = 32'h8000_0004;
    hwdata   = 32'h1234_5678;

    #20;

    /////////////////////////////////////
    // READ TRANSFER
    /////////////////////////////////////

    hwrite   = 1'b0;
    htrans   = 2'b10;
    haddr    = 32'h8400_0008;
    prdata   = 32'hAAAA_5555;

    #20;

    /////////////////////////////////////
    // ANOTHER WRITE
    /////////////////////////////////////

    hwrite   = 1'b1;
    htrans   = 2'b10;
    haddr    = 32'h8800_000C;
    hwdata   = 32'hDEAD_BEEF;

    #50;

    $stop;

end

endmodule
