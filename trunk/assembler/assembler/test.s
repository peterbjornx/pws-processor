                l r1, &_counter_max
                l r2, &_counter_init
_count:         add r2, r2, 1
                cmp r0, r2, r1 ; due to an assembler bug it is required to define rA even if it isnt used
                bgt &_count
_endloop:       b &_endloop     ; HALT

_counter_init:  .dw 0
_counter_max:   .dw 10