module divider_prime#(
)(
    input                     clk,
    input                     rstn,
    input                     en,

    input [15:0]               dividend_in,
    input [ 4:0]               divisor,

    output logic               rdy ,
    output logic [16:0]        quotient  
);

logic [4:0] sign;
logic [4:0] i;
logic [15:0] dividend;
always_comb begin
    case(divisor)
        5'b00010: sign = 'd2;
        5'b00011: sign = 'd2;
        5'b00101: sign = 'd3;
        5'b00111: sign = 'd3;
        5'b01011: sign = 'd4;
        5'b01101: sign = 'd4;
        5'b10001: sign = 'd5;
        5'b10011: sign = 'd5;
        5'b10111: sign = 'd5;
        5'b11101: sign = 'd5;
        default:  sign = 'd0;
    endcase
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        i <= 'd16;
    end else if(en) begin
        if(i > 0 && rdy) begin
            i <= i - 1;
        end else begin
            i <= 'd16;
        end
    end else begin
        i <= 'd16;
    end
end
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        rdy            <= 'b0 ;
        quotient       <= 'b0 ;
        dividend       <= 'b0 ; 
    end else if (en) begin
        rdy            <= 1'b1 ;
        if(i == 'd16) dividend = dividend_in;
        if(i > sign) begin
            if((dividend >> (i - sign)) > divisor) begin
                dividend <= (dividend - divisor) << (i - sign);
                quotient <= quotient + 1 << (i-sign);
            end else begin
                dividend <= dividend;
                quotient <= quotient;
            end
            if(i == sign) begin
                if((dividend << 1) >= divisor) begin
                    quotient <= quotient + 1;
                end else begin
                    quotient <= quotient;
                end
            end
        end
    end else begin// if (en)else begin
        rdy            <= 'b0 ;
        quotient       <= 'b0 ;
        dividend       <= 'b0 ; 
    end
end

endmodule