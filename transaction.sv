class transaction extends uvm_sequence_item;

`uvm_object_utils(transaction)

rand bit [7:0] da;
rand bit [7:0] sa;
rand bit [7:0] length;
rand bit [7:0] data[];
 bit [7:0] fcs;

constraint length_c {
  solve data.size before length;
  length == data.size;
}

constraint da_c {
  da >= 0;
  da <= 3;
}

function new(string name = "transaction");
  super.new(name);
endfunction: new


function void post_randomize();
  fcs = calculate_fcs();
endfunction

function byte calculate_fcs();
  return da ^ sa ^ length ^ data.xor();
endfunction: calculate_fcs

function string converttostring();
    string s;
    $sformat(s, "%s \n da: %d \n sa: %d \n len: %d \n data: %d \n fcs:%d \n" ,
    s, da, sa, length, data, fcs );
    return s;
endfunction

endclass


