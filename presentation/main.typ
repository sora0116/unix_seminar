#import "template.typ": *
#show: my-theme.with(
  title: "第10回Unixゼミ",
  author: "高木 空"
)

#show raw: it => {
  if it.lang == "shell" {
    if it.block {
      block(
        fill: rgb("#1d2433"),
        inset: 15pt,
        radius: 5pt,
        width: 100%,
        text(fill: colors.at(0), it),
        below: 10pt
      )
    } else {
      box(
        fill: rgb("#1d2433"),
        inset: 15pt,
        radius: 5pt,
        width: 1fr,
        text(fill: colors.at(0), it)
      )
    }
  } else {
    it
  }
}

#set heading(numbering: "1.1")

#title-slide(title: [第10回Unixゼミ\ Cプログラム(デバッグ編)], author: "川島研 B4 高木 空")[
]

= デバッガ
== デバッガとは
=== 概要
#slide(title: "デバッガ")[
  - デバッグ (debug)
    - バグ(bug)を取り除く(de-)こと

  - デバッグの手法
    - printデバッグ
    - コードを読む
    - デバッガを使う
      - 今回の主題
]
== デバッグの手法
=== printデバッグ
#slide(title: "デバッグの手法")[
  - printデバッグ
    - ソースコードにprintを埋め込む
    - 利点
      - 気軽に実行できる
      - 欲しい出力を欲しい形式で得られる
    - 欠点
      - ソースコードを改変する必要がある
      - バグの箇所を検討してからしかできない
      - 得られる情報が少ない
]
=== デバッガ
#slide(title: "デバッグの手法")[
  - デバッガを使う
    - デバッガ - デバッグを補助するツール
    - 利点
      - プログラム全体を観察できる
      - プログラムの変更が(一般には)不要
      - スタックやメモリの監視もできる
    - 欠点
      - 使い方を知っている必要がある
]
== デバッガの具体例
=== GDBとLLDB
#slide(title: "C言語のデバッガ")[
  - C言語プログラムのデバッガ

  - GDB 
    - Gnu Projectのデバッガ
    - gccを使うならコレ
    - Linuxに標準搭載されている
  - LLDB
    - LLVMのデバッガ
    - clangを使うならコレ
]
== デバッガの起動、終了
=== 起動
#slide(title: "デバッガの起動")[
  ```shell
    $ gdb [options] [<program>]
  ```
  でGDBを起動

  - `options` : 起動時のオプションを指定
    - `--help` : 簡単な使い方を表示
    - `--tui` : TUIモード(後述)で起動
  - `program` : デバッグ対象の実行可能ファイルを指定
]
=== 終了
#slide(title: "デバッガの終了")[
  - GDBが起動すると先頭に`(gdb)`と表示される
  ```shell
    (gdb) quit [<expr>]
    (gdb) exit [<expr>]
  ```
  でGDBを終了(`ctrl-d`でも可)

  引数:
  - `expr` : GDBの終了コードを指定
]
=== シェルコマンド
#slide(title: "デバッガ起動中のシェルコマンド")[
  ```shell
    (gdb) shell <command>
    (gdb) ! <command>
  ```
  でGDB起動中にシェルコマンドを実行

  引数:
  - `command` : 実行するシェルコマンド

  補足:
  - パイプ等も使える
]
== コマンド
=== コマンド概要
#slide(title: "コマンド概要")[
  - GDBはコマンドで操作
    - `quit`や`shell`もコマンド
  ```shell
    (gdb) <command> [<args>...]
  ```
  の形で入力
  - コマンドが区別できれば省略できる
    - 例 : `quit` $arrow$ `q`
  - `TAB`キーによる補完が可能
    - 候補が唯一の場合自動入力
    - 複数の場合2回押すと候補を表示
]
=== ヘルプ
#slide(title: "コマンド補助")[
  ```shell
    (gdb) help [<class>|<command>]
  ```
  コマンドの一覧や使い方を表示

  引数:
  - `class` : コマンド群を指定するクラス
  - `command` : ヘルプを見たいコマンドを指定

  補足:
  - 引数無しで`help`を実行すると`class`の一覧が表示される
]
== プログラムの開始
=== スタート
#slide(title: "プログラムの開始")[
  ```shell
    (gdb) run [<args>...]
  ```
  でプログラムをGDBの下で実行
  - `args` : プログラムのコマンドライン引数として渡される
]
=== チェックポイントとリスタート
#slide(title: "チェックポイントとリスタート")[
  特定の場所でのプログラムの状態を保存して再開できる
  ```shell
    (gdb) checkpoint
  ```
  で現在の状態を保存
  ```shell
    (gdb) info checkpoints
  ```
  で保存したチェックポイントの一覧を表示
  ```shell
    (gdb) restart <id>
  ```
  で指定したチェックポイントから再開
]
== プログラムの停止
=== プログラム中断の概要
#slide(title: "プログラムの停止")[
  - GDBを使うとプログラムを中断できる
  - 停止する条件
    - ブレークポイント
    - ウォッチポイント
    - キャッチポイント
  - 実行の再開
    - 継続実行
    - ステップ実行
]
=== ブレークポイント
#slide(title: "ブレークポイント")[
  - プログラム上の指定場所に到達したら中断
  ```shell
    (gdb) break [<loc>] [if <cond>]
  ```
  でブレークポイントを設置

  引数:
  - `loc` : 位置指定。以下の形式で指定:
    - `[<filename>:]<linenum>` : 行番号指定
    - `<offset>` : 行オフセット指定
    - `[<filename>:]<function>` : 関数名指定
  - `cond` : 条件式。満たすときだけ中断
]
=== ウォッチポイント
#slide(title: "ウォッチポイント")[
  式の値が変更したら中断
  ```shell
    (gdb) watch [-location] <expr>
  ```
  でウォッチポイントを設置

  引数:
  - `-location` : `expr`の参照するメモリを監視
  - `expr` : 監視対象の式
]
=== ブレークポイントの削除
#slide(title: "ブレークポイントの削除")[
  ```shell
    (gdb) clear [<locspec>]
  ```
  `<locspec>`にあるブレークポイントを削除
  ```shell
    (gdb) delete [breakpoints] [<list>...]
  ```
  `<list>`で指定したブレークポイント、ウォッチポイントを削除
  ```shell
    (gdb) info breakpoints
  ```
  設置されたブレークポイント、ウォッチポイントを表示
]
== プログラムの再開
=== 継続実行
#slide(title: "継続実行")[
  次の停止場所まで実行する
  ```shell
    (gdb) continue [<count>]
    (gdb) fg [<count>]
  ```
  で継続実行

  引数:
  - `count` : 停止箇所を無視する回数
]
=== ステップ実行
#slide(title: "ステップ実行")[
  次の停止箇所を指定しつつ再開
  ```shell
    (gdb) step [<count>]
    (gdb) nexti [<count>]
  ```
  で次の行まで実行。
  
  補足:
  - `step`は関数呼び出しの場合中に入る
  - `next`は関数呼び出しの場合中に入らない

  引数:
  - `count` : 無視する行数
  ```shell
    (gdb) until <locspec>
  ```
  `locspec`で指定した位置まで実行
]
== スタックの調査
=== バックトレース
#slide(title: "バックトレース")[
  関数呼び出しのトレース
  ```shell
    (gdb) backtrace
    (gdb) where
    (gdb) info stack
  ```
  でバックトレースを表示
]
=== フレームの選択
#slide(title: "フレームの選択")[
  ```shell
    (gdb) frame [<spec>]
  ```
  でフレームを選択

  引数:
  - `spec`: フレームを指定。以下の形式が可能
    - `<num>` : フレーム番号を指定
    - `<function-name>` : 関数名を指定
  ```shell
    up <n>
    down <n>
  ```
  で一つ上または下のフレームを指定
]
=== フレーム関連のステップ実行
#slide(title: "ステップ実行")[
  ```shell
    (gdb) finish
  ```
  で選択中のフレームが返るまで実行
]
== ソースコードの調査
=== リスト
#slide(title: "ソースコード情報の表示")[
  ```shell
    (gdb) list [<line>|<function>|+|-]
  ```
  でソースコードを表示
  
  引数:
  - `line` : 行番号を指定してそこを中心に表示
  - `function` : 関数名を指定して開始地点を中心に表示
  - `+`, `-` : 前に表示した部分の後/前を表示
  ```shell
    (gdb) list <start>, <end>
  ```
  で指定部分を表示
]

== データの調査
=== プリント
#slide(title: "プリント")[
  ```shell
    (gdb) print [[<options>...] --] [/<fmt>] <expr>
  ```
  でフォーマットを指定して`expr`の値を表示

  引数:
  - `options` : オプション
  - `fmt` : 
  - `expt` : 表示する値
]
=== ディスプレイ
=== 人工配列
=== レジスタ

== (トレースポイント)
== (TUI)

#set text(size: 12pt)
#set page(paper: "a4")
#block(inset: 30pt)[#outline(indent: 1em)]
