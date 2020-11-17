// Describe the Hardware to the assembler
        .arch   armv6
        .cpu    cortex-a53
        .syntax unified

        .text                       // start of the text segment

        /////////////////////////////////////////////////////////
        // function FP2float
        /////////////////////////////////////////////////////////

        .type   FP2float, %function // define as a function
        .global FP2float            // export function name
        .equ    FP_OFF_FP2, 28      // (regs - 1) * 4

FP2float:
        push    {r4-r9, fp, lr}     // use r4-r9 for variables
        add     fp, sp, FP_OFF_FP2  // locate our frame pointer
        
        /////////////////////////////////////////////////////////
        // do not edit anything in this function above this line
        // your code goes Below this comment
        // Store return value (results) in r0
        /////////////////////////////////////////////////////////
	
	and r1, r0, 0x7f //mask input to determine +0 or -0
	cmp r1, 0	//determine if +0 or -0		
	bne default	//if not go to default calculation
	bl zeroFP2float	//if 0 or -0 go to special case
	b done		//go to finish

default:
	lsr r4, r0, 7  //shifts right to get the sign 
	lsl r4, r4, 31	//shifts left to align it for the IEEE form
	
	lsl r5, r0, 25	//remove all the bits to the left of exponent
	lsr r5, r5, 29	//remove all the bits to the right of exponent
	add r5, r5, 124	//convert the exponent to the IEEE form 
	lsl r5, r5, 23	//align it to the IEEE form 

	lsl r6, r0, 28 //remove all the bits to the left of mantissa
	lsr r6, r6, 9 //align it to the IEEE form 

	orr r0, r4, r5 //combine sign and exponent
	orr r0, r0, r6 //combine sign & exponent with mantissa

done:
        /////////////////////////////////////////////////////////
        // your code goes ABOVE this comment
        // do not edit anything in this function below this line
        /////////////////////////////////////////////////////////

        sub     sp, fp, FP_OFF_FP2  // restore sp
        pop     {r4-r9,fp, lr}      // restore saved registers
        bx      lr                  // function return 
        .size   FP2float,(. - FP2float)


        /////////////////////////////////////////////////////////
        // function zeroFP2float
        /////////////////////////////////////////////////////////

        .type   zeroFP2float, %function // define as a function
        .global FP2float                // export function name
        .equ    FP_OFF_ZER, 4           // (regs - 1) * 4

zeroFP2float:
        push    {fp, lr}            // use r0-r3 for variables
        add     fp, sp, FP_OFF_ZER  // locate our frame pointer
        
        /////////////////////////////////////////////////////////
        // do not edit anything in this function above this line
        // your code goes Below this comment
        // Store return value (results) in r0
        /////////////////////////////////////////////////////////

	lsl r0, r0, 24 //shifts left to align it to the IEEE form	


        /////////////////////////////////////////////////////////
        // your code goes ABOVE this comment
        // do not edit anything in this function below this line
        /////////////////////////////////////////////////////////

        sub     sp, fp, FP_OFF_ZER  // restore sp
        pop     {fp, lr}            // restore saved registers
        bx      lr                  // function return
        .size   zeroFP2float,(. - zeroFP2float)

.end
