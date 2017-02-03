`include "Sysbus.defs"
`include "decoder.sv"
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
  decoder get_decoder();
  logic [64:0] opcode;
  logic [63:0] pc;
  logic requestCycle;
  logic respack;
  logic [3:0] data_index;
  logic [UPPER_WIDTH - 1:0] upper;
  logic [UPPER_WIDTH - 1:0] lower;

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
        //$display("0x%x	", lower);
	
       // $display("0x%x		bits[6:0] = 0b%b", upper, upper[6:0]);
        get_decoder.decode(lower, pc + data_index*4);
        get_decoder.decode(upper, pc + (data_index + 1) * 4 );
	data_index = data_index + 2;
        if (upper == 32'h00000000) begin
          $finish;
        end
        if (lower == 32'h00000000) begin
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
    data_index = 0;
  end
endmodule
