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

#let lldb(cmd) = raw("  (lldb) "+cmd, block: true, lang: "shell")
#let args(pre: [], name: "argument name", desc: "description", ..con) = {
  pre
  table(
    columns: (2fr, 3fr),
    align: (_, y) => if y==0 {center} else {left},
    [#name], [#desc],
    ..con.pos().flatten()
  )
}
#let sep(text) = table.cell(colspan: 2)[#align(center)[#text]]
#let syn(text) = raw("  (gdb) "+text, block: true, lang: "shell")

#align(center+horizon)[#text(size: 2em)[LLDB]]
#align(center)[Chapter 2]
#counter(heading).update(0)
#pagebreak()

= 概要
	= LLDBとは
		LLDBはLLVMのデバッガです。
	= コマンド
		LLDBを起動すると先頭に`(lldb)`の表示が出て対話モードになります。
		#lldb("<noun> <verb> [<options>]")
		の形式でコマンドを実行し、様々の処理を行うことでデバッグを行います。

		コマンド入力時はTABによる補完が可能です。また、曖昧さがない場合にはコマンドは先頭数文字だけの入力でも認識されます。
	= ヘルプ
= 基本操作
	== LLDBの起動
	== プログラムの読み込み
	== プログラムの起動
	== プログラムの終了
	== LLDBの終了
= プログラムの停止
	== ブレークポイント
	== ウォッチポイント
	== キャッチポイント
= プログラムの再開
= スタックフレーム
	== バックトレース
	== フレームの選択
	== フレーム情報の表示
= 変数の表示
// EOF
#outline(indent: 1em)
