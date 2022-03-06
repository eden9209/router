package switch_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    bit test_done = 0;

    // Macros and configuration
    `include "switch_agent_config.sv"

    `include "transaction.sv"
    `include "switch_sequence.sv"
     typedef uvm_sequencer #(transaction) switch_sequencer;
    `include "switch_driver.sv"
    `include "switch_coverage.sv"
    `include "switch_agent_in.sv"

     `include "switch_monitor_out.sv"
     `include "switch_driver_out.sv"
     `include "switch_agent_out.sv"



    
  endpackage