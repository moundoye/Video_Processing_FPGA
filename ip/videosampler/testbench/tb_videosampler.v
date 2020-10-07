`timescale 1ns/100ps
module tb_videosampler();

reg clk_proc;
reg reset_n;
reg pclk;
reg href;
reg vsync;
reg start;

reg [2:0] addr_rel_i;
reg wr_i;
reg [31:0] datawr_i;

reg [31:0] counter;

reg [7:0] data;
wire [7:0] out_data;
wire out_dv;

parameter IMAGE_COLS = 320;
parameter IMAGE_ROWS = 10;

integer fp_out;

task image_task;
input integer vsync_delay;
input integer hsync_delay;
input integer image_cols;
input integer image_rows;
integer i, j, delay;
begin
    $display("IMAGE STREAM GENERATOR");
    $display("VSYNC delay %d", vsync_delay);
    $display("HSYNC delay %d", hsync_delay);
    $display("Image size %d X %d", image_cols, image_rows);
    
    for (delay = 0; delay < vsync_delay; delay = delay + 1)
        @(posedge pclk);

    vsync = 1'b1;
    
    for (delay = 0; delay < hsync_delay; delay = delay + 1)
        @(posedge pclk);
        
    for (i = 0; i < image_rows; i = i + 1)
    begin
        href = 1'b1;
        
        for (j = 0; j < image_cols; j = j + 1)
            @(posedge pclk);
        
        href = 1'b0;
        
        for (delay = 0; delay < hsync_delay; delay = delay + 1)
            @(posedge pclk);
    end
    
    for (delay = 0; delay < vsync_delay; delay = delay + 1)
        @(posedge pclk);

    vsync = 1'b0;
    
    for (delay = 0; delay < 100; delay = delay + 1)
        @(posedge pclk);
end
endtask

initial begin
    $dumpfile("/tmp/tb_videosampler.vcd");
    $dumpvars;
    
    fp_out = $fopen("data_out.txt", "w");
    
    clk_proc = 0;
    addr_rel_i = 0;
    wr_i = 0;
    datawr_i = 0;
    start = 0;
    data = 0;
    pclk = 0;
    href = 0;
    vsync = 0;
    counter = 0;
    
    #1 reset_n = 1'd0;
    #4 reset_n = 1'd1;
    
    #18 start = 1;
    
    #150;
    
    #6 datawr_i = 1;
    #2 addr_rel_i = 0;
    #2 wr_i = 1;
    #2 wr_i = 0;
    

end

always #1 clk_proc = ~clk_proc;

always@(posedge clk_proc)
    if (counter % 3 == 0)
        pclk <= ~pclk;
        
always@(posedge pclk)
    data <= $random;

always@(posedge clk_proc)
    counter <= counter + 1;

always@(posedge clk_proc)
    if (out_dv)
        $fwrite(fp_out, "%d\n", out_data);
        
always@(posedge start)
begin
    image_task(23, 100, IMAGE_COLS, IMAGE_ROWS);
    image_task(23, 100, IMAGE_COLS, IMAGE_ROWS);
    image_task(23, 100, IMAGE_COLS, IMAGE_ROWS);
    image_task(23, 100, IMAGE_COLS, IMAGE_ROWS);
end


videosampler #(
    .DATA_WIDTH(32),
    .PIXEL_WIDTH(8),
    .FIFO_DEPTH(2048),
    .DEFAULT_SCR(0),
    .DEFAULT_FLOWLENGTH(IMAGE_COLS*IMAGE_ROWS)
) 
videosampler_inst
(
    .pclk_i(pclk),
    .href_i(href),
    .vsync_i(vsync),

    .pixel_i(data),

    .clk_i(clk_proc),
    .reset_n_i(reset_n),

    .out_data(out_data),
    .out_dv(out_dv),
    .out_sop(),
    .out_eop(),

    .addr_rel_i(addr_rel_i), 
    .wr_i(wr_i),
    .datawr_i(datawr_i),
    .rd_i(1'b0),
    .datard_o()
);


endmodule
