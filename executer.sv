module executer();
logic signed [63:0] gpr [31:0];
  task execute;
    logic signed [64:0] temp;
    input [64:0] opcode;
    input [5:0] rd;
    input [5:0] rs1;
    input [5:0] rs2;
    input [64:0] pc;
    input signed [19:0] immediate;
   // output [4*8:0] name;
    begin
    
      gpr[rd] = immediate;
	case(opcode)
		"add": begin
			$display("add instruction");
			end
		"mv": begin
			$display("mv instruction");
			end
		"addi": begin
			$display("addi instruction");
			end
  		"lui": begin
			gpr[rd] = {immediate,3'h0000};
                        end
		"auipc": begin
			temp = {immediate,3'h000};
                        gpr[rd] = pc + temp;
                        end
 		"jal": begin 
			temp = pc + immediate + 4;
                        gpr[rd] = temp;
			end
		"jalr": begin
			temp = gpr[rs1] + immediate;
			temp[0] = 0;
 			gpr[rd] = temp + 4;
                	end
//		default: begin
//			$display("not add or mv");
//		end
	endcase

   //    for (int i=0; i<=31; i++) begin
     //   $display ("%0d",gpr[i] );
     //  end 
    //  $display ("%0s,%0x,%0x,%0x, %0d",opcode,rd,rs1,rs2, immediate);
   
    end
 
 
  endtask;

 task printRegister;
 //    gpr[rd] = immediate;
       for (int i=0; i<=31; i++) begin
        $display ("%0d",gpr[i] );
       end
  endtask;

endmodule

