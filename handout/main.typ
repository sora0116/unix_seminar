#set page(numbering: "1")
#set heading(numbering: "1.1")
#set text(size: 12pt, font: ("New Computer Modern", "Harano Aji Mincho"))

#outline(title: "目次")

// #include "section1.typ"
// #include "section2.typ"
// #include "section3.typ"
// #include "section4.typ"
// #include "section5.typ"
// #include "section6.typ"
// #include "section7.typ"
// #include "section8.typ"
// #include "section9.typ"
= データの検証
`
  print [[<options>] --] <expr>
  print [[<options>] --] /<f> <expr>
`
式`expr`の値を表示します。指定しない場合は、最後の値を表示します。
`options`に指定できる値は以下です。
- `--address [on|off]`: アドレスを表示します。
- `-array [on|off]`: 配列のフォーマットをします。
- `-array-indexes [on|off]`: 配列の添え字を表示します。
- `-characters <number-of-characters>|elements|unlimited`: 表示する文字列の長さを制限します。
- `-elements <number-of-elements>|unlimited`: 表示する配列の要素数を指定します。
- `-max-depth <depth>|unlimited`: ネストした構造を表略する閾値を設定します。
- `-nibbles [on|off]`: バイナリを4ビットグループで表示するかどうか
- `-memoty-tag-violations [on|off]`: メモリタグ違反に関する情報を表示する。
- `-null-stop [on|off]`: 文字配列の表示をNULL文字で停止するかどうか。
- `-object [on|off]`: C++のvirtual functionテーブルの表示設定
- `-pretty [on|off]`: 構造体のprettyフォーマットの設定
- `-repeats <number-of-repeats>|unlimited`: 繰り返しの要素表示の閾値の設定
- `-static-member [on|off]`: C++のstaticメンバの表示設定
- `-symbol [on|off]`: ポインタ表示時のシンボル名の表示設定
- `-union [on|off]`: 構造体内部の供用体の表示設定
- `-vtbl [on|off]`: C++のvirtual functioniテーブルの表示設定

== 式
`print`などのコマンドで引数にとる式は使用中の言語の任意の式を受け付けます。

その他にも言語に依存せず以下の演算が用意されています。
`
  @
`
メモリの一部を配列として扱います。
`
  ::
`
変数が定義されているファイルや関数を指定して変数を指定します。
`
  {<type>} <addr>
`
`addr`の値のメモリ位置を`type`型として解釈します。

== あいまいな式
`
  set multiple-symbols <mode>
`
式があいまいな場合の動作を設定します。設定できるものは以下の通りです。
- `all`: デフォルト。全ての選択肢を選択します。一位に選ぶ必要がある場合、メニューが表示されます。
- `ask`: あいまいさがある場合、常にメニューを表示します。
- `cancel`: あいまいさがある場合、エラーをはいてコマンドが中断されます。

== プログラム変数
式の変数は選択中のスタックフレームで解釈されます。
`
  <file>::<var>
`
とすると他の場所の変数も指定できます。

== 人工配列
`
  <arr>@<len>
`
の形で`arr`を最初の要素とする長さ`len`の配列として`&arr`からのメモリを表示します。

キャストでも同様の動作をさせることはできます。

== 出力フォーマット
デフォルトではGDBは型に沿って値を成型して表示します。
一方、フォーマットを指定して表示することもできます。

`
  x
`
バイナリを16進数で表示します。
`
  d
`
バイナリを10進数で表示します
`
  u
`
バイナリを符号なし10進数で表示します。
`
  o
`
バイナリを8進数で表示します。
`
  t
`
バイナリを2進数で表示します。
`
  a
`
アドレスを表示します。
`
  c
`
値を整数値にキャストして文字列として表示します。
`
  f
`
浮動小数として表示します。
`
  s
`
可能であれば文字列として扱います。
`
  z
`
ゼロ埋めされた16進数で表示します。
`
  r
`
rawフォーマットで表示します。

== メモリ検査
`
  x[/[<n>][<f>][<u>]] [<addr>]
`
- `n`: 表示するメモリ量(単位は`u`で指定)を指定
- `f`: フォーマットを指定
- `u`: 単位を指定。指定できるもの:
  - `b`: Byte
  - `h`: Halfwords(2Bytes)
  - `w`: words(4Bytes)
  - `g`: Giant words(8Bytes)
- `addr`: 開始アドレス

== メモリタグ
メモリ・タグは、ポインタを介したメモリ・アクセスを検証するために1対のタグを使用するメモリ保護技術である。タグは、アーキテクチャにもよるが、通常は数ビットからなる整数値である。

== 自動表示
ある式の値を頻繁に表示したい場合、自動表示が利用できます。
`
  display[/<fmt>] <expr>|<addr>
`
自動表示リストに`expr`を追加します。
`
  undisplay <dnums>...
`
自動表示リストから削除します。
`
  disable display <dnums>...
`
自動表示を無効化します。
`
  enable display
`
自動表示を有効化します。
`
  display
`
現在のリストの上の式の値を表示します。
`
  info display
`
自動表示リストを表示します。値は表示しません。
