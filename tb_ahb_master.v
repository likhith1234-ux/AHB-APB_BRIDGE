module tb_ahb_master;

reg         hclk;
reg         hresetn;
reg         hreadyout;
reg [31:0]  hrdata;

wire [31:0] haddr;
wire [31:0] hwdata;
wire        hwrite;
wire        hreadyin;
wire [1:0]  htrans;

ahb_master DUT(
    .hclk(hclk),
    .hresetn(hresetn),
    .hrdata(hrdata),
    .haddr(haddr),
    .hwdata(hwdata),
    .hwrite(hwrite),
    .hreadyin(hreadyin),
    .htrans(htrans)
);

always #5 hclk = ~hclk;

initial
begin
    hclk      = 0;
    hresetn   = 0;
    hreadyout = 1;
    hrdata    = 32'd0;

    #20;
    hresetn = 1;

    #500;
    $stop;
end

endmodule
