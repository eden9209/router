class switch_agent_out extends uvm_agent;
 `uvm_component_utils(switch_agent_out)

    uvm_analysis_port # (transaction) ap;
    switch_monitor_out monitor_out;
    switch_driver_out driver_out;



function new(string name = "switch_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    ap = new("ap0", this);
    monitor_out = switch_monitor_out::type_id::create("monitor_out", this);
    driver_out = switch_driver_out::type_id::create("driver_out", this);
endfunction


function void connect_phase(uvm_phase phase);
monitor_out.m_ap.connect(ap);

endfunction


endclass
