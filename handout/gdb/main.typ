#import "@preview/big-todo:0.2.0": *

#set text(font: "Harano Aji Mincho")
#set heading(numbering: "1.1")
#set page(numbering: "1")

#show raw: it => {
  if (it.lang == "shell") {
    block(fill: rgb("#1d2433"), width: 100%, inset: 10pt, radius: 10pt)[
      #text(fill: rgb("#f6f6f6"))[#it]
    ]
  } else {
    it
  }
}

#align(center+horizon)[#text(size: 2em)[GDB]]
#align(center)[Chapter 1]
#pagebreak()

= 概要
  == GDBとは
    GDBはGnu Projectのデバッガです。
  == コマンド
    
  == ヘルプ
= 基本操作
  == GDBの起動
  == プログラムの読み込み
  == プログラムの起動
  == プログラムの終了
  == GDBの終了
= プログラムの停止
  == ブレークポイント
  == ウォッチポイント
  == キャッチポイント
= プログラムの再開
  == ステップ実行
  == 継続実行
= スタックフレーム
  == バックトレース
  == フレームの選択
  == フレーム情報の表示
= 変数の表示

//

// = LLDB
//   == 概要
//     == LLDBとは
//     == コマンド
//     == ヘルプ
//   == 基本操作
//     === LLDBの起動
//     === プログラムの読み込み
//     === プログラムの起動
//     === プログラムの終了
//     === LLDBの終了
//   == プログラムの停止
//     === ブレークポイント
//     === ウォッチポイント
//     === キャッチポイント
//   == プログラムの再開
//   == スタックフレーム
//     === バックトレース
//     === フレームの選択
//     === フレーム情報の表示
//   == 変数の表示
// EOF
#outline(indent: 1em)
