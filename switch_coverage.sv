class switch_coverage extends uvm_subscriber #(transaction);

`uvm_component_utils(switch_coverage)
  mem_transaction trn;

covergroup switch_cg;

    length: coverpoint trn.length{
    bins short_0_127 = {[0:127]};
    bins long_128_255 = {[128:255]};
  }

    da: coverpoint trn.da{
    bins da_0 = {0};
    bins da_1 = {1};
    bins da_2 ={2};
    bins da_3 ={3};

  }

endgroup

function new(string name = "switch_coverage", uvm_component parent = null);
  super.new(name, parent);
  switch_cg = new();
endfunction

function void write(switch_packet_seq_item t);
      trn = t;
    switch_cg.sample();

    if (switch_cg.get_coverage() == 100) begin
      test_done =1;
      `uvm_info("COV", "--------------- 100\% -------------------", UVM_LOW)
    end
endfunction

endclass
