//A一瓶饮料1.5元 B一瓶一元
//状态机ael = 1表示A，sel = 0表示B
//s0 0元, s1 0.5元 , s2 1元 s3 1.5元， s4 2元
//硬币 0.5元，1元（一次一枚）
module Sell2 (
    input clk,
    input rst_n,
    input[1:0] money,
    input sel,
    output drink,
    output coin
);
parameter s0 = 5'b00001;//0
parameter s1 = 5'b00010;//0.5
parameter s2 = 5'b00100;//1
parameter s3 = 5'b01000;//1.5
parameter s4 = 5'b10000;//2

reg [4:0] current_state;
reg [4:0] next_state;
reg r_drink;//寄存器，更符合规定，输出1表示一瓶饮料
reg r_coin;//输出1表示找零五毛

assign coin = r_coin;//寄存器类型只能用always赋值，不能反过来
assign drink = r_drink;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
    current_state <= s0;
    r_drink <= 1'b0;
    r_coin <= 1'b0;
    end else begin
    current_state <= next_state; 
    end
end
always @(*) begin
    next_state = current_state;
    r_drink = 1'b0;
    r_coin = 1'b0;
    if(money == 2'b11)begin next_state = s0;
    end else begin 
        case(sel) 
          1'b1: begin//买1.5元商品A
            case(current_state)
              s0:begin if(money[0] == 1'b1) next_state = s1; //阻塞
                       else if (money[1] == 1'b1)  next_state = s2;
                       else  next_state = current_state;end
              s1:begin if(money[0] == 1'b1) next_state = s2; 
                       else if (money[1] == 1'b1) next_state = s3;
                       else next_state = current_state;end
              s2:begin if(money[0] == 1'b1)next_state =s3; 
                       else if (money[1] == 1'b1) next_state =s4;
                       else next_state = current_state;end
              s3:begin next_state = s0;
                       r_drink = 1'b1;
                       r_coin = 1'b0;end
              s4:begin next_state = s0;
                       r_drink = 1'b1;
                       r_coin = 1'b1;end
              default: next_state =s0;  
            endcase
                end
        1'b0: begin//买1元商品B
            case(current_state)
              s0:begin if(money[0] == 1'b1) next_state =s1; 
                       else if (money[1] == 1'b1) next_state =s2;
                       else next_state = current_state;end
              s1:begin if(money[0] == 1'b1) next_state =s2;
                       else if (money[1] == 1'b1)next_state =s3;
                       else  next_state = current_state;end
              s2:begin next_state = s0;
                       r_drink = 1'b1;
                       r_coin = 1'b0;end
              s3:begin next_state = s0;
                       r_drink = 1'b1;
                       r_coin = 1'b1;  end  
              default: next_state = s0;   
            endcase
              end
    endcase      
   end 
end

endmodule
