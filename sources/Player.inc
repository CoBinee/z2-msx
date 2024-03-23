; Player.inc : プレイヤ
;


; マクロの定義
;

; プレイヤ
PLAYER_STATE                    =   0x00
PLAYER_FLAG                     =   0x01
PLAYER_POSITION_X               =   0x02
PLAYER_POSITION_Y               =   0x03
PLAYER_POSITION_LAST_X          =   0x04
PLAYER_POSITION_LAST_Y          =   0x05
PLAYER_ACTION                   =   0x06
PLAYER_ACTION_LAST              =   0x07
PLAYER_COMMAND_TYPE             =   0x08
PLAYER_COMMAND_FRAME            =   0x09
PLAYER_ANIMATION                =   0x0a
PLAYER_RECORD_00                =   0x0b
PLAYER_RECORD_01                =   0x0c
PLAYER_RECORD_02                =   0x0d
PLAYER_RECORD_03                =   0x0e
PLAYER_RECORD_04                =   0x0f
PLAYER_RECORD_05                =   0x10
PLAYER_RECORD_06                =   0x11
PLAYER_RECORD_07                =   0x12
PLAYER_RECORD_08                =   0x13
PLAYER_RECORD_09                =   0x14
PLAYER_RECORD_10                =   0x15
PLAYER_RECORD_11                =   0x16
PLAYER_RECORD_12                =   0x17
PLAYER_RECORD_13                =   0x18
PLAYER_RECORD_14                =   0x19
PLAYER_RECORD_15                =   0x1a
PLAYER_LENGTH                   =   0x1b

; 状態
PLAYER_STATE_NULL               =   0x00
PLAYER_STATE_ENTER              =   0x10
PLAYER_STATE_PLAY               =   0x20
PLAYER_STATE_DOWN               =   0x30

; フラグ
PLAYER_FLAG_NULL                =   0x00

; 位置
PLAYER_POSITION_NULL            =   0x00

; アクション
PLAYER_ACTION_NULL              =   0x00
PLAYER_ACTION_ENTER             =   0x01
PLAYER_ACTION_STAY              =   0x02
PLAYER_ACTION_PUNCH_LEFT        =   0x03
PLAYER_ACTION_PUNCH_LEFT_HIT    =   0x04
PLAYER_ACTION_PUNCH_RIGHT       =   0x05
PLAYER_ACTION_PUNCH_RIGHT_HIT   =   0x06
PLAYER_ACTION_KICK_LEFT         =   0x07
PLAYER_ACTION_KICK_LEFT_HIT     =   0x08
PLAYER_ACTION_KICK_RIGHT        =   0x09
PLAYER_ACTION_KICK_RIGHT_HIT    =   0x0a
PLAYER_ACTION_DOWN              =   0x0b

; コマンド
PLAYER_COMMAND_TYPE_NULL        =   0x00
PLAYER_COMMAND_TYPE_DEFENSE     =   0x01
PLAYER_COMMAND_TYPE_ATTACK      =   0x02
PLAYER_COMMAND_TYPE_SPECIAL_0   =   0x03
PLAYER_COMMAND_TYPE_SPECIAL_1   =   0x04
PLAYER_COMMAND_FRAME_NULL       =   0x00
PLAYER_COMMAND_FRAME_DELAY      =   0x0c

; アニメーション
PLAYER_ANIMATION_NULL           =   0x00
PLAYER_ANIMATION_ENTER          =   0x20
PLAYER_ANIMATION_ENTER_WAIT     =   (PLAYER_ANIMATION_ENTER - 0x10)
PLAYER_ANIMATION_HIT            =   0x02
PLAYER_ANIMATION_DOWN_DELAY     =   0x03

; レコード
PLAYER_RECORD_NULL              =   0x00
PLAYER_RECORD_LENGTH            =   0x10
PLAYER_RECORD_SPECIAL_INTERVAL  =   0x06

; パターンネーム
PLAYER_PATTERN_NAME_OFFSET      =   0x0100
PLAYER_PATTERN_NAME_SIZE_X      =   0x05
PLAYER_PATTERN_NAME_SIZE_Y      =   0x05

; スプライト
PLAYER_SPRITE_LENGTH            =   0x06
PLAYER_SPRITE_OFFSET_X          =   0x00
PLAYER_SPRITE_OFFSET_Y          =   0x40

; 外部関数宣言
;

    .globl  _PlayerInitialize
    .globl  _PlayerUpdate
    .globl  _PlayerRender
    .globl  _PlayerActionDown

; 外部変数宣言
;

    .globl  _player
