#set page(numbering: "1")
#set heading(numbering: "1.1")
#set text(size: 12pt, font: ("New Computer Modern", "Harano Aji Mincho"))

#show raw: it => {
  if it.block {
    block(stroke: 1pt, inset: 10pt, radius: 10pt, width: 100%)[#it]
  } else {
    it
  }
}

#[
  #align(center + horizon)[
    #text(2em)[第10回Unixゼミ\ Cプログラム(デバッグ編)]

    #text(1.3em)[高木 空]

    #datetime(year: 2024, month: 7, day: 1).display("[year]年[month]月[day]日")
  ]
  #pagebreak()
]

#outline(title: "目次", indent: 1em)

#include "section1.typ"
#include "section2.typ"
#include "section3.typ"
#include "section4.typ"
#include "section5.typ"
#include "section6.typ"
#include "section7.typ"
#include "section8.typ"
#include "section9.typ"
#include "section10.typ"
#include "section11.typ"
// == デバッガの起動、終了
// === 起動
// === 終了
// === シェルコマンド
// === ロギング

// == コマンド概要
// === 補完
// === ヘルプ

// == プログラムの開始
// === スタート
// === 引数
// === 環境変数

// == プログラムの停止
// === ブレークポイント
// === ウォッチポイント
// === 再開
// === ステップ実行
// === スキップ

// == スタックの調査
// === バックトレース

// == ソースコードの調査
// === リスト
// === 位置指定

// == データの調査
// === プリント
// === ディスプレイ
// === 人工配列
// === レジスタ

// == (トレースポイント)
// == (TUI)
