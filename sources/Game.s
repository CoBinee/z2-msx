; Game.s : ゲーム
;


; モジュール宣言
;
    .module Game

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "App.inc"
    .include    "Sound.inc"
    .include	"Game.inc"
    .include    "Player.inc"
    .include    "Enemy.inc"
    .include    "Field.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; ゲームを初期化する
;
_GameInitialize::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite

    ; パターンネームのクリア
    xor     a
    call    _SystemClearPatternName

    ; プレイヤの初期化
    call    _PlayerInitialize
    
    ; エネミーの初期化
    call    _EnemyInitialize

    ; フィールドの初期化
    call    _FieldInitialize

    ; ゲームの初期化
    ld      hl, #gameDefault
    ld      de, #_game
    ld      bc, #GAME_LENGTH
    ldir

    ; 描画の開始
    ld      hl, #(_videoRegister + VDP_R1)
    set     #VDP_R1_BL, (hl)

    ; 状態の設定
    ld      a, #GAME_STATE_START
    ld      (_game + GAME_STATE), a
    ld      a, #APP_STATE_GAME_UPDATE
    ld      (_app + APP_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; ゲームを更新する
;
_GameUpdate::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      a, (_game + GAME_STATE)
    and     #0xf0
    rrca
    rrca
    rrca
    ld      e, a
    ld      d, #0x00
    ld      hl, #gameProc
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
GameNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; ゲームを開始する
;
GameStart:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    jr      nz, 09$

    ; フレームの設定
    ld      a, #0x60
    ld      (_game + GAME_FRAME), a

    ; 開始画面の描画
    call    GamePrintStart

    ; ビデオの設定
    ld      a, #((APP_COLOR_TABLE + 0x0040) >> 6)
    ld      (_videoRegister + VDP_R3), a
    ld      a, #((APP_PATTERN_GENERATOR_TABLE + 0x0800) >> 11)
    ld      (_videoRegister + VDP_R4), a
    ld      a, #((APP_SPRITE_GENERATOR_TABLE + 0x0800) >> 11)
    ld      (_videoRegister + VDP_R6), a

    ; BGM の再生
    ld      a, #SOUND_BGM_GAME
    call    _SoundPlayBgm

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; フレームの更新
    ld      hl, #(_game + GAME_FRAME)
    dec     (hl)
    jr      nz, 19$

    ; 状態の更新
    ld      a, #GAME_STATE_ENTER
    ld      (_game + GAME_STATE), a
;   jr      19$
19$:

    ; レジスタの復帰

    ; 終了
    ret
    
; キャラクタが登場する
;
GameEnter:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    jr      nz, 09$

    ; ゲーム画面の描画
    call    GamePrintScreen

    ; ビデオの設定
    ld      a, #((APP_COLOR_TABLE + 0x0000) >> 6)
    ld      (_videoRegister + VDP_R3), a
    ld      a, #((APP_PATTERN_GENERATOR_TABLE + 0x0000) >> 11)
    ld      (_videoRegister + VDP_R4), a
    ld      a, #((APP_SPRITE_GENERATOR_TABLE + 0x0000) >> 11)
    ld      (_videoRegister + VDP_R6), a

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; プレイヤの更新
    call    _PlayerUpdate

    ; エネミーの更新
    call    _EnemyUpdate

    ; フィールドの更新
    call    _FieldUpdate

    ; プレイヤの描画
    call    _PlayerRender
    
    ; エネミーの描画
    call    _EnemyRender

    ; フィールドの描画
    call    _FieldRender

    ; スカウターの描画
    call    GamePrintScouter

    ; フラグの監視
    ld      hl, #(_game + GAME_FLAG)
    bit     #GAME_FLAG_PLAY_BIT, (hl)
    jr      z, 10$

    ; 状態の更新
    ld      a, #GAME_STATE_PLAY
    ld      (_game + GAME_STATE), a
10$:

    ; レジスタの復帰

    ; 終了
    ret

; ゲームをプレイする
;
GamePlay:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    jr      nz, 09$

    ; フィールドのスクロール
    call    _FieldScrollRight

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; タイマの更新
    ld      hl, #(_game + GAME_TIMER_00_1)
    ld      a, (hl)
    or      a
    jr      z, 10$
    dec     (hl)
    jr      19$
10$:
    ld      (hl), #0x3b
    dec     hl
    ld      a, (hl)
    or      a
    jr      z, 11$
    dec     (hl)
    jr      19$
11$:
    ld      (hl), #0x09
    dec     hl
    ld      a, (hl)
    or      a
    jr      z, 12$
    dec     (hl)
    jr      19$
12$:
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
;   inc     hl
;   jr      19$
19$:

    ; プレイヤの更新
    call    _PlayerUpdate

    ; エネミーの更新
    call    _EnemyUpdate

    ; フィールドの更新
    call    _FieldUpdate

    ; プレイヤの描画
    call    _PlayerRender
    
    ; エネミーの描画
    call    _EnemyRender

    ; フィールドの描画
    call    _FieldRender

    ; スカウターの描画
    call    GamePrintScouter

    ; タイマの監視
    ld      hl, #(_game + GAME_TIMER_10_0)
    ld      a, (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jr      nz, 29$

    ; 状態の更新
    ld      a, #GAME_STATE_OVER
    ld      (_game + GAME_STATE), a
;   jr      29$
29$:

    ; レジスタの復帰

    ; 終了
    ret

; ゲームオーバーになる
;
GameOver:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    jr      nz, 09$

    ; フレームの設定
    ld      a, #0x40
    ld      (_game + GAME_FRAME), a

    ; エネミーのパンチ
    call    _EnemyActionPunch

    ; プレイヤのダウン
    call    _PlayerActionDown

    ; フィールドのスクロール
    call    _FieldScrollLeft

    ; サウンドの停止
    call    _SoundStop

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; プレイヤの更新
    call    _PlayerUpdate

    ; エネミーの更新
    call    _EnemyUpdate

    ; フィールドの更新
    call    _FieldUpdate

    ; プレイヤの描画
    call    _PlayerRender
    
    ; エネミーの描画
    call    _EnemyRender

    ; フィールドの描画
    call    _FieldRender

    ; スカウターの描画
    call    GamePrintScouter

    ; フラグの監視
    ld      hl, #(_game + GAME_FLAG)
    bit     #GAME_FLAG_RESULT_BIT, (hl)
    jr      z, 19$

    ; フレームの更新
    ld      hl, #(_game + GAME_FRAME)
    dec     (hl)
    jr      nz, 19$

    ; 状態の更新
    ld      a, #GAME_STATE_RESULT
    ld      (_game + GAME_STATE), a
;   jr      19$
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 結果を表示する
;
GameResult:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    and     #0x0f
    jr      nz, 09$

    ; スコアの更新
    ld      hl, #(_game + GAME_SCORE_10000)
    call    _AppUpdateScore
    jr      nc, 00$
    ld      hl, #(_game + GAME_FLAG)
    set     #GAME_FLAG_SCORE_TOP_BIT, (hl)
00$:

    ; クラスの取得
    ld      hl, (_game + GAME_SCORE_L)
    call    GameGetClass
    ld      (_game + GAME_CLASS), a

    ; 結果画面の描画
    call    GamePrintResult

    ; ビデオの設定
    ld      a, #((APP_COLOR_TABLE + 0x0040) >> 6)
    ld      (_videoRegister + VDP_R3), a
    ld      a, #((APP_PATTERN_GENERATOR_TABLE + 0x0800) >> 11)
    ld      (_videoRegister + VDP_R4), a
    ld      a, #((APP_SPRITE_GENERATOR_TABLE + 0x0800) >> 11)
    ld      (_videoRegister + VDP_R6), a

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; SPACE の入力
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 19$

    ; 状態の更新
    ld      a, #APP_STATE_TITLE_INITIALIZE
    ld      (_app + APP_STATE), a
;   jr      19$
19$:

    ; レジスタの復帰

    ; 終了
    ret

; スコアを加算する
;
_GameAddScore::

    ; レジスタの保存
    push    hl
    push    bc

    ; a < スコア

    ; スコアの加算
    ld      c, a
    ld      b, #0x00
    ld      hl, (_game + GAME_SCORE_L)
    add     hl, bc
    jr      nc, 10$
    ld      hl, #0xffff
10$:
    ld      (_game + GAME_SCORE_L), hl
    ld      hl, #(_game + GAME_SCORE_00001)
    ld      c, #0x0a
    add     a, (hl)
    ld      (hl), a
    sub     c
    jr      c, 19$
    ld      (hl), a
    dec     hl
    inc     (hl)
    ld      a, (hl)
    sub     c
    jr      c, 19$
    ld      (hl), a
    dec     hl
    inc     (hl)
    ld      a, (hl)
    sub     c
    jr      c, 19$
    ld      (hl), a
    dec     hl
    inc     (hl)
    ld      a, (hl)
    sub     c
    jr      c, 19$
    ld      (hl), a
    dec     hl
    inc     (hl)
    ld      a, (hl)
    sub     c
    jr      c, 19$
    ld      a, #0x09
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
    inc     hl
    ld      (hl), a
;   inc     hl
;   jr      19$
19$:

    ; レジスタの復帰
    pop     bc
    pop     hl

    ; 終了
    ret

; クラスを取得する
;
GameGetClass:

    ; レジスタの保存
    push    bc
    push    de
    push    ix

    ; hl < スコア
    ; a  > クラス

    ; クラスの取得
    ld      ix, #(gameClassPoint + 0x0002)
    ld      bc, #(((GAME_CLASS_LENGTH - 0x01) << 8) | 0x00)
10$:
    ld      e, 0x00(ix)
    ld      d, 0x01(ix)
    push    hl
    or      a
    sbc     hl, de
    pop     hl
    jr      c, 19$
    inc     ix
    inc     ix
    inc     c
    djnz    10$
19$:
    ld      a, c

    ; レジスタの復帰
    pop     ix
    pop     de
    pop     bc

    ; 終了
    ret

; ゲーム画面を描画する
;
GamePrintScreen:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; スカウターの描画
    ld      hl, #(gameScreenPatternName + 0x0000)
    ld      de, #(_patternName + 0x0000)
    ld      bc, #0x0100
    ldir

    ; ステータスの描画
;   ld      hl, #(gameScreenPatternName + 0x0100)
    ld      de, #(_patternName + 0x0200)
    ld      bc, #0x0100
    ldir

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; スカウターを描画する
;
GamePrintScouter:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; スコアの描画
    ld      hl, #(_game + GAME_SCORE_10000)
    ld      de, #(_patternName + 0x0025)
    call    _AppPrintValue

    ; タイマの描画
    ld      hl, #(_game + GAME_TIMER_10_0)
    ld      de, #(_patternName + 0x00b6)
    ld      c, #0x10
    ld      a, (hl)
    or      a
    jr      z, 20$
    add     a, c
20$:
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    add     a, c
    ld      (de), a
    inc     hl
    inc     de
    ld      a, #0x01
    ld      (de), a
    inc     de
    ld      a, (hl)
    add     a, a
    ld      c, a
    ld      b, #0x00
    ld      hl, #gameTimerMilliSecond
    add     hl, bc
    ld      c, #0x10
    ld      a, (hl)
    add     a, c
    ld      (de), a
    inc     hl
    inc     de
    ld      a, (hl)
    add     a, c
    ld      (de), a
;   inc     hl
;   inc     de

    ; スプライトの描画
    ld      hl, #gameScouterSprite
    ld      de, #(_sprite + GAME_SPRITE_SCOUTER)
    ld      bc, #(0x0006 * 0x0004)
    ldir

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 開始画面を描画する
;
GamePrintStart:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; 画面のクリア
    xor     a
    call    _SystemClearPatternName

    ; 開始の描画
    ld      hl, #gameStartPatternName
    ld      de, #(_patternName + 0x016c)
    ld      bc, #0x0007
    ldir

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 結果画面を描画する
;
GamePrintResult:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; 画面のクリア
    xor     a
    call    _SystemClearPatternName

    ; 戦闘力の描画
    ld      hl, #gameResultPatternName_BattlePoint
    ld      de, #(_patternName + 0x006b)
    ld      bc, #0x0003
    ldir
    ld      hl, #(_game + GAME_SCORE_10000)
    ld      de, #(_patternName + 0x0070)
    call    _AppPrintValue

    ; クラスの描画
    ld      a, (_game + GAME_CLASS)
    or      a
    jr      z, 19$
    add     a, a
    add     a, a
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #gameClassPatternName
    add     hl, de
    ld      de, #(_patternName + 0x00ac)
    ld      bc, #0x0008
    ldir
19$:

    ; ピクチャの描画
    ld      hl, #gameResultPatternName_Picture
    ld      de, #(_patternName + 0x0100)
    ld      bc, #0x0100
    ldir

    ; ハイスコアの描画
    ld      hl, #(_game + GAME_FLAG)
    bit     #GAME_FLAG_SCORE_TOP_BIT, (hl)
    jr      nz, 20$
    ld      hl, #(gameResultPatternName_TopScore + 0x0000)
    ld      de, #(_patternName + 0x024b)
    ld      bc, #0x0004
    ldir
    ld      hl, #(_app + APP_SCORE_10000)
    ld      de, #(_patternName + 0x0250)
    call    _AppPrintValue
    jr      29$
20$:
    ld      hl, #(gameResultPatternName_TopScore + 0x0004)
    ld      de, #(_patternName + 0x024e)
    ld      bc, #0x0004
    ldir
;   jr      29$
29$:

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
gameProc:
    
    .dw     GameNull
    .dw     GameStart
    .dw     GameEnter
    .dw     GamePlay
    .dw     GameOver
    .dw     GameResult

; ゲームの初期値
;
gameDefault:

    .db     GAME_STATE_NULL
    .db     GAME_FLAG_NULL
    .db     GAME_FRAME_NULL
    .db     GAME_CLASS_NULL
    .dw     177 ; GAME_SCORE_NULL
    .db     0x00 ; GAME_SCORE_NULL
    .db     0x00 ; GAME_SCORE_NULL
    .db     0x01 ; GAME_SCORE_NULL
    .db     0x07 ; GAME_SCORE_NULL
    .db     0x07 ; GAME_SCORE_NULL
    .db     0x03 ; GAME_TIMER_NULL
    .db     0x00 ; GAME_TIMER_NULL
    .db     0x00 ; GAME_TIMER_NULL

; クラス
;
gameClassPoint:

    .dw     0       ; -
    .dw     610     ; 餃子
    .dw     970     ; ヤジロベー
    .dw     1030    ; ミスター・ポポ
    .dw     1480    ; ヤムチャ
    .dw     1770    ; クリリン
    .dw     1830    ; 天津飯
    .dw     2800    ; 悟飯
    .dw     3500    ; ピッコロ
    .dw     8000    ; 悟空

gameClassPatternName:

    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; -
    .db     0x00, 0x00, 0x35, 0x36, 0x0e, 0x00, 0x00, 0x00  ; 餃子
    .db     0x00, 0x22, 0x23, 0x24, 0x25, 0x21, 0x0e, 0x00  ; ヤジロベー
    .db     0x26, 0x27, 0x28, 0x21, 0x20, 0x29, 0x29, 0x0e  ; ミスター・ポポ
    .db     0x00, 0x22, 0x30, 0x31, 0x32, 0x0e, 0x00, 0x00  ; ヤムチャ
    .db     0x00, 0x2a, 0x2b, 0x2b, 0x2c, 0x0e, 0x00, 0x00  ; クリリン
    .db     0x00, 0x00, 0x37, 0x38, 0x39, 0x0e, 0x00, 0x00  ; 天津飯
    .db     0x00, 0x00, 0x3a, 0x39, 0x0e, 0x00, 0x00, 0x00  ; 悟飯
    .db     0x00, 0x2d, 0x2e, 0x2f, 0x24, 0x0e, 0x00, 0x00  ; ピッコロ
    .db     0x00, 0x00, 0x3a, 0x3b, 0x0e, 0x00, 0x00, 0x00  ; 悟飯

; ゲーム画面
;
gameScreenPatternName:

    ; SCOUTER
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x30, 0x34, 0x34, 0x34
    .db     0x34, 0x34, 0x34, 0x31, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x34, 0x34, 0x34, 0x34
    .db     0x34, 0x34, 0x34, 0x34, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x03, 0x04, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x34, 0x34, 0x34, 0x34
    .db     0x34, 0x34, 0x34, 0x34, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x34, 0x34, 0x34, 0x34
    .db     0x34, 0x34, 0x34, 0x34, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x34, 0x34, 0x34, 0x34
    .db     0x34, 0x34, 0x34, 0x34, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x32, 0x34, 0x34, 0x34
    .db     0x34, 0x34, 0x34, 0x33, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .db     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    ; STATUS
    .db     0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
    .db     0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
    .db     0x40, 0x60, 0x61, 0x62, 0x63, 0x58, 0x59, 0x59, 0x5a, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
    .db     0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x58, 0x59, 0x59, 0x5a, 0x70, 0x71, 0x72, 0x73, 0x40
    .db     0x40, 0x64, 0x65, 0x66, 0x67, 0x5b, 0x00, 0x00, 0x5c, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
    .db     0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x5b, 0x00, 0x00, 0x5c, 0x74, 0x75, 0x76, 0x77, 0x40
    .db     0x40, 0x68, 0x69, 0x6a, 0x6b, 0x5b, 0x00, 0x00, 0x5c, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
    .db     0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x5b, 0x00, 0x00, 0x5c, 0x78, 0x79, 0x7a, 0x7b, 0x40
    .db     0x40, 0x6c, 0x6d, 0x6e, 0x6f, 0x5b, 0x00, 0x00, 0x5c, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
    .db     0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x5b, 0x00, 0x00, 0x5c, 0x7c, 0x7d, 0x7e, 0x7f, 0x40
    .db     0x40, 0x58, 0x38, 0x39, 0x5a, 0x5b, 0x00, 0x00, 0x5c, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
    .db     0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x5b, 0x00, 0x00, 0x5c, 0x58, 0x3c, 0x3d, 0x5a, 0x40
    .db     0x40, 0x5d, 0x3a, 0x3b, 0x5f, 0x5d, 0x5e, 0x5e, 0x5f, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
    .db     0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x5d, 0x5e, 0x5e, 0x5f, 0x5d, 0x3e, 0x3f, 0x5f, 0x40
    .db     0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40
    .db     0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40

; スカウター
;
gameScouterSprite:

    .db     0x10 - 0x01, 0x70, 0x50, VDP_COLOR_WHITE
    .db     0x10 - 0x01, 0x80, 0x54, VDP_COLOR_WHITE
    .db     0x20 - 0x01, 0x70, 0x58, VDP_COLOR_WHITE
    .db     0x20 - 0x01, 0x80, 0x5c, VDP_COLOR_WHITE
    .db     0x08 - 0x01, 0x60, 0xd8, VDP_COLOR_WHITE
    .db     0x28 - 0x01, 0x90, 0xdc, VDP_COLOR_WHITE

; タイマ
;
gameTimerMilliSecond:

    .db     0x00, 0x00, 0x00, 0x01, 0x00, 0x03, 0x00, 0x05, 0x00, 0x06, 0x00, 0x08
    .db     0x01, 0x00, 0x01, 0x01, 0x01, 0x03, 0x01, 0x05, 0x01, 0x06, 0x01, 0x08
    .db     0x02, 0x00, 0x02, 0x01, 0x02, 0x03, 0x02, 0x05, 0x02, 0x06, 0x02, 0x08
    .db     0x03, 0x00, 0x03, 0x01, 0x03, 0x03, 0x03, 0x05, 0x03, 0x06, 0x03, 0x08
    .db     0x04, 0x00, 0x04, 0x01, 0x04, 0x03, 0x04, 0x05, 0x04, 0x06, 0x04, 0x08
    .db     0x05, 0x00, 0x05, 0x01, 0x05, 0x03, 0x05, 0x05, 0x05, 0x06, 0x05, 0x08
    .db     0x06, 0x00, 0x06, 0x01, 0x06, 0x03, 0x06, 0x05, 0x06, 0x06, 0x06, 0x08
    .db     0x07, 0x00, 0x07, 0x01, 0x07, 0x03, 0x07, 0x05, 0x07, 0x06, 0x07, 0x08
    .db     0x08, 0x00, 0x08, 0x01, 0x08, 0x03, 0x08, 0x05, 0x08, 0x06, 0x08, 0x08
    .db     0x09, 0x00, 0x09, 0x01, 0x09, 0x03, 0x09, 0x05, 0x09, 0x06, 0x09, 0x08

; ゲームの開始
;
gameStartPatternName:

    .db     0x33, 0x2b, 0x21, 0x34, 0x3c, 0x3d, 0x3e

; ゲームの結果
;
gameResultPatternName_BattlePoint:

    .db     0x03, 0x04, 0x05

gameResultPatternName_Picture:

    .db     0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87
    .db     0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97
    .db     0x98, 0x99, 0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0x9f, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7
    .db     0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6, 0xb7
    .db     0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7
    .db     0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7
    .db     0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7
    .db     0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0xee, 0xef, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
    .db     0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7
    .db     0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80

gameResultPatternName_TopScore:

    ; 最高記録
    .db     0x08, 0x09, 0x0a, 0x0b
    ; 記録更新
    .db     0x0a, 0x0b, 0x0c, 0x0d


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; ゲーム
;
_game::
    
    .ds     GAME_LENGTH
