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
;.define FillMoves $1B
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
.define TrainerType1 $0E57EB
.define GetBaseData $3856
.define ByteFill $3041
.define LoadTileMapToTempTileMap $309D
.define Call_LoadTempTileMapToTileMap $30B4
.define LoadTempTileMapToTileMap $30BF
.define FillMoves $1064E1

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
.define EnemyMonMoves $D208
.define hRandom $FFE1
.define hJoypadReleased $ffa2
.define hJoypadPressed $ffa3
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
.define ScriptMode $D437
.define ScriptRunning $D438
.define Player $D4D6
.define wItemQuantityChangeBuffer $D10C
.define hMoneyTemp $FFC3
.define wJumptableIndex $CF63
.define wCurrPocket $CF65
.define w2DMenuFlags1 $CFA5
.define wLinkMode $C2DC
.define wRunningTrainerBattleScript $D04D
.define wPlayerLinkAction $CF56
.define CurItem $D106
.define TextBoxFlags $CFCF
.define HM01Quantity $D88B
.define OTPartyMonOT $d3a8
.define BattleType $D230
.define sMobileEventIndex $be3c ; sram bank 01
.define hROMBank $ff9d
.define InBattleTowerBattle $cfc0
.define Options2 $cfd1 ; menu account

.org $D9C1 ; max length 0x31
wramCode1:
everyFrame:
	
	ld hl,wSpecialPhoneCallID
	ld a,[hl]
	and $FA ; change if 0,1,4,or 5. only the 0 and 5 case matter, the other two are side effects.
	jr nz,dontChangePhone
	ld [hl],$9C
	dontChangePhone:
	
	ld hl,ScriptMode
	ld b,[hl]
	inc b
	ld hl,PlayerState
	ld a,[hl]
	and $FE
	jr nz,dontChangeBike
	ldh a, (hJoypadDown # $100)
	srl a
	and b
	and $01
	ld [hl],a
	dontChangeBike:
	
	ld a, [$C9F5]
	sub $20
	ld hl,aboutToLink
	jr z,runSramCodeAtHL
	
	ld a,[TextBoxFlags]
	ld hl,$C540 ; tm pocket
	
	jr everyFrameCont
wramCode1End:
	
	
.org $DA21 ; max length 0x51
wramCode2:
everyStep:
	ld hl,everyStepSram
	; fall through
runSramCodeAtHL:
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
	
everyFrameCont:
	sub $13
	add [hl]
	jr nz,dontChangeItem
	ld hl,HM01Quantity
	ld a,$F3
	ld [CurItem],a
	ld a,[hl]
	swap [hl]
	or [hl]
	ld [hl],a
	dontChangeItem:
	
	ld a, [wSpriteUpdatesEnabled]
	dec a
	ld hl,MusicBank
	or [hl]
	ld hl,startingWildBattle
	jr z,runSramCodeAtHL
	
	ld a,[CurOTMon]
	inc a
	ld hl,startingTrainerBattle
	jr z,runSramCodeAtHL
	
	ld a,[EnemyMonHappiness]
	sub 70
	ld hl,sendingOutPokemon
	jr z,runSramCodeAtHL
	ret

wramCode2End:

	
.org wSpecialPhoneCallID
	.db $9C
	
	
.org $BD83 ;sram free space, max length 0x152
sramCode:
everyStepSram:
	ld hl,$FF81
	xor a
	ld [hld],a
	ld [hl],$C3 ; jp $E000
	
	ld a,1
	call OpenSRAM
	ld a,$0B
	ld [sMobileEventIndex],a
	
	ld hl,everyFrameSetup-everyStepSram+TileMap
	ld de,$C000
	ld bc,everyFrameSetupEnd-everyFrameSetup
	jp CopyBytes
	ret
	
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
	
	
RCENameStart:
	.db $4F $4E $15 $0B $C9 $00
	jp (wramCode1End-wramCode1)+(otherPlayerCode-sramCode)+$CB84
RCENameEnd:

startingWildBattle:
	ld a,[Options2]
	and a
	ret z
	
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
	
	ld hl,BattleType
	ldh a,(hRandom # $100)
	or [hl]
	ret nz
	ld a,$07 ;shiny
	ld [BattleType],a
	ret
	
	
sendingOutPokemon:
	ld a,[wLinkMode]
	and a
	ret nz

	ld hl,EnemyMonHP
	ld a,[hli]
	or [hl]
	ret z
	
	ld l,EnemyMonHappiness # $100
	xor a
	ld [hl],a
	ld [$D1EA],a
	ld hl,EnemyMonMoves+2
	; intentionally leave last move unchanged
	ld [hld],a
	ld [hld],a
	; intentionally leave first move unchanged
	ld d,h
	ld e,l
	
	ld l,1 + EnemyMonMaxHP # $100
	ld a,[hld]
	ld b,[hl]
	dec hl
	ld [hld],a
	ld [hl],b
	
	ld a,FillMoves / $10000
	ld [$2000],a
	call FillMoves # $10000
	ldh a,(hROMBank # $100)
	ld [$2000],a
	ret
	
	
startingTrainerBattle:
	
	xor a
	ld [CurOTMon],a
	
	ld a,[Options2]
	and a
	ret z
	
	ld a,[wLinkMode]
	ld hl,InBattleTowerBattle
	or [hl]
	ret nz
	
	ld a,[PlayerID]
	ld hl,wCurrentMapPersonEventHeaderPointer
	xor [hl]
	ld b,a
	ld de,OTPartySpecies
	ld hl,OTPartyMon1Level
	
	modifyPartyLoop:
	ld a,[de]
	inc a
	ret z
	xor b
	ld [de],a
	inc de
	push bc
	ld a,[hl]
	srl a
	;srl a
	add [hl]
	ld [hl],a
	ld bc,$0030
	add hl,bc
	pop bc
	jr modifyPartyLoop
	ret
	
aboutToLink:
	ld a,[wPlayerLinkAction]
	cp $05
	ret nz
	xor a
	call OpenSRAM
	
	ld hl,RCENameStart
	ld de,$C806
	ld bc,RCENameEnd-RCENameStart
	call CopyBytes
	
	ld hl,wramCode2
	ld de,$C6CE-(wramCode2End-wramCode2)
	ld c,(wramCode2End-wramCode2) # $100
	call CopyBytes
	
	ld hl,wramCode1
	ld de,$C9F5
	ld c,(wramCode1End-wramCode1) # $100
	call CopyBytes
	
	ld hl,sramCode
	ld bc,(sramCodeEnd-sramCode)
	call CopyBytes
	
	; fall through
	ld hl,$C9F5 + (encryptedSramPartEnd-sramCode)+(wramCode1End-wramCode1)
encryptedSramPartEnd:

encryptPayload: ; needed to prevent $21 being replaced with $FE
	ld bc,(encryptedSramPartEnd-sramCode)+(wramCode1End-wramCode1)
	payloadLoop:
	dec bc
	dec hl
	ld a,$80
	add [hl]
	ld [hl],a
	ld a,b
	or c
	jr nz,payloadLoop
	
	ret
	
otherPlayerCode:
	xor a
	call OpenSRAM

	ld h,($CB84 + (encryptedSramPartEnd-sramCode)+(wramCode1End-wramCode1)) / $100
	ld l,($CB84 + (encryptedSramPartEnd-sramCode)+(wramCode1End-wramCode1)) # $100
	call (wramCode1End-wramCode1)+(encryptPayload-sramCode)+$CB84
	
	ld de,wramCode1
	ld c,wramCode1End-wramCode1
	call CopyBytes
	
	ld de,sramCode
	ld bc,(sramCodeEnd-sramCode)
	call CopyBytes

	ld hl,$C798-(wramCode2End-wramCode2)
	ld c,(wramCode2End-wramCode2) # $100
	ld a,$FF ; we need an FF byte at $cc9e
	ld de,wramCode2
	call CopyBytes
	
	call everyFrame
	
	ld h,OTPartyMonOT / $100
	ld l,OTPartyMonOT # $100
	ld de,OTPlayerName
	push de
	ld bc,11
	call CopyBytes
	pop de
	ld h,$C5
	ld l,$44
	scf
	ret
sramCodeEnd:
	