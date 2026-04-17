`timescale 1ns / 1ps

module smart_alu8 (
    input clk,
    input rst,
    input en,
    input [7:0] A,
    input [7:0] B,
    input [3:0] SEL,
    output reg [7:0] Y,
    output reg Carry,
    output reg Zero,
    output reg Overflow,
    output reg [2:0] Status,
    output reg Parity
);

    reg [7:0] arith_out, logic_out, shift_out;
    reg carry_a, overflow_a;

    reg [8:0] sum_ext, diff_ext;

    always @(*) begin
        arith_out = 8'd0;
        carry_a = 0;
        overflow_a = 0;

        case (SEL)

            4'b0000: begin
                sum_ext = {1'b0, A} + {1'b0, B};
                arith_out = sum_ext[7:0];
                carry_a = sum_ext[8];

                overflow_a = (A[7] == B[7]) && (arith_out[7] != A[7]);

                if (overflow_a)
                    arith_out = (A[7]) ? 8'h80 : 8'h7F;
            end

            4'b0001: begin
                diff_ext = {1'b0, A} - {1'b0, B};
                arith_out = diff_ext[7:0];
                carry_a = ~diff_ext[8];

                overflow_a = (A[7] != B[7]) && (arith_out[7] != A[7]);

                if (overflow_a)
                    arith_out = (A[7]) ? 8'h80 : 8'h7F;
            end

            4'b0010: arith_out = A + 1;
            4'b0011: arith_out = A - 1;
            4'b0100: arith_out = A * B;

        endcase
    end

    always @(*) begin
        logic_out = 8'd0;

        case (SEL)
            4'b0101: logic_out = A & B;
            4'b0110: logic_out = A | B;
            4'b0111: logic_out = A ^ B;
            4'b1000: logic_out = ~A;
        endcase
    end

    always @(*) begin
        shift_out = 8'd0;

        case (SEL)
            4'b1001: shift_out = A << 1;
            4'b1010: shift_out = A >> 1;
        endcase
    end

    reg [7:0] final_out;
    reg final_carry;
    reg final_overflow;

    always @(*) begin
        final_out = 8'd0;
        final_carry = 0;
        final_overflow = 0;

        if (!en) begin
            final_out = Y;
        end
        else begin
            case (SEL)

                4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100: begin
                    final_out = arith_out;
                    final_carry = carry_a;
                    final_overflow = overflow_a;
                end

                4'b0101, 4'b0110, 4'b0111, 4'b1000: begin
                    final_out = logic_out;
                end

                4'b1001, 4'b1010: begin
                    final_out = shift_out;
                end

            endcase
        end
    end

    reg parity;

    always @(*) begin
        parity = ^final_out;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Y <= 0;
            Carry <= 0;
            Zero <= 0;
            Overflow <= 0;
            Status <= 0;
            Parity <= 0;
        end
        else if (en) begin
            Y <= final_out;
            Carry <= final_carry;
            Overflow <= final_overflow;
            Zero <= (final_out == 0);
            Status <= {final_overflow, final_carry, (final_out == 0)};
            Parity <= parity;
        end
    end

endmodule
