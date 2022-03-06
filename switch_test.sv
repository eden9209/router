class switch_test extends uvm_test;  
    
 `uvm_component_utils(switch_test);


    
    switch_agent_config ag_cfg;
    switch_sequence seq ;
    switch_env env ;

    function void build_phase(uvm_phase phase);

       ag_cfg=switch_agent_config::type_id::create("ag_cfg",this);
       seq=switch_sequence::type_id::create("seq",this);
       env=switch_env::type_id::create("env",this);

        // _______________Get________________
       if(!uvm_config_db#(virtual switch_input_if)::get(this,"","input_intf",ag_cfg.input_intf))
          `uvm_error("mem_basic_test", "interface not pass to agent config interface member")
     

        // _______________Get________________
         if(!uvm_config_db # (virtual switch_output_if)::get(this, "", "output_intf_0", ag_cfg.output_intf[0])) begin
            `uvm_error("build_phase", "Unable to find input_intf in uvm_config_db")
               end
           if(!uvm_config_db # (virtual switch_output_if)::get(this, "", "output_intf_1", ag_cfg.output_intf[1])) begin
              `uvm_error("build_phase", "Unable to find input_intf in uvm_config_db")
             end
          if(!uvm_config_db # (virtual switch_output_if)::get(this, "", "output_intf_2", ag_cfg.output_intf[2])) begin
            `uvm_error("build_phase", "Unable to find input_intf in uvm_config_db")
             end
          if(!uvm_config_db # (virtual switch_output_if)::get(this, "", "output_intf_3", ag_cfg.output_intf[3])) begin
           `uvm_error("build_phase", "Unable to find input_intf in uvm_config_db")
             end

          ag_cfg.has_functional_coverage = 1;
          ag_cfg.active = 1;


       //_____________set______________________
       uvm_config_db#(switch_agent_config)::set(null,"*","switch_agent_config",ag_cfg);
    
    endfunction
   
   

   function new(string name = "switch_basic_test", uvm_component parent);
       super.new(name, parent);
   endfunction

   task run_phase(uvm_phase phase);
       phase.raise_objection(this, "----------------------TEST STAETED----------------------");
       seq.start(env.agent.seq);
       phase.drop_objection(this, "----------------------TEST STAETED----------------------");
   endtask: run_phase
   

   
endclass