class switch_monitor_out extends uvm_component;

`uvm_component_utils(switch_monitor_out)
  virtual switch_output_if output_intf ;
  uvm_analysis_port # (transaction) m_ap;
  logic [7:0] index;


function new(string name = "switch_receiver", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  m_ap = new("m_ap", this);

  endfunction

task run_phase(uvm_phase phase);
  transaction tx;
  forever begin
    index=0;
  wait(output_intf.ready);
  @(posedge output_intf.clock);
  @(posedge output_intf.clock);
  tx = transaction::type_id::create("tx", this);
  tx.da=output_intf.data_out;
  @(posedge output_intf.clock);
  tx.sa=output_intf.data_out;
  @(posedge output_intf.clock);
  tx.length=output_intf.data_out;
  tx.data=new[tx.length];
  @(posedge output_intf.clock);
   repeat(tx.length) begin
     tx.data[index]=output_intf.data_out;
     index++;
     @(posedge output_intf.clock);
   end

   tx.fcs=output_intf.data_out;
  m_ap.write(tx);

  @(posedge output_intf.clock);
  end
endtask

  

endclass

