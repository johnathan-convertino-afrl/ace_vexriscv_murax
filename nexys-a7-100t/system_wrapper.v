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

//   native_ddr_ctrl u_native_ddr_ctrl (
//
//   // Memory interface ports
//   .ddr2_addr                      (ddr2_addr),  // output [12:0]                       ddr2_addr
//   .ddr2_ba                        (ddr2_ba),  // output [2:0]                      ddr2_ba
//   .ddr2_cas_n                     (ddr2_cas_n),  // output                                       ddr2_cas_n
//   .ddr2_ck_n                      (ddr2_ck_n),  // output [0:0]                        ddr2_ck_n
//   .ddr2_ck_p                      (ddr2_ck_p),  // output [0:0]                        ddr2_ck_p
//   .ddr2_cke                       (ddr2_cke),  // output [0:0]                       ddr2_cke
//   .ddr2_ras_n                     (ddr2_ras_n),  // output                                       ddr2_ras_n
//   .ddr2_we_n                      (ddr2_we_n),  // output                                       ddr2_we_n
//   .ddr2_dq                        (ddr2_dq),  // inout [15:0]                         ddr2_dq
//   .ddr2_dqs_n                     (ddr2_dqs_n),  // inout [1:0]                        ddr2_dqs_n
//   .ddr2_dqs_p                     (ddr2_dqs_p),  // inout [1:0]                        ddr2_dqs_p
//   .init_calib_complete            (init_calib_complete),  // output                                       init_calib_complete
//
// .ddr2_cs_n                      (ddr2_cs_n),  // output [0:0]           ddr2_cs_n
//   .ddr2_dm                        (ddr2_dm),  // output [1:0]                        ddr2_dm
//   .ddr2_odt                       (ddr2_odt),  // output [0:0]                       ddr2_odt
//   // Application interface ports
//   .app_addr                       (app_addr),  // input [26:0]                       app_addr
//   .app_cmd                        (app_cmd),  // input [2:0]                                  app_cmd
//   .app_en                         (app_en),  // input                                        app_en
//   .app_wdf_data                   (app_wdf_data),  // input [63:0]    app_wdf_data
//   .app_wdf_end                    (app_wdf_end),  // input                                        app_wdf_end
//   .app_wdf_wren                   (app_wdf_wren),  // input                                        app_wdf_wren
//   .app_rd_data                    (app_rd_data),  // output [63:0]   app_rd_data
//   .app_rd_data_end                (app_rd_data_end),  // output                                       app_rd_data_end
//   .app_rd_data_valid              (app_rd_data_valid),  // output                                       app_rd_data_valid
//   .app_rdy                        (app_rdy),  // output                                       app_rdy
//   .app_wdf_rdy                    (app_wdf_rdy),  // output                                       app_wdf_rdy
//   .app_sr_req                     (app_sr_req),  // input                                        app_sr_req
//   .app_ref_req                    (app_ref_req),  // input                                        app_ref_req
//   .app_zq_req                     (app_zq_req),  // input                                        app_zq_req
//   .app_sr_active                  (app_sr_active),  // output                                       app_sr_active
//   .app_ref_ack                    (app_ref_ack),  // output                                       app_ref_ack
//   .app_zq_ack                     (app_zq_ack),  // output                                       app_zq_ack
//   .ui_clk                         (ui_clk),  // output                                       ui_clk
//   .ui_clk_sync_rst                (ui_clk_sync_rst),  // output                                       ui_clk_sync_rst
//
//   .app_wdf_mask                   (app_wdf_mask),  // input [7:0]  app_wdf_mask
//
//   // System Clock Ports
//   .sys_clk_i                       (sys_clk_i),
//   .sys_rst                        (sys_rst) // input  sys_rst
//   );

  // module Murax (
  // input  wire          io_asyncReset,
  // input  wire          io_mainClk,
  // input  wire [31:0]   io_gpioA_read,
  // output wire [31:0]   io_gpioA_write,
  // output wire [31:0]   io_gpioA_writeEnable,
  // output wire          io_uart_txd,
  // input  wire          io_uart_rxd,
  // output wire [31:0]   io_m_apb_PADDR,
  // output wire [0:0]    io_m_apb_PSEL,
  // output wire          io_m_apb_PENABLE,
  // input  wire          io_m_apb_PREADY,
  // output wire          io_m_apb_PWRITE,
  // output wire [31:0]   io_m_apb_PWDATA,
  // input  wire [31:0]   io_m_apb_PRDATA,
  // input  wire          io_m_apb_PSLVERROR

endmodule
