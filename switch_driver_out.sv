class switch_driver_out extends uvm_component;

    `uvm_component_utils(switch_monitor_out)
      virtual switch_output_if output_intf ;
    
    
    function new(string name = "switch_receiver", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
    
      endfunction
    
    task run_phase(uvm_phase phase);
        output_intf.read=1;
    endtask   
      
    
    endclass
    
    