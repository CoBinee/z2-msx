; Enemy.s : エネミー
;


; モジュール宣言
;
    .module Enemy

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Sound.inc"
    .include    "Game.inc"
    .include	"Enemy.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; エネミーを初期化する
;
_EnemyInitialize::
    
    ; レジスタの保存
    
    ; エネミーの初期化
    ld      hl, #enemyDefault
    ld      de, #_enemy
    ld      bc, #ENEMY_LENGTH
    ldir

    ; 状態の設定
    ld      a, #ENEMY_STATE_ENTER
    ld      (_enemy + ENEMY_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; エネミーを更新する
;
_EnemyUpdate::
    
    ; レジスタの保存

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      a, (_enemy + ENEMY_STATE)
    and     #0xf0
    rrca
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #enemyProc
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

; エネミーを描画する
;
_EnemyRender::

    ; レジスタの保存

    ; アクションの描画
100$:

    ; パターンネームの描画
    ld      a, (_enemy + ENEMY_POSITION_LAST_X)
    ld      c, a
    ld      b, #ENEMY_ACTION_NULL
    call    110$
    ld      a, (_enemy + ENEMY_POSITION_X)
    ld      c, a
    ld      a, (_enemy + ENEMY_ACTION)
    ld      b, a
    call    110$
    jr      119$
110$:
    ld      a, b
    ld      b, #0x00
    ld      hl, #(_patternName + ENEMY_PATTERN_NAME_OFFSET)
    add     hl, bc
    ex      de, hl
    ld      c, a
    add     a, a
    add     a, a
    ld      c, a
    add     a, a
    add     a, a
    add     a, c
    ld      c, a
;   ld      b, #0x00
    ld      hl, #enemyPatternName
    add     hl, bc
    ld      bc, #ENEMY_PATTERN_NAME_SIZE_X
    ldir
    ex      de, hl
    ld      bc, #(0x0020 - ENEMY_PATTERN_NAME_SIZE_X)
    add     hl, bc
    ex      de, hl
    ld      bc, #ENEMY_PATTERN_NAME_SIZE_X
    ldir
    ex      de, hl
    ld      bc, #(0x0020 - ENEMY_PATTERN_NAME_SIZE_X)
    add     hl, bc
    ex      de, hl
    ld      bc, #ENEMY_PATTERN_NAME_SIZE_X
    ldir
    ex      de, hl
    ld      bc, #(0x0020 - ENEMY_PATTERN_NAME_SIZE_X)
    add     hl, bc
    ex      de, hl
    ld      bc, #ENEMY_PATTERN_NAME_SIZE_X
    ldir
    ret
119$:

    ; スプライトの描画
    ld      a, (_enemy + ENEMY_ACTION)
    add     a, a
    add     a, a
    ld      c, a
    add     a, a
    add     a, a
    add     a, c
    ld      c, a
    ld      b, #0x00
    ld      hl, #enemySprite
    add     hl, bc
    ld      de, #(_sprite + GAME_SPRITE_ENEMY_ACTION)
    ld      a, (_enemy + ENEMY_POSITION_X)
    add     a, a
    add     a, a
    add     a, a
    add     a, #ENEMY_SPRITE_OFFSET_X
    ld      c, a
    ld      a, (_enemy + ENEMY_POSITION_Y)
    add     a, a
    add     a, a
    add     a, a
    add     a, #ENEMY_SPRITE_OFFSET_Y
    ld      b, a
    call    120$
    call    120$
    call    120$
    call    120$
    ld      de, #(_sprite + GAME_SPRITE_HIT)
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
    ld      a, (_enemy + ENEMY_COMMAND_TYPE)
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #enemyCommandSprite
    add     hl, de
    ld      de, #(_sprite + GAME_SPRITE_ENEMY_COMMAND)
    ld      bc, #(0x0003 * 0x0004)
    ldir

    ; レジスタの復帰

    ; 終了
    ret

; 何もしない
;
EnemyNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; エネミーが登場する
;
EnemyEnter:

    ; レジスタの保存

    ; 初期化
    ld      a, (_enemy + ENEMY_STATE)
    and     #0x0f
    jr      nz, 09$

    ; 位置の保存
    ld      de, (_enemy + ENEMY_POSITION_X)
    ld      (_enemy + ENEMY_POSITION_LAST_X), de

    ; コマンドの設定
    ld      a, #ENEMY_COMMAND_TYPE_NULL
    ld      (_enemy + ENEMY_COMMAND_TYPE), a

    ; アニメーションの設定
    ld      a, #ENEMY_ANIMATION_ENTER
    ld      (_enemy + ENEMY_ANIMATION), a

    ; 初期化の完了
    ld      hl, #(_enemy + ENEMY_STATE)
    inc     (hl)
09$:

    ; アクションの設定
    ld      c, #ENEMY_ACTION_NULL
    ld      a, (_enemy + ENEMY_ANIMATION)
    and     #0x04
    jr      z, 10$
    ld      c, #ENEMY_ACTION_ENTER
10$:
    ld      a, c
    ld      (_enemy + ENEMY_ACTION), a

    ; アニメーションの更新
    ld      hl, #(_enemy + ENEMY_ANIMATION)
    dec     (hl)
    jr      nz, 29$

    ; 状態の更新
    ld      a, #ENEMY_STATE_STAY
    ld      (_enemy + ENEMY_STATE), a
;   jr      29$
29$:

    ; レジスタの復帰

    ; 終了
    ret

; エネミーが待機する
;
EnemyStay:

    ; レジスタの保存

    ; 初期化
    ld      a, (_enemy + ENEMY_STATE)
    and     #0x0f
    jr      nz, 09$

    ; 位置の保存
    ld      de, (_enemy + ENEMY_POSITION_X)
    ld      (_enemy + ENEMY_POSITION_LAST_X), de

    ; アクションの設定
    ld      a, #ENEMY_ACTION_STAY
    ld      (_enemy + ENEMY_ACTION), a

    ; コマンドの設定
    ld      a, #ENEMY_COMMAND_TYPE_DEFENSE
    ld      (_enemy + ENEMY_COMMAND_TYPE), a

    ; 初期化の完了
    ld      hl, #(_enemy + ENEMY_STATE)
    inc     (hl)
09$:

    ; レジスタの復帰

    ; 終了
    ret

; エネミーがパンチする
;
EnemyPunch:

    ; レジスタの保存

    ; 初期化
    ld      a, (_enemy + ENEMY_STATE)
    and     #0x0f
    jr      nz, 09$

    ; 位置の保存
    ld      de, (_enemy + ENEMY_POSITION_X)
    ld      (_enemy + ENEMY_POSITION_LAST_X), de

    ; コマンドの設定
    ld      a, #ENEMY_COMMAND_TYPE_ATTACK
    ld      (_enemy + ENEMY_COMMAND_TYPE), a

    ; アニメーションの設定
    ld      a, #ENEMY_ANIMATION_PUNCH
    ld      (_enemy + ENEMY_ANIMATION), a

    ; SE の再生
    ld      a, #SOUND_SE_HIT
    call    _SoundPlaySe

    ; 初期化の完了
    ld      hl, #(_enemy + ENEMY_STATE)
    inc     (hl)
09$:

    ; アクションの設定
    ld      a, (_enemy + ENEMY_ANIMATION)
    cp      #(ENEMY_ANIMATION_PUNCH - 0x02)
    ld      a, #ENEMY_ACTION_PUNCH
    jr      c, 10$
    ld      a, #ENEMY_ACTION_PUNCH_HIT
10$:
    ld      (_enemy + ENEMY_ACTION), a

    ; アニメーションの更新
    ld      hl, #(_enemy + ENEMY_ANIMATION)
    dec     (hl)
    jr      nz, 29$

    ; 状態の更新
    ld      a, #ENEMY_STATE_STAY
    ld      (_enemy + ENEMY_STATE), a
;   jr      29$
29$:

    ; レジスタの復帰

    ; 終了
    ret

; エネミーにパンチさせる
;
_EnemyActionPunch::

    ; レジスタの保存

    ; 状態の更新
    ld      a, #ENEMY_STATE_PUNCH
    ld      (_enemy + ENEMY_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; 状態別の処理
;
enemyProc:
    
    .dw     EnemyNull
    .dw     EnemyEnter
    .dw     EnemyStay
    .dw     EnemyPunch

; エネミーの初期値
;
enemyDefault:

    .db     ENEMY_STATE_NULL
    .db     ENEMY_FLAG_NULL
    .db     0x10 ; ENEMY_POSITION_NULL
    .db     0x00 ; ENEMY_POSITION_NULL
    .db     ENEMY_POSITION_NULL
    .db     ENEMY_POSITION_NULL
    .db     ENEMY_ACTION_NULL
    .db     ENEMY_COMMAND_TYPE_NULL
    .db     ENEMY_COMMAND_FRAME_NULL
    .db     ENEMY_ANIMATION_NULL

; パターンネーム
;
enemyPatternName:

    ; -
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    ; ENTER
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00
    ; STAY
    .db     0xe0, 0xe1, 0xe2, 0xe3, 0xfa
    .db     0xe4, 0xe5, 0xe6, 0xe7, 0xfb
    .db     0xf0, 0xf1, 0xf2, 0xf3, 0xf4
    .db     0xf5, 0xf6, 0xf7, 0xf8, 0xf9
    ; PUNCH
    .db     0xe8, 0xe9, 0xea, 0xeb, 0xfa
    .db     0xec, 0xed, 0xee, 0xef, 0xfb
    .db     0xf0, 0xf1, 0xf2, 0xf3, 0xf4
    .db     0xf5, 0xf6, 0xf7, 0xf8, 0xf9
    ; PUNCH HIT
    .db     0xe8, 0xe9, 0xea, 0xeb, 0xfa
    .db     0xec, 0xed, 0xee, 0xef, 0xfb
    .db     0xf0, 0xf1, 0xf2, 0xf3, 0xf4
    .db     0xf5, 0xf6, 0xf7, 0xf8, 0xf9

; スプライト
;
enemySprite:

    ; -
    .db      0x20 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x20 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x20 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x20 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    .db      0x20 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    ; ENTER
    .db      0x00 - 0x01,  0x02, 0xc8, VDP_COLOR_WHITE
    .db      0x00 - 0x01,  0x12, 0xcc, VDP_COLOR_WHITE
    .db      0x10 - 0x01,  0x02, 0xd0, VDP_COLOR_WHITE
    .db      0x10 - 0x01,  0x12, 0xd4, VDP_COLOR_WHITE
    .db      0x20 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    ; STAY
    .db      0x00 - 0x01,  0x00, 0xe0, VDP_COLOR_MAGENTA
    .db      0x00 - 0x01,  0x10, 0xe4, VDP_COLOR_MAGENTA
    .db      0x17 - 0x01,  0x00, 0xe8, VDP_COLOR_MAGENTA
    .db      0x18 - 0x01,  0x10, 0xec, VDP_COLOR_MAGENTA
    .db      0x20 - 0x01,  0x00, 0x00, VDP_COLOR_TRANSPARENT
    ; PUNCH
    .db     -0x08 - 0x01,  0x07, 0xf4, VDP_COLOR_MAGENTA
    .db      0x08 - 0x01,  0x0f, 0xf8, VDP_COLOR_MAGENTA
    .db      0x17 - 0x01,  0x00, 0xe8, VDP_COLOR_MAGENTA
    .db      0x18 - 0x01,  0x10, 0xec, VDP_COLOR_MAGENTA
    .db     -0x08 - 0x01, -0x10, 0xf0, VDP_COLOR_WHITE
    ; PUNCH HIT
    .db     -0x08 - 0x01,  0x07, 0xf4, VDP_COLOR_MAGENTA
    .db      0x08 - 0x01,  0x0f, 0xf8, VDP_COLOR_MAGENTA
    .db      0x17 - 0x01,  0x00, 0xe8, VDP_COLOR_MAGENTA
    .db      0x18 - 0x01,  0x10, 0xec, VDP_COLOR_MAGENTA
    .db     -0x03 - 0x01, -0x10, 0xfc, VDP_COLOR_LIGHT_YELLOW

; コマンド
;
enemyCommandSprite:

    ; -
    .db     0x88 - 0x01, 0xb8, 0x3c, VDP_COLOR_DARK_RED
    .db     0xa8 - 0x01, 0xc8, 0x3c, VDP_COLOR_DARK_RED
    .db     0x98 - 0x01, 0xc0, 0x40, VDP_COLOR_LIGHT_YELLOW
    .db     0xff, 0xff, 0xff, 0xff
    ; 防御
    .db     0x88 - 0x01, 0xb8, 0x3c, VDP_COLOR_DARK_RED
    .db     0xa8 - 0x01, 0xc8, 0x3c, VDP_COLOR_DARK_RED
    .db     0x98 - 0x01, 0xc0, 0x48, VDP_COLOR_LIGHT_YELLOW
    .db     0xff, 0xff, 0xff, 0xff
    ; 攻撃
    .db     0x88 - 0x01, 0xb8, 0x3c, VDP_COLOR_DARK_RED
    .db     0xa8 - 0x01, 0xc8, 0x3c, VDP_COLOR_DARK_RED
    .db     0x98 - 0x01, 0xc0, 0x44, VDP_COLOR_LIGHT_YELLOW
    .db     0xff, 0xff, 0xff, 0xff


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; エネミー
;
_enemy::
    
    .ds     ENEMY_LENGTH
