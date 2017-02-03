`include "Sysbus.defs"
`include "getreg.sv"
module top
#(
  BUS_DATA_WIDTH = 64,
  BUS_TAG_WIDTH = 13,
  UPPER_WIDTH = BUS_DATA_WIDTH >> 1
)
( 
  input  clk,
         reset,
  // 64-bit address of the program entry point
  input  [63:0] entry,
  // interface to connect to the bus
  output bus_reqcyc,
  output bus_respack,
  output [BUS_DATA_WIDTH-1:0] bus_req,
  output [BUS_TAG_WIDTH-1:0] bus_reqtag,
  input  bus_respcyc,
  input  bus_reqack,
  input  [BUS_DATA_WIDTH-1:0] bus_resp,
  input  [BUS_TAG_WIDTH-1:0] bus_resptag

);

  getreg gr_name();
  logic [32:0] rd,rs1,rs2,opcode;
  logic [63:0] pc;
  logic requestCycle;
  logic respack;
  logic [UPPER_WIDTH - 1:0] upper;
  logic [UPPER_WIDTH - 1:0] lower;
  logic [64:0] opcode;

  always_ff @ (posedge clk) begin
    if (reset) begin
       pc <= entry;
    end else begin
      if (requestCycle == 1) begin
          requestCycle = 0;
          bus_req <= pc;
          bus_reqtag <= `SYSBUS_READ << 8 | `SYSBUS_MEMORY << 12;
          bus_reqcyc <= `SYSBUS_READ;
      end
      if (bus_reqack == 1) begin
        bus_reqcyc <= 0;
      end
      if(bus_respcyc == 1) begin
        respack = 1;
        lower = bus_resp[UPPER_WIDTH - 1:0];
        upper = bus_resp[BUS_DATA_WIDTH-1:UPPER_WIDTH];
       // bus_reqcyc <= 0;
        gr_name.convert(lower[11:7],rd);
        gr_name.convert(lower[19:15],rs1);
        gr_name.convert(lower[24:20],rs2);
        $display("0x%x  ", lower);
       // $display("0x%x                bits[6:0] = 0b%b", upper, upper[6:0]);
        if (lower[6:0] == 7'b0110011) begin
                gr_name.convert(lower[11:7],rd);
                gr_name.convert(lower[19:15],rs1);
                gr_name.convert(lower[24:20],rs2);
                case({lower[30], lower[14:12]})
                        4'b0000: $display("add          ");
                        4'b1000: $display("sub          ");
                        4'b0001: $display("sll          ");
                        4'b0010: $display("slt          ");
                        4'b0110: $display("sltu         ");
                        4'b0100: $display("xor          ");
                        4'b1101: $display("sra          ");
                        4'b0000: $display("or           ");
                        4'b0000: $display("and          ");
                endcase

        end else if (lower[6:0] == 7'b0010011) begin
                case(lower[14:12])
                        3'b000: $display("addi          ");
                        3'b010: $display("slti          ");
                        3'b011: $display("sltiu         ");
                        3'b100: $display("xori          ");
                        3'b110: $display("ori           ");
                        3'b111: $display("andi          ");
                endcase
                case({lower[30], lower[14:12]})
                        4'b0001: $display("slli         ");
                        4'b0101: $display("srli         ");
                        4'b1101: $display("srai         ");
                endcase
        end else if (lower[6:0] == 7'b1110011) begin
                gr_name.convert(lower[11:7],rd);
                gr_name.convert(lower[19:15],rs1);
                case (lower[14:12])
                        3'b001: $display("csrrw		%s,%s"rd,rs1 );
                        3'b010: $display("csrrs		%s,%s",rd,rs1);
			3'b011: $display("csrrc         %s,%s",rd,rs1);
                        3'b101: $display("csrrwi        %s,%d",rd,lower[14:12]);
                        3'b110: $display("csrrsi        %s,%d",rd,lower[14:12]);
                        3'b111: $display("csrrci        %s,%d",rd,lower[14:12]);
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
                $display("%s		%s,%s,%d",opcode,rd,rs1,lower[31:20])
        end else if (lower[6:0] == 7'b1100011) begin
                case (lower[14:12])
                        3'b000: $display("beq           ");
                        3'b001: $display("bne           ");
                        3'b100: $display("blt           ");
                        3'b101: $display("bge           ");
                        3'b110: $display("bltu          ");
                        3'b111: $display("bgeu          ");
                endcase
        end else begin
                $display("unknown at this time  ");
        end
        if (upper == 32'h00008067) begin
          $finish;
        end
        if (lower == 32'h00008067) begin
          $finish;
        end
        bus_respack <= 1;
      end
    if (respack == 1) begin
      if (bus_respcyc == 0) begin
        respack = 0;
        bus_respack <= 0;
        pc <= pc +8'h40;
        requestCycle = 1;
       end
     end
    end
  end
//always @ (negedge bus_respcyc) begin

  //   if (reset) begin

   //  end

   //  else begin

    //  if(requestCycle == 1) begin

    //     requestCycle = 0;

    //     bus_reqcyc = `SYSBUS_READ;

     //  end

    // end

 //end

  initial begin
    $display("Initializing top, entry point = 0x%x", entry);
    requestCycle = 1;
    respack = 0;
  end
endmodule
