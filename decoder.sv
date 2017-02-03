`include "getreg.sv"
module decoder();
getreg gr_name();

task decode;
input [31:0] lower;
input [63:0] pc;
logic [2:0] data_index;
logic [32:0] rd,rs1,rs2;
logic [64:0] opcode;
begin
         if (lower[6:0] == 7'b0110011) begin
                gr_name.convert(lower[11:7],rd);
                gr_name.convert(lower[19:15],rs1);
                gr_name.convert(lower[24:20],rs2);
                case({lower[30], lower[14:12]})
                        4'b0000: opcode = "add";
                        4'b1000: opcode = "sub";
                        4'b0001: opcode = "sll";
                        4'b0010: opcode = "slt";
                        4'b0110: opcode = "sltu";
                        4'b0100: opcode = "xor";
                        4'b1101: opcode = "sra";
                        4'b0000: opcode = "or";
                        4'b0000: opcode = "and";
                endcase
                $display ("%x:  %x              %s      %s,%s,%s", pc, lower,opcode,rd,rs1,rs2);
        end else if (lower[6:0] == 7'b0010011) begin
                gr_name.convert(lower[11:7],rd);
                gr_name.convert(lower[19:15],rs1);
                case(lower[14:12])
                        3'b000: opcode = "addi";
                        3'b010: opcode = "slti";
                        3'b011: opcode = "sltiu";
                        3'b100: opcode = "xori";
                        3'b110: opcode = "ori";
                        3'b111: opcode = "andi";
                endcase
                $display ("%x:  %x              %s      %s,%s,%d", pc , lower,opcode,rd,rs1,lower[31:20]);
                case({lower[30], lower[14:12]})
                        4'b0001: opcode = "slli";
                        4'b0101: opcode = "srli";
                        4'b1101: opcode = "srai";
                endcase
        end else if (lower[6:0] == 7'b1110011) begin
                gr_name.convert(lower[11:7],rd);
                gr_name.convert(lower[19:15],rs1);
                case (lower[14:12])
                        3'b001: $display("%x:	%x		csrrw         %s,%s",pc,lower,rd,rs1 );
                        3'b010: $display("%x:	%x		csrrs         %s,%s",pc,lower,rd,rs1);
                        3'b011: $display("%x:	%x		csrrc         %s,%s",pc,lower,rd,rs1);
                        3'b101: $display("%x:	%x		csrrwi        %s,%d",pc,lower,rd,lower[14:12]);
                        3'b110: $display("%x:	%x		csrrsi        %s,%d",pc,lower,rd,lower[14:12]);
                        3'b111: $display("%x:	%x		csrrci        %s,%d",pc,lower,rd,lower[14:12]);
                endcase
        end else if (lower[6:0] == 7'b0000011) begin
                gr_name.convert(lower[11:7],rd);
                gr_name.convert(lower[19:15],rs1);
                case (lower[14:12])
                        3'b000: opcode = "lb";
                        3'b001: opcode = "lh";
                        3'b010: opcode = "lw";
                        3'b100: opcode = "lbu";
                        3'b101: opcode = "lhu";
                endcase
                $display("%x:	%x		%s            %s,%s,%d",pc,lower,opcode,rd,rs1,lower[31:20]);
        end else if (lower[6:0] == 7'b1100011) begin
                gr_name.convert(lower[24:20],rs2);
                gr_name.convert(lower[19:15],rs1);
                
                case (lower[14:12])
                        3'b000: opcode = "beq";
                        3'b001: opcode = "bne";
                        3'b100: opcode = "blt";
                        3'b101: opcode = "bge";
                        3'b110: opcode = "bltu";
                        3'b111: opcode = "bgeu";
               endcase
        end else begin
              $display("unknown at this time  ");
        end
     end
    endtask
endmodule

