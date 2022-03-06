module switch_tb;

import uvm_pkg::*;
`include "uvm_macros.svh"

import switch_test_pkg::*;

bit clock;

// Generate clock signal
initial begin
  forever #5 clock = ~clock;
end

// interface instantiation
virtual switch_input_if  input_intf(clock);
vitrual switch_output_if output_intf[4](clock);

switch DUT(.clk(clock),
           .reset(input_intf.reset),
           .data_valid(input_intf.data_status),
           .data(input_intf.data_in),
           .port0(output_intf[0].data_out),
           .port1(output_intf[1].data_out),
           .port2(output_intf[2].data_out),
           .port3(output_intf[3].data_out),
           .ready_0(output_intf[0].ready),
           .ready_1(output_intf[1].ready),
           .ready_2(output_intf[2].ready),
           .ready_3(output_intf[3].ready),
           .read_0(output_intf[0].read),
           .read_1(output_intf[1].read),
           .read_2(output_intf[2].read),
           .read_3(output_intf[3].read)
);

initial begin
  uvm_config_db # (virtual switch_input_if)::set(null, "uvm_test_top", "input_intf", input_intf);
  
  uvm_config_db # (virtual switch_output_if)::set(null, "uvm_test_top", "output_intf_0", output_intf[0]);
  uvm_config_db # (virtual switch_output_if)::set(null, "uvm_test_top", "output_intf_1", output_intf[1]);
  uvm_config_db # (virtual switch_output_if)::set(null, "uvm_test_top", "output_intf_2", output_intf[2]);
  uvm_config_db # (virtual switch_output_if)::set(null, "uvm_test_top", "output_intf_3", output_intf[3]); 

  run_test("switch_test");
end


endmodule: switch_tb

