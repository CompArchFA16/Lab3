LW   -> Load Word
SW   -> Store Word
J    -> Jump
JR   -> Jump Register
JAL  -> Jump and Link
BNE  -> Branch not equal
XORI -> XOR Immeditate
ADD  -> Add
SUB  -> Subtract
SLT  -> Select Less than

Instr |Type| Op Code | Func |
------|----| ------- | ---- |
J     | J  | 0x2     |      |
JAL   | J  | 0x3     |      |
LW    | I  | 0x23    |      |
SW    | I  | 0x2b    |      |
BNE   | I  | 0x5     |      |
XORI  | I  | 0xe     |      |
JR    | R  | 0x00    | 0x08 |
ADD   | R  | 0x00    | 0x20 |
SUB   | R  | 0x00    | 0x22 |
SLT   | R  | 0x00    | 0x2a |

Type  | Memory |
----- | ------ |
J     | OP(6bit) ADDR(26bit) |
I     | OP(6bit) Rs(5bit) Rt(5bit) Imm(16bit) |
R     | OP(6bit) Rs(5bit) Rt(5bit) Rd(5bit) Shampt(5bit) Funct(6bit) |
