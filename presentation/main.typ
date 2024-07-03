#import "template.typ": *
#show: my-theme.with(
  title: "第10回Unixゼミ",
  author: "高木 空"
)

#show raw: it => {
  if it.lang == "a" {
    if it.block {
      block(
        fill: rgb("#1d2433"),
        inset: 15pt,
        radius: 5pt,
        width: 100%,
        text(fill: colors.at(0), it)
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

#title-slide(title: [第10回Unixゼミ\ Cプログラム(デバッグ編)], author: "川島研 B4 高木 空")[
]

= お品書き
#slide(title: "お品書き")[
  #outline(depth: 2, indent: 2em)
]

= デバッガ
== デバッガとは
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

== GDBの使い方
=== GDBの起動
#slide(title: "GDBの使い方")[
  1. 起動
  ```a
    > gdb [options] [<file> [<core-file>|<pid>]]
  ```
  - 実行ファイルとコアファイルまたはプロセスIDを指定
  例:
  ```a
    > gdb ./a.out
  ```

  - よく使う`options`
    - `--args` : 実行ファイルに渡す引数を指定
    - `--help` : 簡単な使い方を表示
]

=== GDBの終了
#slide(title: "GDBの使い方")[
  2. 停止
  ```a
    (gdb) quit [<expression>]
  ```
  でGDBを終了する
  - `expression` : GDBの終了コード
]

=== コマンド
==== ヘルプコマンド
#slide(title: "GDBの使い方")[
  3. コマンド
  ```a
    (gdb) <command> [args...]
  ```
  の形式でコマンドを使用
  - ヘルプコマンド
  ```a
    (gdb) help [<class>]
  ```
  - コマンドのヘルプを表示
  - 引数無しで実行すると指定できる`class`を表示
]

==== プログラムの開始
#slide(title: "GDBの使い方")[
  4. プログラムの開始
  ```a
    (gdb) start [<args>...]
    (gdb) run [<args>...]
  ```
  でプログラムを開始

  - `start` : 開始直後で停止
  - `run` : 停止させるかプログラム終了まで継続実行
  - `args...` の引数はプログラムに渡される
]

==== プログラムの停止
===== ブレークポイント
#slide(title: "GDBの使い方")[
  5. プログラムの停止
  - ブレークポイント
    - プログラムが到達すると停止する場所
  ```a
    (gdb) break [<loc>] [if <cond>]
  ```
  でブレークポイントを設置
  - `loc` : ブレークポイントを設置する場所
    - `[<filename>:]<linenum>` : 行番号
    - `[<filename>:]<funname>` : 関数名
  - `cond` : 条件式。満たすときだけ停止
]

===== ウォッチポイント
#slide(title: "GDBの使い方")[
  5. プログラムの停止
  - ウォッチポイント
    - 式の値が変更したら停止
  ```a
    (gdb) watch [-l|-location] <exp>
  ```
  でウォッチポイントを設置
  - `-l`, `-location` : `exp`が指すアドレスのメモリを監視
  - `exp` : 監視対象の式
]

===== キャッチポイント
#slide(title: "GDBの使い方")[
  5. プログラムの停止
  - キャッチポイント
    - 例外などを検出して停止
  ```a
    (gdb) catch <event>
  ```
  でキャッチポイントを設置。`event`に指定できるもの:
  - `catch [<regexp>]` : 例外キャッチ
  - `rethrow [<regexp>]` : 例外再スロー
  - `throw [<regexp>]` : 例外スロー
  - `sycall [<name>|<num>|g:<group>]...` : システムコール発行
  - `load [<regexp>]` : 共有ライブラリロード
  - `unload [<regexp>]` : 共有ライブラリアンロード
  - `signal [<sig>|all]` : シグナル配信
]

=== 検査
==== データの検査
#slide(title: "GDBの使い方")[

]

#set text(size: 12pt)
#set page(paper: "a4")
// #outline(inset: 10pt)
