module fifo(w_en, r_en, clk, rst, in, out, empty, full, almost_full, almost_empty);
input w_en, r_en, clk, rst;
input [7:0] in;
output empty, full, almost_full, almost_empty;
output reg [7:0] out;
reg [4:0] r_ptr, w_ptr;
reg  [5:0]counter;
reg [7:0]mem[0:31];

assign empty=(counter == 6'd0);
assign full=(counter == 6'd32);
assign almost_full=(counter == 6'd31);
assign almost_empty=(counter == 6'd1);

always @(posedge clk or posedge rst)
begin
if(rst)
begin
r_ptr<= 5'b00000;
out<= 8'b00000000;
end
else 
begin
if(r_en && !empty) 
begin
out<=mem[r_ptr];
r_ptr<=(r_ptr==5'd31)? 5'd0 : r_ptr+1;
end
end
end

always @(posedge clk or posedge rst)
begin
if(rst)
begin
w_ptr<= 5'b00000;
end
else 
begin
if(!full && w_en)
begin
mem[w_ptr]<=in;
w_ptr<=(w_ptr==5'd31)? 5'd0 : w_ptr+1;
end
end
end

always @(posedge clk or posedge rst)
begin
if(rst)
counter<= 6'd0;
else 
begin
case({w_en && !full , r_en && !empty}) 
2'b00: counter<=counter;
2'b01: counter<=counter - 1'b1;
2'b10: counter<=counter + 1'b1;
2'b11: counter<=counter;
endcase
end
end
endmodule
