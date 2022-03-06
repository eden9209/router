class switch_agent_in extends uvm_agent;
`uvm_component_utils(switch_agent_in)

switch_agent_config m_cfg;

uvm_analysis_port # (transaction) in_port2scb_port;

// Other components
switch_sequencer m_sequencer;
switch_driver m_driver;
switch_coverage m_coverage;

function new(string name = "switch_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction: new

function void build_phase(uvm_phase phase);
  in_port2scb_port = new("in_port2scb_port", this);

  if(!uvm_config_db # (switch_agent_config)::get(this, "", "switch_agent_config", m_cfg)) begin
    `uvm_error("build_phase", "Unable to find switch_agent_config in uvm_config_db")
  end
    // Based on is_active, build drivers, sequencer and scoreboard
  if(m_cfg.active == 1) begin
    m_sequencer = switch_sequencer::type_id::create("m_sequencer", this);
    m_driver = switch_driver::type_id::create("m_driver", this);
  end
  if(m_cfg.has_functional_coverage) begin
    m_coverage = switch_coverage::type_id::create("m_coverage", this);
  end  
endfunction

function void connect_phase(uvm_phase phase);
 
  if(m_cfg.active == UVM_ACTIVE) begin
    m_driver.input_intf = m_cfg.input_intf;
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  end

      m_driver.drvr2sb_ap.connect(in_port2scb_port);

    if(m_cfg.has_functional_coverage) begin
        m_driver.drvr2sb_ap.connect(m_coverage.analysis_export);
      end

           
endfunction

endclass


