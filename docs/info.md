How it works

The SmartSat-ALU is an 8-bit synchronous Arithmetic Logic Unit that performs arithmetic, logic, and shift operations based on a 4-bit select signal. The design is divided into three internal units: Arithmetic, Logic, and Shift. A multiplexer selects the final output based on the operation.

For arithmetic operations, overflow is detected using signed arithmetic rules. When overflow occurs, saturation logic clamps the output to the maximum (7F) or minimum (80) value instead of wrapping around. The design also generates status flags including Carry, Zero, and Overflow.

The output is registered on the clock edge to ensure stable and predictable behavior. Additionally, parity is generated using XOR reduction for basic error detection.

How to test

Apply 8-bit input values A and B along with a 4-bit select signal (SEL) to choose the operation. The output updates on the rising edge of the clock.

Basic operations:

ADD (SEL = 0000)
SUB (SEL = 0001)
AND, OR, XOR, NOT
Shift Left and Shift Right

Test important cases:

Normal arithmetic (e.g., 10 + 5)
Overflow case (e.g., 127 + 5 → saturated to 127)
Zero condition (e.g., 5 - 5 → Zero flag = 1)

Observe outputs:

Y → result
Carry → carry/borrow
Overflow → overflow detection
Zero → result is zero
Parity → error detection
External hardware

No external hardware is required. The design is fully digital and can be tested using simulation tools such as ModelSim or Vivado.
