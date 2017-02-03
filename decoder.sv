`include "getreg.sv"
module decoder();
getreg gr_name();

task decode;
input [31:0] lower;
input [63:0] pc;
logic [32:0] rd,rs1,rs2;
logic [64:0] opcode;
logic [7:0] sign;
logic [11:0] temp;
logic [12:0] temp_addr;
logic [63:0] address;
begin
         if (lower[6:0] == 7'b0110011) begin
                gr_name.convert(lower[11:7],rd);
                gr_name.convert(lower[19:15],rs1);
                gr_name.convert(lower[24:20],rs2);
                case({lower[30], lower[25], lower[14:12]})
                        5'b00000: opcode = "add";
                        5'b10000: opcode = "sub";
                        5'b00001: opcode = "sll";
                        5'b00010: opcode = "slt";
                        5'b00110: opcode = "sltu";
                        5'b00100: opcode = "xor";
                        5'b10101: opcode = "sra";
                        5'b00101: opcode = "srl";
                        5'b00110: opcode = "or";
                        5'b00111: opcode = "and";
                        5'b01000: opcode = "mul";
                        5'b01001: opcode = "mulh";
                        5'b01010: opcode = "mulhsu";
                        5'b01011: opcode = "mulhu";
                        5'b01100: opcode = "div";
                        5'b01101: opcode = "divu";
                        5'b01110: opcode = "rem";
                        5'b01111: opcode = "remu";
                endcase
                $display ("%x:  %x          	%s      %s,%s,%s", pc, lower,opcode,rd,rs1,rs2);
        end else if (lower[6:0] == 7'b0010011) begin
                gr_name.convert(lower[11:7],rd);
                gr_name.convert(lower[19:15],rs1);
                if (lower[31] == 1'b1) begin  
                    sign = "-";
                    temp  = - lower[31:20];
                end else begin
                    temp  = lower[31:20];
                    sign = " ";
                end 
                case(lower[14:12])
                        3'b000: opcode = "addi";
                        3'b010: opcode = "slti";
                        3'b011: opcode = "sltiu";
                        3'b100: opcode = "xori";
                        3'b110: opcode = "ori";
                        3'b111: opcode = "andi";
                endcase
                case({lower[30], lower[14:12]})
                        4'b0001: opcode = "slli";
                        4'b0101: opcode = "srli";
                        4'b1101: opcode = "srai";
                endcase
                $display ("%x:  %x              %s      %s,%s,%s%d", pc , lower,opcode,rd,rs1,sign,temp);
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
                if (lower[31] == 1'b1) begin
                    sign = "-";
                    temp  = - lower[31:20];
                end else begin
                    temp  = lower[31:20];
                    sign = " ";
                end
                case (lower[14:12])
                        3'b000: opcode = "lb";
                        3'b001: opcode = "lh";
                        3'b010: opcode = "lw";
                        3'b100: opcode = "lbu";
                        3'b101: opcode = "lhu";
			3'b011: opcode = "ld";
			3'b110: opcode = "lwu";
                endcase
                $display ("%x:  %x              %s      %s,%s,%d", pc , lower,opcode,rd,rs1,lower[31:20]);
        end else if (lower[6:0] == 7'b1100011) begin
                gr_name.convert(lower[24:20],rs2);
                gr_name.convert(lower[19:15],rs1);
                temp_addr = {lower[12],lower[7],lower[10:5],lower[4:1],1'b0};
                if (lower[31] == 1'b1) begin
                    temp_addr = - temp_addr;
                    address  = pc  - temp_addr;
                end else begin
                    address = pc + temp_addr;
                end 
               
                case (lower[14:12])
                        3'b000: opcode = "beq";
                        3'b001: opcode = "bne";
                        3'b100: opcode = "blt";
                        3'b101: opcode = "bge";
                        3'b110: opcode = "bltu";
                        3'b111: opcode = "bgeu";
               endcase
                $display ("%x:  %x              %s      %s,%s,%x", pc , lower,opcode,rs1,rs2,address);
        end else if (lower[6:0]  == 7'b0100011) begin
                gr_name.convert(lower[19:15],rs1);
                gr_name.convert(lower[24:20],rs2);
                case (lower[14:12])
                        3'b000: opcode = "sb";
                        3'b001: opcode = "sh";
                        3'b010: opcode = "sw";
                        3'b011: opcode = "sd";
                endcase
                $display ("%x:  %x              %s      %s,%s", pc, lower,opcode,rs1,rs2);

         end else if (lower[6:0] == 7'b0111011) begin
                gr_name.convert(lower[11:7],rd);
                gr_name.convert(lower[19:15],rs1);
                gr_name.convert(lower[24:20],rs2);
                case({lower[30],lower[25], lower[14:12]})
                        5'b00000: opcode = "addw";
                        5'b10000: opcode = "subw";
                        5'b00001: opcode = "sllw";
                        5'b00101: opcode = "srlw";
                        5'b10101: opcode = "sraw";
                        5'b01000: opcode = "mulw";
                        5'b01100: opcode = "divw";
                        5'b01101: opcode = "divwu";
                        5'b01110: opcode = "remw";
                        5'b01111: opcode = "remuw";
                endcase
                $display ("%x:  %x              %s      %s,%s,%s", pc, lower,opcode,rd,rs1,rs2);
        end else if (lower[6:0] == 7'b0011011) begin
                gr_name.convert(lower[11:7],rd);
                gr_name.convert(lower[19:15],rs1);
                case(lower[14:12])
                        3'b000: opcode = "addiw";
                endcase
                case({lower[30], lower[14:12]})
                        4'b0001: opcode = "slliw";
                        4'b0101: opcode = "srliw";
                        4'b1101: opcode = "sraiw";
                endcase
                $display ("%x:  %x              %s      %s,%s,%d", pc , lower,opcode,rd,rs1,lower[31:20]);
        end else begin
              $display("unknown at this time  ");
        end
     end
    endtask
endmodule

