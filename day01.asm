.const sum1_ptr		= $2
.const sum2_ptr		= $4
.const zp_buffer	= $10
.const input_ptr	= $39	// input data pointer on ZP

.const LF			= $0a	// ASCII code for Line Feed

* = $0801 "Basic Header"
				.word init, input; .byte $9e; .text "2061"; .byte 0,0,0

* = * "Find Three Highest Calorie Sums"
init:			sei
				jsr $e544
				ldy #4
				sty sum1_ptr+1
				sty sum2_ptr+1
				iny					// init highest three sums to 00000
				lda #'0'
			!:	sta (sum1_ptr),y
				sta $0428,y
				sta $0450,y
				sta $0478,y
				dey
				bpl !-
				iny
				sty zp_buffer-1		// 5th number is always 0, if read only 4 numbers to the buffer

next_set:		lda #0
				sta sum1_ptr
				lda #40
				sta sum2_ptr
				lda #'0'			// reset 1st sum to 00000
				ldy #5
			!:	sta (sum1_ptr),y
				dey
				bne !-

	next_line:	ldx #0
	get_byte:	lda (input_ptr),y
				beq calc_result		// If 0, end of input -> calculate result
				iny
				cmp #LF				// End of line?
				beq read_done
				sbc #$30			// carry always set here
				sta zp_buffer,x
				inx
				bne get_byte
	
	read_done:	tya					// add Y (# of bytes read) to the input table pointer
				clc
				adc input_ptr
				sta input_ptr
				bcc !+
				inc input_ptr+1
			!:	dex
				bmi cmp_sums		// If X was 0 before dex, no numbers were read, set is complete

				ldy #5				// If set is not complete, add the sum in buffer to total sum
				clc
			!:	lda zp_buffer,x		// with 4-digit nums, X rolls over to $ff -> lda zp_buffer-1 = 0
				dex
				adc (sum1_ptr),y	// add to whatever result we already have
				cmp #$3a			// ≥10 with the addition?
				bcc !+				// if not, skip the subtraction
				sbc #$0a			// subtract 10
			!:	sta (sum1_ptr),y
				dey
				bne !--				// loop until all digits have been updated
				beq next_line		// Done, read next line

cmp_sums:		ldy #0
			!:	iny
				cpy #6
				beq next_set		// sum1 = sum2, we're done
				lda (sum2_ptr),y
				cmp (sum1_ptr),y
				beq !-				// num1 = num2, read next num
				bcs next_set		// sum1 < sum2, we're done
	swap_sums:	ldy #5				// sum1 > sum2, swap
			!:	lda (sum2_ptr),y
				pha
				lda (sum1_ptr),y
				sta (sum2_ptr),y
				pla
				sta (sum1_ptr),y
				dey
				bne !-
				lax sum2_ptr		// swap done, move sum pointers to next pair
				cmp #120
				beq next_set		// compared all sums, we're done
				sta sum1_ptr
				sbx #256-40
				stx sum2_ptr
				bne cmp_sums

calc_result:	ldy #5
				clc
			!:	lda (sum2_ptr),y
				adc (sum1_ptr),y
				sbc #$2f			// carry always clear, effectively sbc $30
				cmp #$3a			// ≥10 with the addition?
				bcc !+				// if not, skip the subtraction
				sbc #$0a			// subtract 10
			!:	sta (sum1_ptr),y
				dey
				bpl !--				// loop until all digits have been updated
				lax sum2_ptr		// adding to sum1 done, move sum2 pointer to next line
				cmp #120
			end:beq end
				sbx #256-40			// add 40 to sum2 pointer
				stx sum2_ptr
				bne calc_result

* = * "Input Data"
input:			.import binary "input/day01_input.txt"
				.byte LF
				.byte 0 // End of table
* = * "End"
