; Player.s : プレイヤ
;


; モジュール宣言
;
    .module Player

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Sound.inc"
    .include    "Game.inc"
    .include	"Player.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; プレイヤを初期化する
;
_PlayerInitialize::
    
    ; レジスタの保存
    
    ; プレイヤの初期化
    ld      hl, #playerDefault
    ld      de, #_player
    ld      bc, #PLAYER_LENGTH
    ldir

    ; 状態の設定
    ld      a, #PLAYER_STATE_ENTER
    ld      (_player + PLAYER_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; プレイヤを更新する
;
_PlayerUpdate::
    
    ; レジスタの保存

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      a, (_player + PLAYER_STATE)
    and     #0xf0
    rrca
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #playerProc
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

; プレイヤを描画する
;
_PlayerRender::

    ; レジスタの保存

    ; アクションの描画
100$:

    ; パターンネームの描画
    ld      b, #PLAYER_ACTION_NULL
    ld      a, (_player + PLAYER_POSITION_LAST_X)
    ld      c, a
    rlca
    call    nc, 110$
    ld      a, (_player + PLAYER_ACTION)
    ld      b, a
    ld      a, (_player + PLAYER_POSITION_X)
    ld      c, a
    rlca
    call    nc, 110$
    jr      119$
110$:
    ld      a, b
    ld      b, #0x00
    ld      hl, #(_patternName + PLAYER_PATTERN_NAME_OFFSET)
    add     hl, bc
    ex      de, hl
;   ld      b, #0x00
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    ld      c, a
    ld      hl, #playerActionPatternName
    add     hl, bc
    ld      bc, #PLAYER_PATTERN_NAME_SIZE_X
    ldir
    ex      de, hl
    ld      bc, #(0x0020 - PLAYER_PATTERN_NAME_SIZE_X)
    add     hl, bc
    ex      de, hl
    ld      bc, #PLAYER_PATTERN_NAME_SIZE_X
    ldir
    ex      de, hl
    ld      bc, #(0x0020 - PLAYER_PATTERN_NAME_SIZE_X)
    add     hl, bc
    ex      de, hl
    ld      bc, #PLAYER_PATTERN_NAME_SIZE_X
    ldir
    ex      de, hl
    ld      bc, #(0x0020 - PLAYER_PATTERN_NAME_SIZE_X)
    add     hl, bc
    ex      de, hl
    ld      bc, #PLAYER_PATTERN_NAME_SIZE_X
    ldir
    ex      de, hl
    ld      bc, #(0x0020 - PLAYER_PATTERN_NAME_SIZE_X)
    add     hl, bc
    ex      de, hl
    ld      bc, #PLAYER_PATTERN_NAME_SIZE_X
    ldir
    ret
119$:

    ; スプライトの描画
    ld      a, (_player + PLAYER_POSITION_X)
    rlca
    jr      c, 129$
    ld      a, (_player + PLAYER_ACTION)
    ld      b, #0x00
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    add     a, a
    rl      b
    ld      c, a
    ld      hl, #playerActionSprite
    add     hl, bc
    ld      de, #(_sprite + GAME_SPRITE_PLAYER_ACTION)
    ld      a, (_player + PLAYER_POSITION_X)
    add     a, a
    add     a, a
    add     a, a
    add     a, #PLAYER_SPRITE_OFFSET_X
    ld      c, a
    ld      a, (_player + PLAYER_POSITION_Y)
    add     a, a
    add     a, a
    add     a, a
    add     a, #PLAYER_SPRITE_OFFSET_Y
    ld      b, a
    call    120$
    call    120$
    call    120$
    call    120$
    call    120$
;   ld      de, #(_sprite + GAME_SPRITE_HIT)
    call    120$
    jr      129$
120$:
    ld      a, (hl)
    add     a, b
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    add     a, c
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    ret
129$:

    ; コマンドの描画
200$:

    ; パターンネームの描画

    ; スプライトの描画
    ld      a, (_player + PLAYER_COMMAND_TYPE)
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #playerCommandSprite
    add     hl, de
    ld      de, #(_sprite + GAME_SPRITE_PLAYER_COMMAND)
    ld      bc, #(0x0003 * 0x0004)
    ldir

    ; スプライトの描画

    ; レジスタの復帰

    ; 終了
    ret

; 何もしない
;
PlayerNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; プレイヤが登場する
;
PlayerEnter:

    ; レジスタの保存

    ; 初期化
    ld      a, (_player + PLAYER_STATE)
    and     #0x0f
    jr      nz, 09$

    ; 位置の保存
    ld      de, (_player + PLAYER_POSITION_X)
    ld      (_player + PLAYER_POSITION_LAST_X), de

    ; コマンドの設定
    ld      a, #PLAYER_COMMAND_TYPE_NULL
    ld      (_player + PLAYER_COMMAND_TYPE), a

    ; アニメーションの設定
    ld      a, #PLAYER_ANIMATION_ENTER
    ld      (_player + PLAYER_ANIMATION), a

    ; 初期化の完了
    ld      hl, #(_player + PLAYER_STATE)
    inc     (hl)
09$:

    ; アクションの設定
    ld      c, #PLAYER_ACTION_NULL
    ld      a, (_player + PLAYER_ANIMATION)
    cp      #(PLAYER_ANIMATION_ENTER - PLAYER_ANIMATION_ENTER_WAIT)
    jr      nc, 10$
    and     #0x04
    jr      z, 10$
    ld      c, #PLAYER_ACTION_ENTER
10$:
    ld      a, c
    ld      (_player + PLAYER_ACTION), a

    ; アニメーションの更新
    ld      hl, #(_player + PLAYER_ANIMATION)
    dec     (hl)
    jr      nz, 29$

    ; 状態の更新
    ld      a, #PLAYER_STATE_PLAY
    ld      (_player + PLAYER_STATE), a
;   jr      29$
29$:

    ; レジスタの復帰

    ; 終了
    ret

; プレイヤを操作する
;
PlayerPlay:

    ; レジスタの保存

    ; 初期化
    ld      a, (_player + PLAYER_STATE)
    and     #0x0f
    jr      nz, 09$

    ; 位置の保存
    ld      de, (_player + PLAYER_POSITION_X)
    ld      (_player + PLAYER_POSITION_LAST_X), de

    ; アクションの設定
    ld      a, #PLAYER_ACTION_STAY
    ld      (_player + PLAYER_ACTION), a

    ; コマンドの設定
    ld      a, #PLAYER_COMMAND_TYPE_NULL
    ld      (_player + PLAYER_COMMAND_TYPE), a

    ; プレイの開始
    ld      hl, #(_game + GAME_FLAG)
    set     #GAME_FLAG_PLAY_BIT, (hl)

    ; 初期化の完了
    ld      hl, #(_player + PLAYER_STATE)
    inc     (hl)
09$:

;   ; デバッグ
;   ld      a, (_input + INPUT_BUTTON_SHIFT)
;   or      a
;   jr      z, 10$
;   ld      a, (_app + APP_FRAME)
;   and     #0x01
;   ld      (_input + INPUT_BUTTON_SPACE), a
10$:

    ; SPACE の監視
    ld      a, (_input + INPUT_BUTTON_SPACE)

    ; SPACE が離されている
    or      a
    jr      nz, 110$
100$:

    ; アクションの設定
    ld      hl, #(_player + PLAYER_ACTION)
    ld      a, #PLAYER_ACTION_STAY
    cp      (hl)
    jr      z, 101$
    ld      (hl), a
101$:

    ; レコードの更新
    ld      hl, #(_player + PLAYER_RECORD_00)
    ld      a, (hl)
    cp      #0xff
    jr      z, 102$
    inc     (hl)
102$:
    jp      190$

    ; SPACE が押された
110$:
    dec     a
    jr      nz, 120$

    ; アクションの設定
    ld      a, (_player + PLAYER_ACTION_LAST)
    add     a, a
    ld      e, a
    ld      a, (_player + PLAYER_RECORD_00)
    cp      #PLAYER_RECORD_SPECIAL_INTERVAL
    ld      a, e
    adc     a, #0x00
    ld      e, a
    ld      d, #0x00
    ld      hl, #playerActionNext
    add     hl, de
    ld      a, (hl)
    ld      (_player + PLAYER_ACTION_LAST), a
    inc     a
    ld      (_player + PLAYER_ACTION), a

    ; コマンドの設定
    ld      hl, #(_player + PLAYER_RECORD_00)
    ld      a, (hl)
    ld      bc, #0x0400
111$:
    inc     hl
    add     a, (hl)
    jr      c, 114$
    djnz    111$
    cp      #(0x3c + 0x01)
    jr      nc, 112$
    inc     c
112$:
    ld      b, #0x05
113$:
    inc     hl
    add     a, (hl)
    jr      c, 114$
    djnz    113$
    cp      #(0x3c + 0x01)
    jr      nc, 114$
    inc     c
114$:
    ld      a, c
    add     a, #PLAYER_COMMAND_TYPE_ATTACK
    ld      c, a
    ld      (_player + PLAYER_COMMAND_TYPE), a
    ld      a, #PLAYER_COMMAND_FRAME_DELAY
    ld      (_player + PLAYER_COMMAND_FRAME), a
    ld      b, #0x00
    ld      hl, #playerCommandScore
    add     hl, bc
    ld      a, (hl)
    call    _GameAddScore
    call    PlayerPrintCommand

    ; アニメーションの設定
    ld      a, #PLAYER_ANIMATION_HIT
    ld      (_player + PLAYER_ANIMATION), a

    ; レコードの更新
    ld      hl, #(_player + PLAYER_RECORD_00 + PLAYER_RECORD_LENGTH - 0x02)
    ld      de, #(_player + PLAYER_RECORD_00 + PLAYER_RECORD_LENGTH - 0x01)
    ld      bc, #(PLAYER_RECORD_LENGTH - 0x01)
    lddr
    xor     a
    ld      (de), a
    jr      190$

    ; SPACE が押され続けている
120$:

    ; アニメーションの更新
    ld      hl, #(_player + PLAYER_ANIMATION)
    ld      a, (hl)
    or      a
    jr      z, 121$
    dec     (hl)
    jr      nz, 121$
    ld      hl, #(_player + PLAYER_ACTION)
    dec     (hl)
121$:

    ; レコードの更新
    ld      hl, #(_player + PLAYER_RECORD_00)
    ld      a, (hl)
    cp      #0xff
    jr      z, 122$
    inc     (hl)
122$:
;   jr      190$

    ; SPACE の完了
190$:

    ; コマンドの更新
    ld      hl, #(_player + PLAYER_COMMAND_FRAME)
    ld      a, (hl)
    or      a
    jr      z, 29$
    dec     (hl)
    jr      nz, 29$
    ld      (_player + PLAYER_COMMAND_TYPE), a
    call    PlayerPrintCommand
;   jr      29$
29$:

    ; レジスタの復帰

    ; 終了
    ret

; プレイヤがダウンする
;
PlayerDown:

    ; レジスタの保存

    ; 初期化
    ld      a, (_player + PLAYER_STATE)
    and     #0x0f
    jr      nz, 09$

    ; アクションの設定
    ld      a, #PLAYER_ACTION_STAY
    ld      (_player + PLAYER_ACTION), a

    ; コマンドの設定
    ld      a, #PLAYER_COMMAND_TYPE_NULL
    ld      (_player + PLAYER_COMMAND_TYPE), a
    call    PlayerPrintCommand

    ; アニメーションの設定
    ld      a, #PLAYER_ANIMATION_DOWN_DELAY
    ld      (_player + PLAYER_ANIMATION), a

    ; 初期化の完了
    ld      hl, #(_player + PLAYER_STATE)
    inc     (hl)
09$:

    ; 位置の保存
    ld      de, (_player + PLAYER_POSITION_X)
    ld      (_player + PLAYER_POSITION_LAST_X), de

    ; アニメーションの更新
    ld      hl, #(_player + PLAYER_ANIMATION)
    ld      a, (hl)
    or      a
    jr      z, 10$
    dec     (hl)
    jr      nz, 19$

    ; アクションの設定
    ld      a, #PLAYER_ACTION_DOWN
    ld      (_player + PLAYER_ACTION), a
10$:

    ; 移動
    ld      hl, #(_player + PLAYER_POSITION_X)
    ld      a, (hl)
    or      a
    jp      m, 19$
    dec     (hl)
    ld      a, (hl)
    or      a
    jp      p, 19$

    ; 結果画面へ
    ld      hl, #(_game + GAME_FLAG)
    set     #GAME_FLAG_RESULT_BIT, (hl)
;   jr      19$
19$:

    ; レジスタの復帰

    ; 終了
    ret

; プレイヤをダウンさせる
;
_PlayerActionDown::

    ; レジスタの保存

    ; 状態の更新
    ld      a, #PLAYER_STATE_DOWN
    ld      (_player + PLAYER_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; コマンドを描画する
;
PlayerPrintCommand:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; パターンネームの描画
    ld      a, (_player + PLAYER_COMMAND_TYPE)
    ld      d, #0x00
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, a
    rl      d
    ld      e, a
    ld      hl, #playerCommandPatternName
    add     hl, de
    ld      de, #(_patternName + 0x026a)
    ld      bc, #0x000c
    ldir
    ex      de, hl
    ld      bc, #(0x0020 - 0x000c)
    add     hl, bc
    ex      de, hl
    ld      bc, #0x000c
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
playerProc:
    
    .dw     PlayerNull
    .dw     PlayerEnter
    .dw     PlayerPlay
    .dw     PlayerDown

; プレイヤの初期値
;
playerDefault:

    .db     PLAYER_STATE_NULL
    .db     PLAYER_FLAG_NULL
    .db     0x0b ; PLAYER_POSITION_NULL
    .db     0x00 ; PLAYER_POSITION_NULL
    .db     PLAYER_POSITION_NULL
    .db     PLAYER_POSITION_NULL
    .db     PLAYER_ACTION_NULL
    .db     PLAYER_ACTION_NULL
    .db     PLAYER_COMMAND_TYPE_NULL
    .db     PLAYER_COMMAND_FRAME_NULL
    .db     PLAYER_ANIMATION_NULL
    .db     0x00 ; PLAYER_RECORD_NULL
    .db     0xff ; PLAYER_RECORD_NULL
    .db     0xff ; PLAYER_RECORD_NULL
    .db     0xff ; PLAYER_RECORD_NULL
    .db     0xff ; PLAYER_RECORD_NULL
    .db     0xff ; PLAYER_RECORD_NULL
    .db     0xff ; PLAYER_RECORD_NULL
    .db     0xff ; PLAYER_RECORD_NULL
    .db     0xff ; PLAYER_RECORD_NULL
    .db     0xff ; PLAYER_RECORD_NULL
    .db     0xff ; PLAYER_RECORD_NULL
    .db     0xff ; PLAYER_RECORD_NULL
    .db     0xff ; PLAYER_RECORD_NULL
    .db     0xff ; PLAYER_RECORD_NULL
    .db     0xff ; PLAYER_RECORD_NULL
    .db     0xff ; PLAYER_RECORD_NULL

; アクション
;
playerActionNext:

    .db     PLAYER_ACTION_PUNCH_LEFT,  PLAYER_ACTION_PUNCH_LEFT
    .db     PLAYER_ACTION_PUNCH_LEFT,  PLAYER_ACTION_PUNCH_LEFT
    .db     PLAYER_ACTION_PUNCH_LEFT,  PLAYER_ACTION_PUNCH_LEFT
    .db     PLAYER_ACTION_PUNCH_RIGHT, PLAYER_ACTION_PUNCH_RIGHT
    .db     PLAYER_ACTION_PUNCH_RIGHT, PLAYER_ACTION_PUNCH_RIGHT
    .db     PLAYER_ACTION_KICK_LEFT,   PLAYER_ACTION_PUNCH_LEFT
    .db     PLAYER_ACTION_KICK_LEFT,   PLAYER_ACTION_PUNCH_LEFT
    .db     PLAYER_ACTION_KICK_RIGHT,  PLAYER_ACTION_PUNCH_RIGHT
    .db     PLAYER_ACTION_KICK_RIGHT,  PLAYER_ACTION_PUNCH_RIGHT
    .db     PLAYER_ACTION_PUNCH_LEFT,  PLAYER_ACTION_PUNCH_LEFT
    .db     PLAYER_ACTION_PUNCH_LEFT,  PLAYER_ACTION_PUNCH_LEFT
    .db     PLAYER_ACTION_PUNCH_LEFT,  PLAYER_ACTION_PUNCH_LEFT

playerActionPatternName:

    ; -
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; ENTER
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; STAY
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x90, 0x91, 0x92, 0x93, 0x00
    .db     0x00, 0x94, 0x95, 0x96, 0x97
    .db     0x98, 0x99, 0x9a, 0x9b, 0x9c
    .db     0x9d, 0x9e, 0x00, 0x9f, 0xa0
    .db     0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; PUNCH LEFT
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x90, 0x91, 0x92, 0xa1, 0xa2
    .db     0x00, 0x94, 0x95, 0xa3, 0xa4
    .db     0x98, 0x99, 0x9a, 0x9b, 0x9c
    .db     0x9d, 0x9e, 0x00, 0x9f, 0xa0
    .db     0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; PUNCH LEFT HIT
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x90, 0x91, 0x92, 0xa1, 0xa2
    .db     0x00, 0x94, 0x95, 0xa3, 0xa4
    .db     0x98, 0x99, 0x9a, 0x9b, 0x9c
    .db     0x9d, 0x9e, 0x00, 0x9f, 0xa0
    .db     0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; PUNCH RIGHT
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0xa5, 0xa6, 0xa7, 0xa8
    .db     0x00, 0xa9, 0xaa, 0xab, 0xac
    .db     0x98, 0x99, 0x9a, 0x9b, 0x9c
    .db     0x9d, 0x9e, 0x00, 0x9f, 0xa0
    .db     0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; PUNCH RIGHT HIT
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0xa5, 0xa6, 0xa7, 0xa8
    .db     0x00, 0xa9, 0xaa, 0xab, 0xac
    .db     0x98, 0x99, 0x9a, 0x9b, 0x9c
    .db     0x9d, 0x9e, 0x00, 0x9f, 0xa0
    .db     0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; KICK LEFT
    .db     0x00, 0x00, 0xad, 0x00, 0x00
    .db     0xae, 0xaf, 0xb0, 0x00, 0x00
    .db     0xb1, 0xb2, 0xb3, 0xb4, 0xb5
    .db     0xb6, 0xb7, 0xb8, 0xb9, 0x00
    .db     0xba, 0xbb, 0x00, 0x00, 0x00
    .db     0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; KICK LEFT HIT
    .db     0x00, 0x00, 0xad, 0x00, 0x00
    .db     0xae, 0xaf, 0xb0, 0x00, 0x00
    .db     0xb1, 0xb2, 0xb3, 0xb4, 0xb5
    .db     0xb6, 0xb7, 0xb8, 0xb9, 0x00
    .db     0xba, 0xbb, 0x00, 0x00, 0x00
    .db     0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; KICK RIGHT
    .db     0x00, 0x00, 0xbc, 0xbd, 0x00
    .db     0xbe, 0xbf, 0xc0, 0xc1, 0x00
    .db     0xc2, 0xc3, 0xc4, 0xc5, 0xc6
    .db     0xc7, 0xc8, 0xc9, 0x00, 0x00
    .db     0xca, 0xcb, 0x00, 0x00, 0x00
    .db     0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; KICK RIGHT HIT
    .db     0x00, 0x00, 0xbc, 0xbd, 0x00
    .db     0xbe, 0xbf, 0xc0, 0xc1, 0x00
    .db     0xc2, 0xc3, 0xc4, 0xc5, 0xc6
    .db     0xc7, 0xc8, 0xc9, 0x00, 0x00
    .db     0xca, 0xcb, 0x00, 0x00, 0x00
    .db     0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; DOWN
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0xcc, 0xcd, 0xce, 0xcf
    .db     0xd0, 0xd1, 0xd2, 0xd3, 0xd4
    .db     0xd5, 0xd6, 0xd7, 0xd8, 0xd9
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff

playerActionSprite:

    ; -
    .db      0x30 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x30 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x30 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x30 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x30 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x30 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db     0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; ENTER
    .db      0x06 - 0x01, 0x04, 0xc8, VDP_COLOR_WHITE
    .db      0x06 - 0x01, 0x14, 0xcc, VDP_COLOR_WHITE
    .db      0x16 - 0x01, 0x04, 0xd0, VDP_COLOR_WHITE
    .db      0x16 - 0x01, 0x14, 0xd4, VDP_COLOR_WHITE
    .db      0x30 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x30 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; STAY
    .db     -0x03 - 0x01, 0x10, 0x60, VDP_COLOR_DARK_BLUE
    .db      0x0d - 0x01, 0x01, 0x64, VDP_COLOR_DARK_BLUE
    .db      0x10 - 0x01, 0x11, 0x68, VDP_COLOR_DARK_BLUE
    .db      0x20 - 0x01, 0x00, 0x6c, VDP_COLOR_DARK_BLUE
    .db      0x20 - 0x01, 0x18, 0x70, VDP_COLOR_DARK_BLUE
    .db      0x30 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; PUNCH LEFT
    .db     -0x03 - 0x01, 0x10, 0x74, VDP_COLOR_DARK_BLUE
    .db      0x0d - 0x01, 0x01, 0x64, VDP_COLOR_DARK_BLUE
    .db      0x10 - 0x01, 0x11, 0x78, VDP_COLOR_DARK_BLUE
    .db      0x20 - 0x01, 0x00, 0x6c, VDP_COLOR_DARK_BLUE
    .db      0x20 - 0x01, 0x18, 0x70, VDP_COLOR_DARK_BLUE
    .db     -0x03 - 0x01, 0x20, 0x7c, VDP_COLOR_LIGHT_RED
    .db      0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; PUNCH LEFT HIT
    .db     -0x03 - 0x01, 0x10, 0x74, VDP_COLOR_DARK_BLUE
    .db      0x0d - 0x01, 0x01, 0x64, VDP_COLOR_DARK_BLUE
    .db      0x10 - 0x01, 0x11, 0x78, VDP_COLOR_DARK_BLUE
    .db      0x20 - 0x01, 0x00, 0x6c, VDP_COLOR_DARK_BLUE
    .db      0x20 - 0x01, 0x18, 0x70, VDP_COLOR_DARK_BLUE
    .db      0x00 - 0x01, 0x28, 0xfc, VDP_COLOR_LIGHT_YELLOW
    .db      0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; PUNCH RIGHT
    .db     -0x06 - 0x01, 0x11, 0x80, VDP_COLOR_DARK_BLUE
    .db      0x02 - 0x01, 0x01, 0x84, VDP_COLOR_DARK_BLUE
    .db      0x12 - 0x01, 0x10, 0x88, VDP_COLOR_DARK_BLUE
    .db      0x20 - 0x01, 0x00, 0x6c, VDP_COLOR_DARK_BLUE
    .db      0x20 - 0x01, 0x18, 0x70, VDP_COLOR_DARK_BLUE
    .db      0x0a - 0x01, 0x20, 0x8c, VDP_COLOR_LIGHT_RED
    .db      0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; PUNCH RIGHT HIT
    .db     -0x06 - 0x01, 0x11, 0x80, VDP_COLOR_DARK_BLUE
    .db      0x02 - 0x01, 0x01, 0x84, VDP_COLOR_DARK_BLUE
    .db      0x12 - 0x01, 0x10, 0x88, VDP_COLOR_DARK_BLUE
    .db      0x20 - 0x01, 0x00, 0x6c, VDP_COLOR_DARK_BLUE
    .db      0x20 - 0x01, 0x18, 0x70, VDP_COLOR_DARK_BLUE
    .db      0x05 - 0x01, 0x28, 0xfc, VDP_COLOR_LIGHT_YELLOW
    .db      0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; KICK LEFT
    .db      0x00 - 0x01, 0x00, 0x90, VDP_COLOR_DARK_BLUE
    .db      0x00 - 0x01, 0x10, 0x94, VDP_COLOR_DARK_BLUE
    .db      0x10 - 0x01, 0x04, 0x98, VDP_COLOR_DARK_BLUE
    .db      0x20 - 0x01, 0x00, 0x9c, VDP_COLOR_DARK_BLUE
    .db      0x30 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x10 - 0x01, 0x20, 0xa0, VDP_COLOR_DARK_BLUE
    .db      0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; KICK LEFT HIT
    .db      0x00 - 0x01, 0x00, 0x90, VDP_COLOR_DARK_BLUE
    .db      0x00 - 0x01, 0x10, 0x94, VDP_COLOR_DARK_BLUE
    .db      0x10 - 0x01, 0x04, 0x98, VDP_COLOR_DARK_BLUE
    .db      0x20 - 0x01, 0x00, 0x9c, VDP_COLOR_DARK_BLUE
    .db      0x30 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x0c - 0x01, 0x28, 0xfc, VDP_COLOR_LIGHT_YELLOW
    .db      0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; KICK RIGHT
    .db      0x00 - 0x01, 0x00, 0xa4, VDP_COLOR_DARK_BLUE
    .db      0x00 - 0x01, 0x10, 0xa8, VDP_COLOR_DARK_BLUE
    .db      0x10 - 0x01, 0x08, 0xac, VDP_COLOR_DARK_BLUE
    .db      0x20 - 0x01, 0x00, 0xb0, VDP_COLOR_DARK_BLUE
    .db      0x30 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x10 - 0x01, 0x20, 0xb4, VDP_COLOR_DARK_BLUE
    .db      0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; KICK RIGHT
    .db      0x00 - 0x01, 0x00, 0xa4, VDP_COLOR_DARK_BLUE
    .db      0x00 - 0x01, 0x10, 0xa8, VDP_COLOR_DARK_BLUE
    .db      0x10 - 0x01, 0x08, 0xac, VDP_COLOR_DARK_BLUE
    .db      0x20 - 0x01, 0x00, 0xb0, VDP_COLOR_DARK_BLUE
    .db      0x30 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x0d - 0x01, 0x28, 0xfc, VDP_COLOR_LIGHT_YELLOW
    .db      0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    ; DOWN
    .db      0x08 - 0x01, 0x00, 0xb8, VDP_COLOR_DARK_BLUE
    .db      0x08 - 0x01, 0x10, 0xbc, VDP_COLOR_DARK_BLUE
    .db      0x18 - 0x01, 0x08, 0xc0, VDP_COLOR_DARK_BLUE
    .db      0x18 - 0x01, 0x18, 0xc4, VDP_COLOR_DARK_BLUE
    .db      0x30 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x30 - 0x01, 0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff

; コマンド
;
playerCommandScore:

    .db     0x00
    .db     0x00
    .db     0x01
    .db     0x05
    .db     0x0a
    
playerCommandPatternName:

    ; -
    .db     0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
    .db     0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ; 防御
    .db     0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
    .db     0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ; 攻撃
    .db     0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
    .db     0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ; 狼牙風風拳
    .db     0x40, 0x48, 0x49, 0x4c, 0x4d, 0x50, 0x51, 0x50, 0x51, 0x54, 0x55, 0x40
    .db     0x40, 0x4a, 0x4b, 0x4e, 0x4f, 0x52, 0x53, 0x52, 0x53, 0x56, 0x57, 0x40
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ; 新狼牙風風拳
    .db     0x44, 0x45, 0x48, 0x49, 0x4c, 0x4d, 0x50, 0x51, 0x50, 0x51, 0x54, 0x55
    .db     0x46, 0x47, 0x4a, 0x4b, 0x4e, 0x4f, 0x52, 0x53, 0x52, 0x53, 0x56, 0x57
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

playerCommandSprite:

    ; -
    .db     0x88 - 0x01, 0x28, 0x24, VDP_COLOR_DARK_RED
    .db     0xa8 - 0x01, 0x38, 0x30, VDP_COLOR_DARK_RED
    .db     0x98 - 0x01, 0x30, 0x40, VDP_COLOR_LIGHT_YELLOW
    .db     0xff, 0xff, 0xff, 0xff
    ; 防御
    .db     0x88 - 0x01, 0x28, 0x24, VDP_COLOR_DARK_RED
    .db     0xa8 - 0x01, 0x38, 0x30, VDP_COLOR_DARK_RED
    .db     0x98 - 0x01, 0x30, 0x48, VDP_COLOR_LIGHT_YELLOW
    .db     0xff, 0xff, 0xff, 0xff
    ; 攻撃
    .db     0x88 - 0x01, 0x28, 0x24, VDP_COLOR_DARK_RED
    .db     0xa8 - 0x01, 0x38, 0x30, VDP_COLOR_DARK_RED
    .db     0x98 - 0x01, 0x30, 0x44, VDP_COLOR_LIGHT_YELLOW
    .db     0xff, 0xff, 0xff, 0xff
    ; 狼牙風風拳
    .db     0x88 - 0x01, 0x28, 0x28, VDP_COLOR_DARK_RED
    .db     0xa8 - 0x01, 0x38, 0x34, VDP_COLOR_DARK_RED
    .db     0x98 - 0x01, 0x30, 0x4c, VDP_COLOR_LIGHT_YELLOW
    .db     0xff, 0xff, 0xff, 0xff
    ; 新狼牙風風拳
    .db     0x88 - 0x01, 0x28, 0x2c, VDP_COLOR_DARK_RED
    .db     0xa8 - 0x01, 0x38, 0x38, VDP_COLOR_DARK_RED
    .db     0x98 - 0x01, 0x30, 0x4c, VDP_COLOR_LIGHT_YELLOW
    .db     0xff, 0xff, 0xff, 0xff


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; プレイヤ
;
_player::
    
    .ds     PLAYER_LENGTH
