module executer();

  task execute;
    input [64:0] opcode;
    input [5:0] rd;
    input [5:0] rs1;
    input [5:0] rs2;
    input signed [20:0] immediate;
   // output [4*8:0] name;
    begin
    
    $display ("%0s,%0x,%0x,%0x, %0x",opcode,rd,rs1,rs2, immediate);
   
    end
 
 
  endtask;
endmodule

