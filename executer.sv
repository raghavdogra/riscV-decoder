module executer();
logic signed [63:0] gpr [31:0];
  task execute;
    logic signed [64:0] temp;
    logic bt;
    int x;
    input [64:0] opcode;
    input [5:0] rd;
    input [5:0] rs1;
    input [5:0] rs2;
    input signed [19:0] immediate;
    input [64:0] pc;
   // output [4*8:0] name;
    begin
    
      gpr[rd] = immediate;
	case(opcode)
		"add": begin
			gpr[rd] = gpr[rs1] + gpr[rs2];
			end
		"addw": begin
			gpr[rd] = gpr[rs1] + gpr[rs2];
			end
		"xor": begin
			gpr[rd] = gpr[rs1] ^ gpr[rs2];
			end
		"or": begin
			gpr[rd] = gpr[rs1] | gpr[rs2];
			end
		"and": begin
			gpr[rd] = gpr[rs1] & gpr[rs2];
			end
		"addi": begin
			gpr[rd] = gpr[rs1] + immediate;
			end
		"addiw": begin
			gpr[rd] = gpr[rs1] + immediate;
			end
		"sub": begin
			gpr[rd] = gpr[rs1] - gpr[rs2];
			end
		"subw": begin
			gpr[rd] = gpr[rs1] - gpr[rs2];
			end
		"slti": begin
			if (gpr[rs1] < immediate)
				gpr[rd] = 1;
			else
				gpr[rd] = 0;
			end
		"andi": begin
			gpr[rd] = gpr[rs1] & immediate;
			end
		"xori": begin
			gpr[rd] = gpr[rs1] ^ immediate;
			end
		"ori": begin
			gpr[rd] = gpr[rs1] | immediate;
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
		"slli": begin
			gpr[rd] = gpr[rs1] << immediate[4:0];
			end
		"srli": begin
			gpr[rd] = gpr[rs1] >> immediate[4:0];
			end
		"srai": begin
			temp = gpr[rs1];
			bt = temp[64];
			temp = temp >> immediate[4:0];
 			for (int i=64; i > (64-x); i--) begin
					temp[i] = bt;
				end
			gpr[rd] = temp;
			end
		"slliw": begin
                        gpr[rd] = gpr[rs1] << immediate[4:0];
                        end
                "srliw": begin
                        gpr[rd] = gpr[rs1] >> immediate[4:0];
                        end
                "sraiw": begin
                        temp = gpr[rs1];
                        bt = temp[64];
                        temp = temp >> immediate[4:0];
                        for (int i=64; i > (64-x); i--) begin
                       			 temp[i] = bt;
                       	 	end
                        gpr[rd] = temp;
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

