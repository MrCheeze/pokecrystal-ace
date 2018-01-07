.MEMORYMAP
SLOTSIZE $10000
DEFAULTSLOT 0
SLOT 0 $0
.ENDME
.ROMBANKSIZE $10000
.ROMBANKS 2
.BANK 0 SLOT 0

.define CalcPkmnStats $0C
.define CalcPkmnStatC $0D
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
.define CloseSRAM $2FE1
.define ForceUpdateCGBPals $0C37
.define Reset $0150
.define Random $2F8C
.define FarCall $08
.define TrainerType1 $0E57EB
.define GetBaseData $3856
.define ByteFill $3041
.define LoadTileMapToTempTileMap $309D
.define Call_LoadTempTileMapToTileMap $30B4
.define LoadTempTileMapToTileMap $30BF

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
.define wSpecialPhoneCallID $DC31
.define TempWildMonSpecies $D22E
.define CurPartySpecies $D108
.define TempEnemyMonSpecies $D204
.define TempBattleMonSpecies $D205
.define hRandom $FFE1
.define hJoypadDown $FFA4
.define hJoyDown $FFA8
.define wRoamMon1MapGroup $DFD1
.define wRoamMon1MapNumber $DFD2
.define wRoamMon2MapGroup $DFD6
.define wRoamMon2MapNumber $DFD7
.define wRoamMon3MapGroup $DFDD
.define wRoamMon3MapNumber $DFDE
.define MusicBank $C29F
.define wSpriteUpdatesEnabled $C2CE
.define PlayerName $D47D
.define PlayerID $D47B
.define OTPlayerName $D26B
.define OTPartyCount $D280
.define OTPartySpecies $D281
.define OTPartyMon1Species $D288
.define OTPartyMon1Level $D2A7
.define OTPartyMon1HP $D2AA
.define OTPartyMon1MaxHP $D2AC
.define CurOTMon $C663
.define rSVBK $FF70 ; save bank
.define CurSpecies $CF60
.define CurPartyLevel $D143
.define EnemyMonHappiness $D212
.define EnemyMonHP $D216
.define EnemyMonMaxHP $D218
.define wCurrentMapPersonEventHeaderPointer $DC05
.define TMsHMs $D859
.define TileMap $C4A0
.define wPlayerStepVectorX $D14E
.define PlayerState $D95D
.define ScriptRunning $D438
.define Player $D4D6
.define wItemQuantityChangeBuffer $D10C
.define hMoneyTemp $FFC3
.define wJumptableIndex $CF63
.define wCurrPocket $CF65
.define w2DMenuFlags1 $CFA5
.define wLinkMode $C2DC

.org $D9C1 ; max length 0x31
wramCode1:
runSramCodeAtHL:
	ret nz
	push hl
	call LoadTileMapToTempTileMap
	xor a
	call OpenSRAM
	pop hl
	ld de,TileMap
	ld bc,$168
	call CopyBytes
	call TileMap
	jp LoadTempTileMapToTileMap
	
everyFrame:
	ld c,50
	ld hl,TMsHMs
	nextTm:
	ld a,[hl]
	and a
	jr z,noTm
	ld a,25
	noTm:
	ld [hli],a
	dec c
	jr nz,nextTm
	
	
	ld a, [wSpriteUpdatesEnabled]
	ld hl,MusicBank
	dec a
	jr everyFrameCont
wramCode1End:
	
	
.org $DA21 ; max length 0x51
wramCode2:
everyStep:
	ld hl,everyStepSram
	jp runSramCodeAtHL
	
everyFrameCont:
	or [hl]
	ld hl,startingWildBattle
	call runSramCodeAtHL
	
	
	ld a,[ScriptRunning]
	rlc a
	or $7E
	ld hl,Player
	or [hl]
	ld hl,PlayerState
	and [hl]
	ld [hl],a
	
	ld a,[w2DMenuFlags1]
	sub $0C
	jr nz,notTmPocket
	xor a
	ld hl,hMoneyTemp+1
	ld [hli],a
	ld [hli],a
	notTmPocket:
	
	ld a, [$C801]
	sub $FD
	ld hl,aboutToLink
	call runSramCodeAtHL
	
	ld a,[CurOTMon]
	sub $FF
	ld hl,startingTrainerBattle
	call runSramCodeAtHL
	

	ld hl,EnemyMonHP
	ld a,[hli]
	or [hl]
	ret z
	ld a,[EnemyMonHappiness]
	cp 70
	ld hl,sendingOutPokemon
	jp runSramCodeAtHL
