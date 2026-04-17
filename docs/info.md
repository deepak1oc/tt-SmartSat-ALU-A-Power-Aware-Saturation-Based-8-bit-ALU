How it works

SmartSat-ALU is an 8-bit synchronous Arithmetic Logic Unit designed for compact silicon implementation.
It supports arithmetic, logic, and shift operations using a simple select-based control scheme.

The design is organized into three parallel units:

Arithmetic unit performs ADD, SUB, INC, DEC, and MUL operations
Logic unit performs AND, OR, XOR, and NOT
Shift unit performs left and right shifts

All units compute simultaneously, and a multiplexer selects the final result based on the operation.

For arithmetic operations, overflow is detected using signed rules:
overflow = (A[7] == B[7]) && (result[7] != A[7])

Instead of allowing wrap-around, saturation logic clamps the output:

Positive overflow → 7F
Negative overflow → 80

The output is registered on the clock edge for stable operation.

Status flags:

Carry → carry/borrow from arithmetic
Zero → result equals zero
Overflow → signed overflow detected

Parity:

Generated using XOR reduction: Parity = ^Y
Used for simple error detection
How to test
Apply 8-bit inputs A and B
Set operation using SEL[3:0]
Provide clock signal and release reset
Observe outputs on rising clock edge

Operation select (SEL):

0000 = ADD
0001 = SUB
0101 = AND
0110 = OR
0111 = XOR
1000 = NOT
1001 = SHIFT LEFT
1010 = SHIFT RIGHT

Test important cases:

Normal operation: 10 + 5 → 15
Overflow: 127 + 5 → 127 (saturated)
Negative overflow: -128 + (-56) → -128
Zero: 5 - 5 → 0 (Zero flag = 1)

Expected output:

Y → computed result
Carry, Zero, Overflow → status flags
Parity → XOR of output bits
