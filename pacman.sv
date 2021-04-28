module pacman (input         MAX10_CLK1_50,
               input  [1:0]  KEY,
               input  [9:0]  SW,
               output [9:0]  LEDR,
               output [7:0]  HEX0,
               output [7:0]  HEX1,
               output [7:0]  HEX2,
               output [7:0]  HEX3,
               output [7:0]  HEX4,
               output [7:0]  HEX5,
               output        VGA_HS,
               output        VGA_VS,
               output [3:0]  VGA_R,
               output [3:0]  VGA_G,
               output [3:0]  VGA_B,
               output        DRAM_CLK,
               output        DRAM_CKE,
               output [12:0] DRAM_ADDR,
               output [1:0]  DRAM_BA,
               inout  [15:0] DRAM_DQ,
               output        DRAM_LDQM,
               output        DRAM_UDQM,
               output        DRAM_CS_N,
               output        DRAM_WE_N,
               output        DRAM_CAS_N,
               output        DRAM_RAS_N,
               inout  [15:0] ARDUINO_IO,
               inout         ARDUINO_RESET_N);

   logic         reset, blank, sync;
   logic [7:0]   pixel_red, pixel_green, pixel_blue;
   logic [9:0]   pixel_x, pixel_y;
   logic [31:0]  control;
   logic [31:0]  gpio_0_in, gpio_0_out;
   logic [31:0]  gpio_1_in, gpio_1_out;
   logic [31:0]  gpio_2_in, gpio_2_out;
   logic [31:0]  gpio_3_in, gpio_3_out;

   // Reset - active low
   assign reset = ~KEY[0];

   assign HEX5 = 8'b10001100;  // P
   assign HEX4 = 8'b10001000;  // A
   assign HEX3 = 8'b11000110;  // C
   assign HEX2 = 8'b10001100;  // P
   assign HEX1 = 8'b10001000;  // A
   assign HEX0 = 8'b11000110;  // C

   assign VGA_R = pixel_red[7:4];
   assign VGA_G = pixel_green[7:4];
   assign VGA_B = pixel_blue[7:4];

   /*
   hex_driver hex_driver5 (.in(sdram_pixel_address[23:20]), .out(HEX5));
   hex_driver hex_driver4 (.in(sdram_pixel_address[19:16]), .out(HEX4));
   hex_driver hex_driver3 (.in(sdram_pixel_address[15:12]), .out(HEX3));
   hex_driver hex_driver2 (.in(sdram_pixel_address[11:8]), .out(HEX2));
   hex_driver hex_driver1 (.in(sdram_pixel_address[7:4]), .out(HEX1));
   hex_driver hex_driver0 (.in(sdram_pixel_address[3:0]), .out(HEX0));
   */

   vga_controller vga_controller (
      .clk(MAX10_CLK1_50),
      .reset(reset),
      .hs(VGA_HS),
      .vs(VGA_VS),
      .blank(blank),
      .sync(sync),
      .draw_x(pixel_x),
      .draw_y(pixel_y));

   color_mapper color_mapper (
      .clk(MAX10_CLK1_50),
      .blank(blank),
      .x(pixel_x),
      .y(pixel_y),
      .control(control),
      .red(pixel_red),
      .green(pixel_green),
      .blue(pixel_blue));

   pacman_soc pacman_soc (
      .clk_clk(MAX10_CLK1_50),                                // clk.clk
      .reset_reset_n(1'b1),                                   // reset.reset_n
      // .altpll_0_locked_conduit_export    (),               // altpll_0_locked_conduit.export
      // .altpll_0_phasedone_conduit_export (),               // altpll_0_phasedone_conduit.export
      // .altpll_0_areset_conduit_export    (),               // altpll_0_areset_conduit.export
      // .key_external_connection_export    (KEY),            // key_external_connection.export

      // SDRAM
      .sdram_clk_clk(DRAM_CLK),                            // clk_sdram.clk
      .sdram_wire_addr(DRAM_ADDR),                         // sdram_wire.addr
      .sdram_wire_ba(DRAM_BA),                             // .ba
      .sdram_wire_cas_n(DRAM_CAS_N),                       // .cas_n
      .sdram_wire_cke(DRAM_CKE),                           // .cke
      .sdram_wire_cs_n(DRAM_CS_N),                         // .cs_n
      .sdram_wire_dq(DRAM_DQ),                             // .dq
      .sdram_wire_dqm({DRAM_UDQM, DRAM_LDQM}),             // .dqm
      .sdram_wire_ras_n(DRAM_RAS_N),                       // .ras_n
      .sdram_wire_we_n(DRAM_WE_N),                         // .we_n

      // USB SPI   
      .spi_SS_n(SPI0_CS_N),
      .spi_MOSI(SPI0_MOSI),
      .spi_MISO(SPI0_MISO),
      .spi_SCLK(SPI0_SCLK),

      // USB GPIO
      .usb_rst_export(USB_RST),
      .usb_irq_export(USB_IRQ),
      .usb_gpx_export(USB_GPX),

      // Control
      .control_export(control),

      // GPIOs
      .gpio_0_in_port(gpio_0_in),
      .gpio_0_out_port(gpio_0_out),
      .gpio_1_in_port(gpio_1_in),
      .gpio_1_out_port(gpio_1_out),
      .gpio_2_in_port(gpio_2_in),
      .gpio_2_out_port(gpio_2_out),
      .gpio_3_in_port(gpio_3_in),
      .gpio_3_out_port(gpio_3_out));

endmodule
