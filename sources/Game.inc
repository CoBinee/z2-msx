; Game.inc : ゲーム
;


; マクロの定義
;

; スプライト
GAME_SPRITE_NULL                =   0x00
GAME_SPRITE_HIT                 =   0x00
GAME_SPRITE_PLAYER_ACTION       =   0x04
GAME_SPRITE_PLAYER_COMMAND      =   0x48
GAME_SPRITE_ENEMY_ACTION        =   0x1c
GAME_SPRITE_ENEMY_COMMAND       =   0x54
GAME_SPRITE_SCOUTER             =   0x30

; ゲーム
GAME_STATE                      =   0x00
GAME_FLAG                       =   0x01
GAME_FRAME                      =   0x02
GAME_CLASS                      =   0x03
GAME_SCORE_L                    =   0x04
GAME_SCORE_H                    =   0x05
GAME_SCORE_10000                =   0x06
GAME_SCORE_01000                =   0x07
GAME_SCORE_00100                =   0x08
GAME_SCORE_00010                =   0x09
GAME_SCORE_00001                =   0x0a
GAME_TIMER_10_0                 =   0x0b
GAME_TIMER_01_0                 =   0x0c
GAME_TIMER_00_1                 =   0x0d
GAME_LENGTH                     =   0x0e

; 状態
GAME_STATE_NULL                 =   0x00
GAME_STATE_START                =   0x10
GAME_STATE_ENTER                =   0x20
GAME_STATE_PLAY                 =   0x30
GAME_STATE_OVER                 =   0x40
GAME_STATE_RESULT               =   0x50

; フラグ
GAME_FLAG_NULL                  =   0x00
GAME_FLAG_PLAY_BIT              =   0x00
GAME_FLAG_PLAY                  =   (1 << GAME_FLAG_PLAY_BIT)
GAME_FLAG_RESULT_BIT            =   0x01
GAME_FLAG_RESULT                =   (1 << GAME_FLAG_RESULT_BIT)
GAME_FLAG_SCORE_TOP_BIT         =   0x02
GAME_FLAG_SCORE_TOP             =   (1 << GAME_FLAG_SCORE_TOP_BIT)

; フレーム
GAME_FRAME_NULL                 =   0x00

; クラス
GAME_CLASS_NULL                 =   0x00
GAME_CLASS_CHAOZU               =   0x01
GAME_CLASS_YAJIROBE             =   0x02
GAME_CLASS_MR_POPO              =   0x03
GAME_CLASS_YAMCHA               =   0x04
GAME_CLASS_KRILLIN              =   0x05
GAME_CLASS_TENSHINHAN           =   0x06
GAME_CLASS_GOHAN                =   0x07
GAME_CLASS_PICCOLO              =   0x08
GAME_CLASS_GOKU                 =   0x09
GAME_CLASS_LENGTH               =   0x0a

; スコア
GAME_SCORE_NULL                 =   0x00

; タイマ
GAME_TIMER_NULL                 =   0x00

; 外部関数宣言
;

    .globl  _GameInitialize
    .globl  _GameUpdate
    .globl  _GameAddScore

; 外部変数宣言
;

    .globl  _game
