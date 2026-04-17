## How it works

SmartSat-ALU is an 8-bit synchronous Arithmetic Logic Unit designed for compact silicon implementation. It performs arithmetic, logic, and shift operations based on a 4-bit select signal.

The design is divided into three parallel units:

- Arithmetic unit performs ADD, SUB, INC, DEC, and MUL operations  
- Logic unit performs AND, OR, XOR, and NOT  
- Shift unit performs left and right shifts  

All units compute simultaneously, and a multiplexer selects the final output based on the selected operation.

For arithmetic operations, overflow is detected using signed arithmetic rules:

overflow = (A[7] == B[7]) && (result[7] != A[7])

Instead of allowing wrap-around, saturation logic clamps the output:

- Positive overflow → 7F  
- Negative overflow → 80  

The output is registered on the rising edge of the clock to ensure stable and predictable behavior.

Status flags:
- Carry → carry/borrow from arithmetic operations  
- Zero → result equals zero  
- Overflow → signed overflow detection  

Parity:
- Generated using XOR reduction:
  Parity = ^Y
- Used for basic error detection  


## How to test

1. Apply 8-bit input values A and B  
2. Select the operation using SEL[3:0]  
3. Provide a clock signal and release reset  
4. Observe outputs on the rising edge of the clock  

Operation select (SEL):
- 0000 = ADD  
- 0001 = SUB  
- 0010 = INC  
- 0011 = DEC  
- 0100 = MUL  
- 0101 = AND  
- 0110 = OR  
- 0111 = XOR  
- 1000 = NOT  
- 1001 = SHIFT LEFT  
- 1010 = SHIFT RIGHT  

Test important cases:
- Normal operation: 10 + 5 → 15  
- Overflow: 127 + 5 → 127 (saturated)  
- Negative overflow: -128 + (-56) → -128  
- Zero condition: 5 - 5 → 0 (Zero flag = 1)  

Expected outputs:
- Y → result  
- Carry → carry/borrow indicator  
- Overflow → overflow detection  
- Zero → high when result is zero  
- Parity → XOR of output bits  
