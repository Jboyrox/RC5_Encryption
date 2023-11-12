# RC5_Encryption
AHD HW 4

Data Path For Simple function (RC5):
![Screenshot 2023-11-12 at 3 40 21 PM](https://github.com/Jboyrox/RC5_Encryption/assets/45749588/ff1f8f01-9af2-4d6c-afeb-dffb0a804b6e)

Data Path For Inverse of the simple fuction:
![Screenshot 2023-11-12 at 3 41 09 PM](https://github.com/Jboyrox/RC5_Encryption/assets/45749588/4bfa6ab6-0cdd-4726-b14c-1d1725c83fae)


Finite State Machines Used in to create the encoders and decoders
![Screenshot 2023-11-12 at 3 41 57 PM](https://github.com/Jboyrox/RC5_Encryption/assets/45749588/5ddf38e4-7276-4309-b67f-76733b2e5e10)

For the encoder implementation, a 64-bit input signal, d_in, undergoes encoding to produce a corresponding 64-bit output. The first half of the input, stored in register a_reg, and the second half, stored in register b_reg, are XORed to produce ab_xor. Based on the 5 least significant bits (LSB) of b_reg, ab_xor is left-rotated using a case statement and stored in a_rot. The value of a_rot is then added to a ROM value selected by the counter, i_cnt, and stored in a signal called a. Subsequently, the unaffected b_reg is XORed with the value of signal a, producing ba_xor. ba_xor is then left-rotated based on the 5 LSB bits of signal a using a case statement, and the result is stored in b_rot. Signal b is updated by adding b_rot and a value from the ROM based on the counter.

The encoder's logic is encapsulated in three process statements. On reset (rst set to 0), a_reg takes the value of the first half of d_in, b_reg takes the second half of d_in, and the counter i_cnt is reset to 1. At the rising edge of the clock, a_reg takes the value of a, b_reg takes the value of b, and the counter increments by 1, resetting to 1 when it reaches 12. The output d_out is then formed by concatenating the values of a_reg and b_reg.

For the decoder implementation, the wire d_in receives the encoded 64-bit value from the encoder. The wire d_out produces the original input. The first half of the 64-bit input is stored in register a_reg, and the second half is stored in register b_reg. b_reg is subtracted from a ROM value based on the counter, i_cnt, and stored in wire b. b is then right-rotated based on the 5 LSB values of a_reg, producing b_rot. The result is XORed with a_reg, stored in wire ba_xor. a_reg is then subtracted from a ROM value selected by i_cnt. Based on the 5 LSB bits from ba_xor as a selector, wire a is right-rotated and stored in a_rot. a_rot is XORed with ba_xor, and the result is stored in ab_xor.

Three always statements handle the decoder's logic. On reset (rst set to 0), at the negative edge of the reset, a_reg and b_reg receive the input value, and the counter is set to 12. On a positive edge, a_reg is updated with the value of ab_xor, b_reg is updated with the value of ba_xor, and the counter decrements by 1 until it reaches 1, where it resets to 12. The output d_out is then formed by concatenating the values of a_reg and b_reg.

In the testbench, file I/O is checked for operability. The reset is tested to verify that the inputs and outputs for both encryption and decryption match. After 12 rising edge counts, the output for the encoder should match the initial input for the decoder, and vice versa. If any values do not match, the testbench stops. A message appears after all tests are complete, confirming the successful execution of all encryptions and decryptions. We test both our encoder and decoder using the same testbench

![Screenshot 2023-11-12 at 3 45 04 PM](https://github.com/Jboyrox/RC5_Encryption/assets/45749588/2654775f-c0e7-4ff2-8265-b4d379654add)


