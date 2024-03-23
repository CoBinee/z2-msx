; Field.inc : フィールド
;


; マクロの定義
;

; フィールド
FIELD_STATE                     =   0x00
FIELD_FLAG                      =   0x01
FIELD_SCROLL                    =   0x02
FIELD_SPEED                     =   0x03
FIELD_LENGTH                    =   0x04

; 状態
FIELD_STATE_NULL                =   0x00
FIELD_STATE_STAY                =   0x10
FIELD_STATE_RIGHT               =   0x20
FIELD_STATE_LEFT                =   0x30

; フラグ
FIELD_FLAG_NULL                 =   0x00
FIELD_FLAG_PRINT_SCREEN_BIT     =   0x00
FIELD_FLAG_PRINT_SCREEN         =   (1 << FIELD_FLAG_PRINT_SCREEN_BIT)

; スクロール
FIELD_SCROLL_NULL               =   0x00

; 速度
FIELD_SPEED_NULL                =   0x00
FIELD_SPEED_RIGHT               =   0x04
FIELD_SPEED_LEFT                =   0x01

; 外部関数宣言
;

    .globl  _FieldInitialize
    .globl  _FieldUpdate
    .globl  _FieldRender
    .globl  _FieldScrollRight
    .globl  _FieldScrollLeft

; 外部変数宣言
;

    .globl  _field
