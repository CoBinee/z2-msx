; Enemy.inc : エネミー
;


; マクロの定義
;

; エネミー
ENEMY_STATE                     =   0x00
ENEMY_FLAG                      =   0x01
ENEMY_POSITION_X                =   0x02
ENEMY_POSITION_Y                =   0x03
ENEMY_POSITION_LAST_X           =   0x04
ENEMY_POSITION_LAST_Y           =   0x05
ENEMY_ACTION                    =   0x06
ENEMY_COMMAND_TYPE              =   0x07
ENEMY_COMMAND_FRAME             =   0x08
ENEMY_ANIMATION                 =   0x09
ENEMY_LENGTH                    =   0x0a

; 状態
ENEMY_STATE_NULL                =   0x00
ENEMY_STATE_ENTER               =   0x10
ENEMY_STATE_STAY                =   0x20
ENEMY_STATE_PUNCH               =   0x30

; フラグ
ENEMY_FLAG_NULL                 =   0x00

; 位置
ENEMY_POSITION_NULL             =   0x00

; アクション
ENEMY_ACTION_NULL               =   0x00
ENEMY_ACTION_ENTER              =   0x01
ENEMY_ACTION_STAY               =   0x02
ENEMY_ACTION_PUNCH              =   0x03
ENEMY_ACTION_PUNCH_HIT          =   0x04

; コマンド
ENEMY_COMMAND_TYPE_NULL         =   0x00
ENEMY_COMMAND_TYPE_DEFENSE      =   0x01
ENEMY_COMMAND_TYPE_ATTACK       =   0x02
ENEMY_COMMAND_FRAME_NULL        =   0x00

; アニメーション
ENEMY_ANIMATION_NULL            =   0x00
ENEMY_ANIMATION_ENTER           =   0x10
ENEMY_ANIMATION_PUNCH           =   0x05

; パターンネーム
ENEMY_PATTERN_NAME_OFFSET       =   0x0120
ENEMY_PATTERN_NAME_SIZE_X       =   0x05
ENEMY_PATTERN_NAME_SIZE_Y       =   0x04

; スプライト
ENEMY_SPRITE_LENGTH             =   0x05
ENEMY_SPRITE_OFFSET_X           =   0x00
ENEMY_SPRITE_OFFSET_Y           =   0x48

; 外部関数宣言
;

    .globl  _EnemyInitialize
    .globl  _EnemyUpdate
    .globl  _EnemyRender
    .globl  _EnemyActionPunch

; 外部変数宣言
;

    .globl  _enemy
