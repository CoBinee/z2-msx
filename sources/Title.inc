; Title.inc : タイトル
;


; マクロの定義
;

; スプライト
TITLE_SPRITE_NULL               =   0x00

; タイトル
TITLE_STATE                     =   0x00
TITLE_FLAG                      =   0x01
TITLE_FRAME                     =   0x02
TITLE_BLINK                     =   0x03
TITLE_ANIMATION                 =   0x04
TITLE_LENGTH                    =   0x05

; 状態
TITLE_STATE_NULL                =   0x00
TITLE_STATE_BEGIN               =   0x10
TITLE_STATE_LOOP                =   0x20
TITLE_STATE_END                 =   0x30

; フラグ
TITLE_FLAG_NULL                 =   0x00
TITLE_FLAG_PRINT_BIT            =   0x00
TITLE_FLAG_PRINT                =   (1 << TITLE_FLAG_PRINT_BIT)

; フレーム
TITLE_FRAME_NULL                =   0x00

; 点滅
TITLE_BLINK_NULL                =   0x00

; アニメーション
TITLE_ANIMATION_NULL            =   0x00

; 外部関数宣言
;

    .globl  _TitleInitialize
    .globl  _TitleUpdate

; 外部変数宣言
;

    .globl  _title
