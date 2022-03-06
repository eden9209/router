class switch_driver extends uvm_driver # (transaction);

`uvm_component_utils(switch_driver)
virtual switch_input_if input_intf;

uvm_analysis_port #(transaction) drvr2sb_ap;


function new(string name = "switch_driver", uvm_component parent = null);
  super.new(name, parent);
endfunction: new


function void build_phase(uvm_phase phase);
  drvr2sb_ap = new("drvr2sb_ap", this);
 endfunction

task run_phase(uvm_phase phase);
  transaction req;
 

  forever begin
    seq_item_port.get_next_item(req);
    
    drvr2sb_ap.write(req);

    drive(req);

    seq_item_port.item_done();
  end
endtask

task drive(transaction req);

   foreach(trn.data[i]) begin
    @(posedge input_intf.clock);
    input_intf.data_status <= 1;
    input_intf.data_in <= trn.data[i];
  end
  
  // Reset all input signal to 0
  @(posedge input_intf.clock);
  input_intf.data_status <= 0;
  input_intf.data_in <= 0;

  // To ensure at least 2 clock cycles between packet transmission
  repeat(2)@(posedge input_intf.clock);

endtask

endclass
