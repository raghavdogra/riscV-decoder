module executer();
getreg gr_name();
logic signed [63:0] gpr [31:0];
  task execute;
    input [64:0] opcode;
    input [5:0] rd;
    input [5:0] rs1;
    input [5:0] rs2;
    input signed [19:0] immediate;
    input [64:0] pc;
    logic [63:0] abs;
    logic [63:0] abs1;
    logic signed [64:0] temp;
    logic [63:0] temp1;

    logic bt;
    int x;
    logic [32:0] name;
   // output [4*8:0] name;
    begin
     gpr[0] = 0; 
    //  gpr[rd] = immediate;
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
                "sltiu": begin
			getAbs(gpr[rs1],abs);
			getAbs(immediate,abs1);
                        if (abs < abs1)
                                gpr[rd] = 1;
                        else
                                gpr[rd] = 0;
                        end

                "slt": begin
                        if (gpr[rs1] < gpr[rs2])
                                gpr[rd] = 1;
                        else
                                gpr[rd] = 0;
                        end
                "sltu": begin
                        getAbs(gpr[rs1],abs);
                        getAbs(gpr[rs2],abs1);
                        if (abs < abs1)
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
			x = immediate[4:0];
                        temp = temp >> immediate[4:0];
                        for (int i=64; i > (64-x); i--) begin
                       			 temp[i] = bt;
                       	 	end
                        gpr[rd] = temp;
			end
               "sll": begin
                        gpr[rd] = gpr[rs1] << gpr[rs2];
                        end
                "srl": begin
                        gpr[rd] = gpr[rs1] >> gpr[rs2];
                        end
                "sra": begin
                        temp = gpr[rs1];
                        bt = temp[64];
			x = gpr[rs2];
			temp1 = gpr[rs2];
                        temp = temp >> temp1[4:0];
                        for (int i=64; i > (64-x); i--) begin
                                        temp[i] = bt;
                                end
                        gpr[rd] = temp;
                        end
                "sllw": begin
                        gpr[rd] = gpr[rs1] << gpr[rs2];
                        end
                "srlw": begin
                        gpr[rd] = gpr[rs1] >> gpr[rs2];
                        end
                "sraw": begin
                        temp = gpr[rs1];
                        bt = temp[64];
			x = gpr[rs2];
			temp1 = gpr[rs2];
                        temp = temp >> temp1[4:0];
                        for (int i=64; i > (64-x); i--) begin
                                         temp[i] = bt;
                                end
                        gpr[rd] = temp;
                        end
		"rem":  begin
                        gpr[rd] = gpr[rs1] % gpr[rs2];
                        end
                "remu": begin
                        getAbs(gpr[rs1], abs);
                        getAbs(gpr[rs2], abs1);
                        gpr[rd] = abs % abs1;
                        end
                "remw":  begin
                        gpr[rd] = gpr[rs1] % gpr[rs2];
                        end
                "remuw": begin
                        getAbs(gpr[rs1], abs);
                        getAbs(gpr[rs2], abs1);
                        gpr[rd] = abs / abs1;
                        end
                "div":  begin
                        gpr[rd] = gpr[rs1] / gpr[rs2];
                        end
                "divu": begin
                        getAbs(gpr[rs1], abs);
                        getAbs(gpr[rs2], abs1);
                        gpr[rd] = abs / abs1;
                        end
                "divw":  begin
                        gpr[rd] = gpr[rs1] / gpr[rs2];
                        end
                "divuw": begin
                        getAbs(gpr[rs1], abs);
                        getAbs(gpr[rs2], abs1);
                        gpr[rd] = abs / abs1;
                        end
		"mul":	 gpr[rd] = gpr[rs1] * gpr[rs2];
		"mulw":  gpr[rd] = gpr[rs1] * gpr[rs2];

		"mulh": begin
			temp = gpr[rs1] * gpr[rs2];
			gpr[rd] = temp[63:32];
			end
		"mulhsu":begin
                         getAbs(gpr[rs2], abs1);
                         temp = gpr[rs1] * abs1;
                         gpr[rd] = temp[63:32];
			end
		"mulhu": begin
			 getAbs(gpr[rs1], abs);
                         getAbs(gpr[rs2], abs1);
			 temp = abs * abs1;
			 gpr[rd] = temp[63:32];
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
	gr_name.convert(rd,name);
//        $display ("%0s\t%0s\t => %0d",opcode,name,gpr[rd]);

 
  endtask;

 task printRegister;
logic [32:0] name;
 //    gpr[rd] = immediate;
       for (int i=0; i<=31; i++) begin
        gr_name.convert(i,name);
	$display ("%0s	%x	%0d",name,gpr[i],gpr[i]);
       end
  endtask;

task getAbs;
	input [63:0] signd;
	output [63:0] abs;

	if(signd[63] == 1) 
		abs = -signd;
	else if(signd[63] == 0)
		abs = signd;
endtask;

endmodule

