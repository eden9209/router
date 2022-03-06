class switch_env extends uvm_env;

`uvm_component_utils(switch_env)

switch_agent_in agent_in;
switch_agent_out agent_out[3];
switch_scoreboard scb;
switch_agent_config m_cfg;


function switch_env::new(string name = "switch_env", uvm_component parent = null);
  super.new(name, parent);
endfunction: new


function void build_phase(uvm_phase phase);

  if(!uvm_config_db # (switch_agent_config)::get(this, "", "switch_agent_config", m_cfg)) begin
    `uvm_error("build_phase", "Unable to find switch_agent_config in uvm_config_db")
  end

    agent_in = switch_agent_in::type_id::create("agent_in", this);
    foreach(agent_out[i])
    agent_out[i]=switch_agent_out::type_id::create($sformatf("agent_out_%0d",i), this);
    scb=switch_scoreboard::type_id::create("scb",this);

endfunction

function void connect_phase(uvm_phase phase);
    agent_in.in_port2scb_port.connect(scb.drvr2sb_export);

    
    foreach(agent_out[i])
    agent_out[i].ap.connect(sc_ap_0);

    agent_out[i].monitor_out.output_intf=m_cfg.output_intf[i];
    agent_out[i].driver_out.output_intf=m_cfg.output_intf[i];




   
endfunction

endclass