wramCode2End:

	
.org wSpecialPhoneCallID
	.db $9C
	
	
.org $BD83 ;sram free space, max length 0x18A (but 0x168 in practice)
sramCode:
everyStepSram:

	ld hl,PlayerState
	ld a,$7E
	and [hl]
	jr nz,dontForceBike
	ldh a,(hJoypadDown # $100)
	srl a
	or [hl]
	and $01
	ld [hl],a
	dontForceBike:
	
	
	ld hl,$FF81
	xor a
	ld [hld],a
	ld [hl],$C3 ; jp $E000
	
	ld hl,everyFrameSetup-everyStepSram+TileMap
	ld de,$C000
	ld bc,everyFrameSetupEnd-everyFrameSetup
	jp CopyBytes
	
everyFrameSetup:
	ldh a,(rSVBK # $100)
	sub $F9
	jr nz,wrongWramBankToRunCode
	
	ld hl,everyFrame
	push hl
	
	wrongWramBankToRunCode:
	ld a,$C4
	jp $FF82
everyFrameSetupEnd:
	
	
aboutToLink:
	ld de,$C801
	xor a
	call OpenSRAM
	
	ld hl,RCENameStart
	ld bc,RCENameEnd-RCENameStart
	call CopyBytes
	
	ld hl,wramCode1
	ld bc,wramCode1End-wramCode1
	call CopyBytes
	
	ld hl,wramCode2
	ld bc,wramCode2End-wramCode2
	call CopyBytes
	
	ld hl,sramCode
	ld bc,sramCodeEnd-sramCode
	call CopyBytes
	
	ret

RCENameStart:
	.db $4F $4E $15 $0B $C9 $00
	push hl
	push de
	push bc
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	;OTPartyMon1Species ($D288)
	RCENameMiddle:
	ld a,$9C
	ld [wSpecialPhoneCallID],a
	xor a
	call OpenSRAM
	ld hl,OTPartyMon1Species+RCENameEnd-RCENameMiddle
	
	ld de,wramCode1
	ld bc,wramCode1End-wramCode1
	call CopyBytes
	
	ld de,wramCode2
	ld bc,wramCode2End-wramCode2
	call CopyBytes
	
	ld de,sramCode
	ld bc,sramCodeEnd-sramCode
	call CopyBytes
	
	pop hl
	pop de
	pop bc
	scf
	ret
RCENameEnd:


startingWildBattle:
	ld a,[PlayerID]
	ld hl,wCurrentMapPersonEventHeaderPointer
	xor [hl]
	ld hl,TempEnemyMonSpecies
	xor [hl]
	ld [hl],a
	ld hl,CurPartyLevel
	ld a,[hl]
	srl a
	srl a
	add [hl]
	ld [hl],a
	
	ld a,$7E
	ld hl,Player
	or [hl]
	ld hl,PlayerState
	and [hl]
	ld [hl],a
	ret
	
	
sendingOutPokemon:
	ld a,[wLinkMode]
	and a
	ret nz
	
	ld hl,EnemyMonHappiness
	xor a
	ld [hl],a
	ld l,1 + EnemyMonMaxHP # $100
	ld a,[hld]
	ld b,[hl]
	dec hl
	ld [hld],a
	ld [hl],b
	ret
	
	
startingTrainerBattle:
	xor a
	ld [CurOTMon],a
	
	ld a,[wLinkMode]
	and a
	ret nz
	
	ld a,[PlayerID]
	ld hl,wCurrentMapPersonEventHeaderPointer
	xor [hl]
	ld b,a
	ld de,OTPartySpecies
	ld hl,OTPartyMon1Species
	
	modifyPartyLoop:
	ld a,[de]
	inc a
	ret z
	xor b
	ld [de],a
	inc de
	ld [hl],a
	push bc
	ld bc,OTPartyMon1Level-OTPartyMon1Species
	add hl,bc
	ld a,[hl]
	srl a
	srl a
	add [hl]
	ld [hl],a
	ld bc,$30+OTPartyMon1Species-OTPartyMon1Level
	add hl,bc
	pop bc
	jr modifyPartyLoop
	ret
	
	.db $55 $55 $55 $55 $55
sramCodeEnd:
	