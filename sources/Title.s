; Title.s : タイトル
;


; モジュール宣言
;
    .module Title

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Sound.inc"
    .include	"Title.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; タイトルを初期化する
;
_TitleInitialize::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite

    ; パターンネームのクリア
    xor     a
    call    _SystemClearPatternName

    ; タイトルの初期化
    ld      hl, #titleDefault
    ld      de, #_title
    ld      bc, #TITLE_LENGTH
    ldir

    ; ビデオの設定
    ld      a, #((APP_COLOR_TABLE + 0x0040) >> 6)
    ld      (_videoRegister + VDP_R3), a
    ld      a, #((APP_PATTERN_GENERATOR_TABLE + 0x0800) >> 11)
    ld      (_videoRegister + VDP_R4), a
    ld      a, #((APP_SPRITE_GENERATOR_TABLE + 0x0800) >> 11)
    ld      (_videoRegister + VDP_R6), a

    ; 描画の開始
    ld      hl, #(_videoRegister + VDP_R1)
    set     #VDP_R1_BL, (hl)

    ; 状態の設定
    ld      a, #TITLE_STATE_BEGIN
    ld      (_title + TITLE_STATE), a
    ld      a, #APP_STATE_TITLE_UPDATE
    ld      (_app + APP_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; タイトルを更新する
;
_TitleUpdate::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      a, (_title + TITLE_STATE)
    and     #0xf0
    rrca
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #titleProc
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ex      de, hl
    jp      (hl)
;   pop     hl
10$:

    ; レジスタの復帰
    
    ; 終了
    ret

; 何もしない
;
TitleNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; タイトルを開始する
;
TitleBegin:

    ; レジスタの保存

    ; 初期化
    ld      a, (_title + TITLE_STATE)
    and     #0x0f
    jr      nz, 09$

    ; フラグの設定
    ld      hl, #(_title + TITLE_FLAG)
    set     #TITLE_FLAG_PRINT_BIT, (hl)

    ; BGM の再生
    ld      a, #SOUND_BGM_TITLE_INTRO
    call    _SoundPlayBgm

    ; 初期化の完了
    ld      hl, #(_title + TITLE_STATE)
    inc     (hl)
09$:

    ; サウンドの監視
    call    _SoundIsPlayBgm
    jr      c, 19$

    ; 状態の更新
    ld      a, #TITLE_STATE_LOOP
    ld      (_title + TITLE_STATE), a
;   jr      19$
19$:

    ; 開始画面の描画
    call    TitlePrintBegin

    ; レジスタの復帰

    ; 終了
    ret
    
; タイトルを待機する
;
TitleLoop:

    ; レジスタの保存

    ; 初期化
    ld      a, (_title + TITLE_STATE)
    and     #0x0f
    jr      nz, 09$

    ; フラグの設定
    ld      hl, #(_title + TITLE_FLAG)
    set     #TITLE_FLAG_PRINT_BIT, (hl)

    ; 点滅の設定
    xor     a
    ld      (_title + TITLE_BLINK), a

    ; BGM の再生
    ld      a, #SOUND_BGM_TITLE_MAIN
    call    _SoundPlayBgm

    ; 初期化の完了
    ld      hl, #(_title + TITLE_STATE)
    inc     (hl)
09$:

    ; SPACE の入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 19$

    ; 状態の更新
    ld      a, #TITLE_STATE_END
    ld      (_title + TITLE_STATE), a
;   jr      19$
19$:

    ; 点滅の更新
    ld      hl, #(_title + TITLE_BLINK)
    inc     (hl)

    ; アニメーションの更新
    ld      hl, #(_title + TITLE_ANIMATION)
    inc     (hl)

    ; 待機画面の描画
    call    TitlePrintLoop

    ; レジスタの復帰

    ; 終了
    ret

; タイトルを終了する
;
TitleEnd:

    ; レジスタの保存

    ; 初期化
    ld      a, (_title + TITLE_STATE)
    and     #0x0f
    jr      nz, 09$

    ; フレームの設定
    ld      a, #0x60
    ld      (_title + TITLE_FRAME), a

    ; 点滅の設定
    xor     a
    ld      (_title + TITLE_BLINK), a

    ; サウンドの停止
    call    _SoundStop

    ; SE の再生
    ld      a, #SOUND_SE_BOOT
    call    _SoundPlaySe

    ; 初期化の完了
    ld      hl, #(_title + TITLE_STATE)
    inc     (hl)
09$:

    ; 点滅の更新
    ld      hl, #(_title + TITLE_BLINK)
    ld      a, (hl)
    add     a, #0x08
    ld      (hl), a

    ; アニメーションの更新
    ld      hl, #(_title + TITLE_ANIMATION)
    inc     (hl)

    ; フレームの更新
    ld      hl, #(_title + TITLE_FRAME)
    dec     (hl)
    jr      nz, 19$

    ; 状態の更新
    ld      a, #APP_STATE_GAME_INITIALIZE
    ld      (_app + APP_STATE), a
;   jr      19$
19$:

    ; 待機画面の描画
    call    TitlePrintLoop

    ; レジスタの復帰

    ; 終了
    ret

; 開始画面を描画する
;
TitlePrintBegin:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; スプライトの描画
    ld      hl, #titleBeginSprite
    ld      de, #_sprite
    ld      bc, #(0x05 * 0x04)
    ldir

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 待機画面を描画する
;
TitlePrintLoop:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; パターンネームの描画

    ; 空の描画
    ld      hl, #(_title + TITLE_FLAG)
    bit     #TITLE_FLAG_PRINT_BIT, (hl)
    jr      z, 10$
    res     #TITLE_FLAG_PRINT_BIT, (hl)
    ld      hl, #(_patternName + 0x0100)
    ld      de, #(_patternName + 0x0101)
    ld      bc, #(0x00c0 - 0x0001)
    ld      (hl), #0x70
    ldir

    ; ハイスコアの描画
    ld      hl, #titleLoopPatternName_TopScore
    ld      de, #(_patternName + 0x006a)
    ld      bc, #0x0005
    ldir
    ld      hl, #(_app + APP_SCORE_10000)
    ld      de, #(_patternName + 0x0070)
    call    _AppPrintValue

    ; OPLL の描画
    ld      a, (_slot + SLOT_OPLL)
    cp      #0xff
    jr      z, 10$
    ld      hl, #(_patternName + 0x2a1)
    ld      a, #0x44
    ld      (hl), a
    inc     hl
    inc     a
    ld      (hl), a
    inc     a
    ld      de, #(0x0020 - 0x0001)
    add     hl, de
    ld      (hl), a
    inc     hl
    inc     a
    ld      (hl), a
;   inc     a
10$:

    ; 海の描画
    ld      a, (_title + TITLE_ANIMATION)
    rrca
    rrca
    and     #0x03
    ld      c, a
    add     a, #0x78
    ld      hl, #(_patternName + 0x01c0)
    ld      de, #(_patternName + 0x01c1)
    ld      bc, #(0x0020 - 0x0001)
    ld      (hl), a
    ldir
    inc     hl
    inc     de
    add     a, #0x04
    ld      bc, #(0x0020 - 0x0001)
    ld      (hl), a
    ldir

    ; HIT SPACE BAR の描画
    ld      a, (_title + TITLE_BLINK)
    rrca
    rrca
    and     #0x08
    ld      e, a
    ld      d, #0x00
    ld      hl, #titleLoopPatternName_HitSpaceBar
    add     hl, de
    ld      de, #(_patternName + 0x026c)
    ld      bc, #0x0008
    ldir

    ; スプライトの描画
    ld      hl, #titleLoopSprite
    ld      de, #_sprite
    ld      bc, #(0x0c * 0x04)
    ldir

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 定数の定義
;

; 状態別の処理
;
titleProc:
    
    .dw     TitleNull
    .dw     TitleBegin
    .dw     TitleLoop
    .dw     TitleEnd

; タイトルの初期値
;
titleDefault:

    .db     TITLE_STATE_NULL
    .db     TITLE_FLAG_NULL
    .db     TITLE_FRAME_NULL
    .db     TITLE_BLINK_NULL

; 開始画面
;
titleBeginSprite:

    .db     0x50 - 0x01, 0x78, 0x0c, VDP_COLOR_DARK_RED
    .db     0x48 - 0x01, 0x70, 0x10, VDP_COLOR_LIGHT_RED
    .db     0x48 - 0x01, 0x80, 0x14, VDP_COLOR_LIGHT_RED
    .db     0x58 - 0x01, 0x70, 0x18, VDP_COLOR_LIGHT_RED
    .db     0x58 - 0x01, 0x80, 0x1c, VDP_COLOR_LIGHT_RED

; 待機画面
;
titleLoopPatternName_TopScore:

    .db     0x08, 0x09, 0x03, 0x04, 0x05
    
titleLoopPatternName_HitSpaceBar:

    .db     0x00, 0x3b, 0x3f, 0x40, 0x3c, 0x41, 0x42, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    
titleLoopSprite:

    .db     0x48 - 0x01, 0x72, 0x20, VDP_COLOR_DARK_RED
    .db     0x48 - 0x01, 0x82, 0x24, VDP_COLOR_DARK_RED
    .db     0x58 - 0x01, 0x6e, 0x28, VDP_COLOR_DARK_RED
    .db     0x58 - 0x01, 0x7e, 0x2c, VDP_COLOR_DARK_RED
    .db     0x40 - 0x01, 0x74, 0x30, VDP_COLOR_BLACK
    .db     0x40 - 0x01, 0x84, 0x34, VDP_COLOR_BLACK
    .db     0x50 - 0x01, 0x70, 0x38, VDP_COLOR_BLACK
    .db     0x50 - 0x01, 0x80, 0x3c, VDP_COLOR_BLACK
    .db     0x60 - 0x01, 0x6c, 0x40, VDP_COLOR_BLACK
    .db     0x60 - 0x01, 0x7c, 0x44, VDP_COLOR_BLACK


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; タイトル
;
_title::
    
    .ds     TITLE_LENGTH
