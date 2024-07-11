// ***************************************************************************
// ***************************************************************************
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system
  (
    // clock and reset
    input           clk,
    input           resetn,
    // leds
    output  [15:0]  leds,
    // slide switches
    input   [15:0]  slide_switches,
    // uart
    input           ftdi_tx,
    output          ftdi_rx,
    input           ftdi_rts,
    output          ftdi_cts
  );

  wire sys_clk;
  wire reset;

  wire  [31:0]  s_apb_paddr;
  wire  [0:0]   s_apb_psel;
  wire          s_apb_penable;
  wire          s_apb_pready;
  wire          s_apb_pwrite;
  wire  [31:0]  s_apb_pwdata;
  wire  [31:0]  s_apb_prdata;
  wire          s_apb_pslverror;

  assign ftdi_cts = ftdi_rts;
  
  clk_wiz_1 inst_clk_wiz_1 (
    .clk_out1(sys_clk),
    .resetn(resetn),
    .clk_in1(clk)
  );

  sys_rstgen inst_sys_rstgen (
    .slowest_sync_clk(sys_clk),
    .ext_reset_in(resetn),
    .aux_reset_in(1'b1),
    .mb_debug_sys_rst(1'b0),
    .dcm_locked(1'b1),
    .mb_reset(),
    .bus_struct_reset(),
    .peripheral_reset(reset),
    .interconnect_aresetn(),
    .peripheral_aresetn()
  );

  apb_rom  #(
    .ADDRESS_WIDTH(32),
    .BUS_WIDTH(4)
  ) inst_apb_rom (
    //clk reset
    .clk(sys_clk),
    .rst(reset),
    //APB3(
    .s_apb_paddr(s_apb_paddr),
    .s_apb_psel(s_apb_psel),
    .s_apb_penable(s_apb_penable),
    .s_apb_pready(s_apb_pready),
    .s_apb_pwrite(s_apb_pwrite),
    .s_apb_pwdata(s_apb_pwdata),
    .s_apb_prdata(s_apb_prdata),
    .s_apb_pslverror(s_apb_pslverror)
  );

  Murax inst_murax (
    .io_asyncReset(reset),
    .io_mainClk(sys_clk),
    .io_gpioA_read(slide_switches),
    .io_gpioA_write(leds),
    .io_gpioA_writeEnable(),
    .io_uart_txd(ftdi_rx),
    .io_uart_rxd(ftdi_tx),
    .io_m_apb_PADDR(s_apb_paddr),
    .io_m_apb_PSEL(s_apb_psel),
    .io_m_apb_PENABLE(s_apb_penable),
    .io_m_apb_PREADY(s_apb_pready),
    .io_m_apb_PWRITE(s_apb_pwrite),
    .io_m_apb_PWDATA(s_apb_pwdata),
    .io_m_apb_PRDATA(s_apb_prdata),
    .io_m_apb_PSLVERROR(s_apb_pslverror)
  );

endmodule
