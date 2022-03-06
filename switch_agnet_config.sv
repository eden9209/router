class switch_agent_config extends uvm_object;

`uvm_object_utils(switch_agent_config)

    bit has_functional_coverage;
    bit active;
    virtual switch_input_if  input_intf;
    virtual switch_output_if output_intf[4];


    function new(string name = "agent_config", uvm_component parent);
        super.new(name, parent);
    endfunction

    
endclass