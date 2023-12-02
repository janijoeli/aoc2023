.namespace zp {
	.label tens			= $403
	.label ones			= $404
	.label input_ptr	= $39	// input data pointer on ZP, initialised by line number in basic header
}

.const sum			= $0428	// pointer to sum on screen
.const LF			= $0a	// ASCII code for Line Feed

* = $0801 "Basic Header"
					.word init, input; .byte $9e; .text "2061"; .byte 0,0,0

* = * "Calculate sum of calibration numbers"
init:				sei
					jsr $e544

					lda #'0'			// init the total sum on screen to 00000
					ldy #4
				!:	sta sum,y
					dey
					bpl !-

next_line:
					ldy #0
read_1st_digit:
					lda (zp.input_ptr),y
					beq end				// if 0, we've processed all input
					iny
					cmp #$3a
					bcs read_1st_digit
					sta zp.tens
					sta zp.ones			// hold digit in X for now, as there could be only one digit in the string

read_2nd_digit:
					lda (zp.input_ptr),y
					iny
					cmp #$3a
					bcs read_2nd_digit
					cmp #LF				// if read char is line feed, reading digits is done
					beq update_input_ptr
					sta zp.ones			// found another digit
					jmp read_2nd_digit	// continue, as the above may not be the last digit


update_input_ptr:
					tya					// update input_ptr to point to next line in file
					clc
					adc zp.input_ptr
					sta zp.input_ptr
					bcc update_sum
					inc zp.input_ptr+1

update_sum:			lda zp.ones			// A = ones
					ldy #4				// Y points to the least significant digit (ones)
					jsr do_update_sum		// A holds value to add (plus $30), Y holds index of digit to add to

					lda zp.tens
					ldy #3
					jsr do_update_sum

					jmp next_line

			end:	jmp *




do_update_sum:		sec					// deduct $30 from value (converts petscii code to actual value)
					sbc #$30
	add_to_digit:	clc
					adc sum,y			// Add new value to existing one
					cmp #$3a			// Did digit roll over?
					bcc no_rollover		// If not, branch
					sbc #10				// digit rolled over, deduct 10 from value
					sta sum,y			// save new digit value
					dey
					bmi done			// Branch if all digits are now updated
					lda #1				// Add one to digit left of updated
					bvc add_to_digit	// always branch
	no_rollover:	sta sum,y			// save value of last digit to update
	done:			rts

* = * "Input Data"
input:
					// .import binary "input/day01_input_test.txt"
					// 22
					// 22
					// 95
					// 2l
					// 78
					//=238

					.import binary "input/day01_input.txt"
					.byte 0 // End of table
* = * "End"
