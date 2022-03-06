class switch_scoreboard extends uvm_scoreboard;

`uvm_component_utils(switch_scoreboard)
`uvm_analysis_imp_decl(_rcvd_pkt_0)
`uvm_analysis_imp_decl(_sent_pkt)



uvm_analysis_imp_rcvd_pkt_0 # (transaction) sc_ap_0;
uvm_analysis_imp_sent_pkt # (transaction) drvr2sb_export;

// Queue for storing trans of write
transaction queuq_write_0[$];
transaction queuq_write_1[$];
transaction queuq_write_2[$];
transaction queuq_write_3[$];


function new(string name = "switch_scoreboard", uvm_component parent = null);
  super.new(name, parent);
endfunction

function build_phase(uvm_phase phase);
  sc_ap_0 = new("sc_ap_0", this);
  drvr2sb_export = new("drvr2sb_export", this);
endfunction

function void write__rcvd_pkt_0(transaction t);

  if(t == null) begin
    `uvm_error("write_rcvd_pkt", "Null object")
  end
  
  case(t.da)
    0:begin
           foreach(t.data_in[i])
           if(t.data_in[i] != queuq_write_0.pop_front())
           `uvm_error("switch_scoreboard", "__________error_________")
      end

    1:begin
           foreach(t.data_in[i])
           if(t.data_in[i] != queuq_write_1.pop_front())
           `uvm_error("switch_scoreboard", "__________error_________")
      end

    2:begin
            foreach(t.data_in[i])
           if(t.data_in[i] != queuq_write_2.pop_front())
           `uvm_error("switch_scoreboard", "__________error_________")
      end

    3:begin
           foreach(t.data_in[i])
           if(t.data_in[i] != queuq_write_3.pop_front())
           `uvm_error("switch_scoreboard", "__________error_________")
      end

   default: `uvm_info("switch_scoreboard", "__________error_________")
   endcase



  
  
endfunction


function void write_sent_pkt(transaction trn_in);
 // trn_in=t;
  if(trn_in == null) begin
    `uvm_error("write_rcvd_pkt", "Null object")
  end
   case(trn_in.da)
    0:begin
           foreach(trn_in.data_in[i])
           queuq_write_0.push_back(trn.in.data[i]);
      end

    1:begin
      foreach(trn_in.data_in[i])
      queuq_write_1.push_back(trn.in.data[i]);
      end

    2:begin
      foreach(trn_in.data_in[i])
      queuq_write_2.push_back(trn.in.data[i]);
      end

    3:begin
      foreach(trn_in.data_in[i])
      queuq_write_3.push_back(trn.in.data[i]);
      end

   default: `uvm_info("switch_scoreboard", "__________error_________", UVM_NONE)
   endcase
     
endfunction

endclass
