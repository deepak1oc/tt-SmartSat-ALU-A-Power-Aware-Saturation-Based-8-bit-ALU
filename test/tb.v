`timescale 1ns / 1ps

module tb_smart_alu8;

    reg clk;
    reg rst;
    reg en;
    reg [7:0] A, B;
    reg [3:0] SEL;

    wire [7:0] Y;
    wire Carry, Zero, Overflow;
    wire [2:0] Status;
    wire Parity;

    smart_alu8 uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .A(A),
        .B(B),
        .SEL(SEL),
        .Y(Y),
        .Carry(Carry),
        .Zero(Zero),
        .Overflow(Overflow),
        .Status(Status),
        .Parity(Parity)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task to apply input and print AFTER clock edge
    task apply;
        input [7:0] a, b;
        input [3:0] sel;
        begin
            A = a;
            B = b;
            SEL = sel;
            @(posedge clk);  // wait for correct update
            #1;
            $display("A=%d B=%d SEL=%b | Y=%d Carry=%b Overflow=%b Zero=%b Status=%b Parity=%b",
                     A, B, SEL, Y, Carry, Overflow, Zero, Status, Parity);
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        en = 1;

        A = 0;
        B = 0;
        SEL = 0;

        #10 rst = 0;

        $display("------ ARITHMETIC TESTS ------");
        apply(10, 5, 4'b0000);    // ADD
        apply(10, 5, 4'b0001);    // SUB

        $display("------ LOGIC TESTS ------");
        apply(8'b10101010, 8'b11001100, 4'b0101); // AND
        apply(8'b10101010, 8'b11001100, 4'b0110); // OR
        apply(8'b10101010, 8'b11001100, 4'b0111); // XOR
        apply(8'b10101010, 0, 4'b1000);           // NOT

        $display("------ SHIFT TESTS ------");
        apply(8'b10000001, 0, 4'b1001); // LEFT SHIFT
        apply(8'b10000001, 0, 4'b1010); // RIGHT SHIFT

        $display("------ OVERFLOW + SATURATION ------");
        apply(127, 5, 4'b0000);   // POSITIVE OVERFLOW
        apply(128, 200, 4'b0000); // NEGATIVE OVERFLOW

        $display("------ ZERO TEST ------");
        apply(5, 5, 4'b0001);     // ZERO

        $display("------ PARITY TEST ------");
        apply(8'b11111111, 0, 4'b0101);

        $stop;
    end

endmodule
