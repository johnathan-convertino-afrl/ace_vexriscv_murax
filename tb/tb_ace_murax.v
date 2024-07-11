//******************************************************************************
/// @file    tb_axis.v
/// @author  JAY CONVERTINO
/// @date    2022.10.24
/// @brief   Generic AXIS test bench top with verification.
/// @details This generic top and mod axis test bench is created for a FIFO.
///          It will have to be altered for other devices that alter the input
///          for some sort of output.
///
/// @LICENSE MIT
///  Copyright 2022 Jay Convertino
///
///  Permission is hereby granted, free of charge, to any person obtaining a copy
///  of this software and associated documentation files (the "Software"), to 
///  deal in the Software without restriction, including without limitation the
///  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
///  sell copies of the Software, and to permit persons to whom the Software is 
///  furnished to do so, subject to the following conditions:
///
///  The above copyright notice and this permission notice shall be included in 
///  all copies or substantial portions of the Software.
///
///  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
///  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
///  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
///  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
///  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
///  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
///  IN THE SOFTWARE.
//******************************************************************************

`timescale 1 ns/10 ps

module tb_ace_murax ();
  
  wire  tb_dut_clk;
  wire  tb_dut_rst;
  wire  tb_dut_rstn;

  wire  tb_tms;
  wire  tb_tck;
  wire  tb_tdi;
  wire  tb_tdo;

  wire [31:0] gpio_write;

  reg [31:0] gpio_read;
  reg [31:0] prev_gpio_write;

  integer return_value0 = 0;
  
  // fst dump command
  initial begin
    $dumpfile ("tb_ace_murax.fst");
    $dumpvars (0, tb_ace_murax);

    $setup_tcp_server("127.0.0.1", 4422);
    #1;
  end
  
  clk_stimulus #(
    .CLOCKS(1), // # of clocks
    .CLOCK_BASE(100000000), // clock time base mhz
    .CLOCK_INC(10), // clock time diff mhz
    .RESETS(1), // # of resets
    .RESET_BASE(20), // time to stay in reset
    .RESET_INC(100) // time diff for other resets
  ) clk_stim (
    //clk out ... maybe a vector of clks with diff speeds.
    .clkv(tb_dut_clk),
    //rstn out ... maybe a vector of rsts with different off times
    .rstnv(tb_dut_rstn),
    .rstv(tb_dut_rst)
  );

  jtag_vpi #(
    .DEBUG_INFO(0),
    .TP(1),
    .TCK_HALF_PERIOD(50), // Clock half period (Clock period = 100 ns => 10 MHz)
    .CMD_DELAY(1000)
  ) inst_jtag_vpi (
    .tms(tb_tms),
    .tck(tb_tck),
    .tdi(tb_tdi),
    .tdo(tb_tdo),
    .enable(tb_dut_rstn),
    .init_done(tb_dut_rstn)
  );

  Murax isnt_Murax (
    .io_asyncReset(tb_dut_rst),
    .io_mainClk(tb_dut_clk),
    .io_jtag_tms(tb_tms),
    .io_jtag_tdi(tb_tdi),
    .io_jtag_tdo(tb_tdo),
    .io_jtag_tck(tb_tck),
    .io_gpioA_read(gpio_read),
    .io_gpioA_write(gpio_write),
    .io_gpioA_writeEnable(),
    .io_uart_txd(),
    .io_uart_rxd(1'b1)
  );

  always @(posedge tb_dut_clk)
  begin
    if(tb_dut_rst)
    begin
      prev_gpio_write = 0;
      gpio_read = 0;
    end else begin
      if(gpio_write != prev_gpio_write)
      begin
        return_value0 = $send_tcp_server(4422, gpio_write);
      end

      return_value0 = $recv_tcp_server(4422, gpio_read);

      prev_gpio_write = gpio_write;
    end
  end

endmodule

