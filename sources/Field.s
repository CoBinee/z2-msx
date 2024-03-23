; Field.s : フィールド
;


; モジュール宣言
;
    .module Field

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Sound.inc"
    .include    "Game.inc"
    .include	"Field.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; フィールドを初期化する
;
_FieldInitialize::
    
    ; レジスタの保存
    
    ; フィールドの初期化
    ld      hl, #fieldDefault
    ld      de, #_field
    ld      bc, #FIELD_LENGTH
    ldir

    ; 状態の設定
    ld      a, #FIELD_STATE_STAY
    ld      (_field + FIELD_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; フィールドを更新する
;
_FieldUpdate::
    
    ; レジスタの保存

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      a, (_field + FIELD_STATE)
    and     #0xf0
    rrca
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #fieldProc
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

; フィールドを描画する
;
_FieldRender::

    ; レジスタの保存

    ; 画面の描画
    ld      hl, #(_field + FIELD_FLAG)
    bit     #FIELD_FLAG_PRINT_SCREEN_BIT, (hl)
    jr      z, 10$
    call    FieldPrintScreen
    res     #FIELD_FLAG_PRINT_SCREEN_BIT, (hl)
10$:

    ; パターンネームの描画
    ld      a, (_field + FIELD_SCROLL)
    and     #0x1f
    ld      e, a
    ld      d, #0x00
    ld      hl, #fieldPatternName
    add     hl, de
    ld      de, #(_patternName + 0x01a0)
    ld      bc, #0x0020
    ldir

    ; レジスタの復帰

    ; 終了
    ret

; 何もしない
;
FieldNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; フィールドが停止する
;
FieldStay:

    ; レジスタの保存

    ; 初期化
    ld      a, (_field + FIELD_STATE)
    and     #0x0f
    jr      nz, 09$

    ; 初期化の完了
    ld      hl, #(_field + FIELD_STATE)
    inc     (hl)
09$:

    ; レジスタの復帰

    ; 終了
    ret

; フィールドを右にスクロールする
;
FieldRight:

    ; レジスタの保存

    ; 初期化
    ld      a, (_field + FIELD_STATE)
    and     #0x0f
    jr      nz, 09$

    ; 初期化の完了
    ld      hl, #(_field + FIELD_STATE)
    inc     (hl)
09$:

    ; スクロールの更新
    ld      hl, #(_field + FIELD_SPEED)
    inc     (hl)
    ld      a, (hl)
    cp      #FIELD_SPEED_RIGHT
    jr      c, 19$
    xor     a
    ld      (hl), a
    ld      hl, #(_field + FIELD_SCROLL)
    inc     (hl)
19$:

    ; レジスタの復帰

    ; 終了
    ret

; フィールドを左にスクロールする
;
FieldLeft:

    ; レジスタの保存

    ; 初期化
    ld      a, (_field + FIELD_STATE)
    and     #0x0f
    jr      nz, 09$

    ; 初期化の完了
    ld      hl, #(_field + FIELD_STATE)
    inc     (hl)
09$:

    ; スクロールの更新
    ld      hl, #(_field + FIELD_SPEED)
    inc     (hl)
    ld      a, (hl)
    cp      #FIELD_SPEED_LEFT
    jr      c, 19$
    xor     a
    ld      (hl), a
    ld      hl, #(_field + FIELD_SCROLL)
    dec     (hl)
19$:

    ; レジスタの復帰

    ; 終了
    ret

; フィールドを右にスクロールさせる
;
_FieldScrollRight::

    ; レジスタの保存

    ; 状態の更新
    ld      a, #FIELD_STATE_RIGHT
    ld      (_field + FIELD_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; フィールドを左にスクロールさせる
;
_FieldScrollLeft::

    ; レジスタの保存

    ; 状態の更新
    ld      a, #FIELD_STATE_LEFT
    ld      (_field + FIELD_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; フィールド画面を描画する
;
FieldPrintScreen:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; 画面の描画
    ld      hl, #(_patternName + 0x0100)
    ld      de, #(_patternName + 0x0101)
    ld      bc, #(0x00c0 - 0x0001)
    ld      (hl), #0x00
    ldir
    inc     hl
    inc     de
    ld      bc, #(0x0020 - 0x0001)
    ld      (hl), #0x80
    ldir
    inc     hl
    inc     de
    ld      bc, #(0x0020 - 0x0001)
    ld      (hl), #0x88
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
fieldProc:
    
    .dw     FieldNull
    .dw     FieldStay
    .dw     FieldRight
    .dw     FieldLeft

; フィールドの初期値
;
fieldDefault:

    .db     FIELD_STATE_NULL
    .db     FIELD_FLAG_PRINT_SCREEN
    .db     FIELD_SCROLL_NULL
    .db     FIELD_SPEED_NULL

; パターンネーム
;
fieldPatternName:

    .db     0x00, 0x00, 0x00, 0x00, 0xfe, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xfe, 0xff, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xfe, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0xfe, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xfe, 0xff, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xfe, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; フィールド
;
_field::
    
    .ds     FIELD_LENGTH
