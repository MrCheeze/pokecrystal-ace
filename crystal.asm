.MEMORYMAP
SLOTSIZE $10000
DEFAULTSLOT 0
SLOT 0 $0
.ENDME
.ROMBANKSIZE $10000
.ROMBANKS 2
.BANK 0 SLOT 0

.define PlaceGraphic $13
.define GetMonBackpic $18
.define GetMonFrontpic $19
.define GetFrontpic $3C
.define GetBackpic $3D
.define FrontpicPredef $3E
.define GetTrainerPic $3F
.define DecompressPredef $40
.define AnimateFrontpic $47
.define Predef48 $48
.define HOF_AnimateFrontpic $49

.define Predef $2D83
.define DelayFrame $045A
.define DelayFrames $0468
.define OpenSRAM $2FD1
.define ForceUpdateCGBPals $0C37

.define PartyMonOT $DDFF
.define PartyMonNicknames $DE41
.define FrontPic $9000
.define BackPic $9310
.define UnknBGPals $D000 ; third wram bank
.define BGPals $D080 ; third wram bank
.define BattleMonNick $C621
.define CopyBytes $3026
.define RedsName $D49E
.define GreensName $D4A9
.define PartySpecies $DCD8
.define PartyMon1Species $DCDF
.define PartyMon1Moves $DCE1

.org PartySpecies
	.db 105
.org PartyMon1Species
	.db $FE
.org PartyMon1Moves
	.db 198 63 245 156

.org PartyMonNicknames ; max length 0xB
	.db $38 $4F $4E $15 $0B $C9 $00
	jp nicknameCode
	
.org RedsName
	.db $92 $80 $8D $92 $7F $94 $8D $83 $84 $91 $93 $80 $8B $84
	char50:
	.db $50
	
.org $DA0E ; max length $64
	nicknameCode:
	
	xor a
	call OpenSRAM
	
	ld hl, compressedBackPic
	ld de, BackPic
	ld c, 6*6
	ld a,DecompressPredef
	call Predef
	ld hl, compressedFrontPic
	ld de, FrontPic
	ld c, 7*7
	ld a,DecompressPredef
	call Predef
	
	
	
	ld de,char50
	scf
	ret

.org $A400 ; must be in sram, not upper bank of wram
	compressedBackPic:
	.db $EC $79 $27 $01 $87 $89 $83 $87 $05 $02 $03 $06 $07 $04 $07 $45 $08 $0F $81 $87 $21 $03 $87 $9D $61 $23 $03 $EC $25 $21 $1F $21 $60 $A5 $B3 $A9 $E7 $21 $0F $21 $1C $21 $C6 $21 $FF $06 $7F $E0 $1F $F8 $47 $FF $E0 $44 $FF $40 $43 $80 $FF $00 $CF $24 $FF $21 $FE $21 $FC $23 $84 $21 $7C $EC $23 $A1 $CB $21 $0C $23 $02 $27 $01 $81 $89 $21 $03 $21 $E1 $21 $71 $83 $DF $06 $FC $0F $F0 $3F $C4 $FF $0E $44 $FF $04 $A1 $E1 $03 $03 $FF $E7 $FF $C5 $DA $21 $7E $23 $43 $F0 $25 $DF $BD $00 $5E $A1 $EB $A1 $EE $45 $20 $E0 $81 $87 $CB $8C $8B $00 $D6 $EC $6B $FF
	compressedFrontPic:
	.db $EC $F9 $21 $01 $21 $06 $23 $08 $A1 $81 $25 $13 $81 $89 $21 $1A $81 $85 $21 $11 $21 $0C $21 $1F $13 $2F $3F $6F $79 $47 $7C $9B $FF $84 $FF $82 $FF $44 $7F $34 $3F $1C $1F $0F $0F $23 $1F $81 $85 $21 $38 $21 $20 $81 $87 $EC $33 $21 $FF $67 $23 $83 $21 $93 $81 $C9 $83 $93 $21 $55 $21 $FE $21 $01 $81 $87 $81 $F7 $09 $EF $EE $93 $93 $82 $83 $C6 $C7 $82 $83 $43 $FE $FF $83 $80 $21 $EF $21 $C7 $21 $44 $21 $C6 $F8 $37 $00 $FB $21 $C0 $23 $20 $21 $10 $25 $90 $81 $89 $21 $B0 $C3 $88 $21 $60 $21 $F0 $13 $E8 $F8 $EC $3C $C4 $7C $B2 $FE $42 $FE $82 $FE $44 $FC $58 $F8 $70 $F0 $E0 $E0 $23 $F0 $81 $85 $21 $38 $A1 $A1 $81 $87 $EC $F9 $FF
	
.org $BD83 ; max length $18A