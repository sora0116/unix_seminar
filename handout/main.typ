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

== 表示設定
GDBは表示方法について以下の設定を提供しています。
`
  set print address [on|off]
`
スタックトレース、構造体の値、ポインタの値、ブレークポイントなどの場所を示すメモリアドレスを表示します。デフォルト値はonです。
`
  set print symbol-filename [on|off]
`
onのときシンボルのソースファイル名と行番号をアドレスのシンボル形式で表示します。
`
  set print max-symbolic-offset <max-offset>|unlimited
`
シンボリックアドレスを表示するオフセットの最大値を設定します。最大値以上のオフセットの場合は表示されません。0とunlimitedは等価で、前にシンボルがある限り常に表示します。
`
  set print symbol [on|off]
`
あるアドレスに対応するシンボルがあれば、それを表示します。
`
  set print array [on|off]
`
配列をきれいに整形して表示します。デフォルト値はoffです。
`
  set print array-indexed [on|off]
`
配列を表示する際に書く要素のインデックスを憑依します。デフォルト値はoffです。
`
  set print nibbles [on|off]
`
`print`コマンドを`/t`で表示する場合に4bitで区切って表示します。
`
  set print characters <number-of-characters>|elements|unlimited
`
GDBが表示する文字列の制限を設定します。`elements`を設定すると配列の大きさ分表示します。デフォルト値は`elements`です。
`
  set print elements <number-of-elements>|unlimited
`
GDBが表示する配列の要素数の上限を設定します。デフォルト値は200です。
`
  set print frame-arguments <value>
`
フレームを表示するときに引数の値をどのように表示するかを設定します。`value`に設定できる値は以下のとおりです:
- `all`: すべての引数が表示されます
- `scalars`: スカラー値の引数のみ表示します
- `none`: どの引数の値も表示しません。値は`...`で置き換えられます
- `presence`: 引数がある場合は`...`が、ない場合は何も表示されません
デフォルト値は`scalars`です。
`
  set print raw-frame-arguments [on|off]
`
フレームの引数をきれいに整形されていない生の状態で表示します。
`
  set print entry-values <value>
`
関数エントリ時のフレーム引数の値の表示を設定します。`value`に指定できる値は以下のとおりです:
- `no`: 実際のパタメータ値のみ表示し、エントリポイントからの値は表示しません
- `only`: エントリポイントからの値のみ表示し、実際の値は表示しません
- `preferrd`: エントリポイントからの値を表示し、それが不明で実際の値が既知の場合それを表示します
- `if-needed`: 実際の値を表示し、それが既知でない場合エントリポイントからの値が既知ならばそれを表示します
- `both`: 常にエントリポイントからの値と実際の値の両方を表示します
- `compact`: 実際の値およびエントリポイントからの値のうち既知の値を表示します。どちらも未知の場合optimized outを表示します。MIモードでない場合、両方の値が既知であれば短縮表記`param=param@entry=VALUE`を表示します
- `default`: 常に実際の値を表示します。エントリポイントからの値も既知の場合それも表示します。MIモードでなければ短縮表記を使用します。
デフォルト値は`default`です。
`
  set print frame-info <value>
`
フレームを表示するときに表示される情報を制御します。`value`に設定できる値は以下のとおりです:
- `short-location`: フレームレベル、PC(ソース行の先頭でなければ)、関数、引数を表示します
- `location`: `short-location`に加えソースファイルと行番号も表示します
- `location-and-address`: `location`に加え、ソース行の先頭でもPCを表示します
- `source-line`: PC(ソースの先頭でなければ)、行番号、ソース行を表示します
- `source-and-location`: `location`と`source-line`を表示します
- `auto`: 使用するコマンドによって自動的に表示される情報を決定します。
デフォルト値は`auto`です。
`
  set print repeats <number-of-repeats>|unlimited
`
配列の繰り返し要素の表示を抑制する閾値を設定します。配列の連続した同一要素の数が閾値を超えると`<repeats n times>`を表示します。0とunlimitedは同等です。デフォルト値は10です。
`
  set print max-depth <depth>|unlimited
`
ネストした構造体を省略記号に置き換える深さの閾値を設定します。
`
  set print memory-tag-violations [on|off]
`
ポインタとアドレスを表示するときにメモリタグ違反に関する情報を表示します。
`
  set print null-stop [on|off]
`
文字列を表示するときに最初のNULLで表示を停止するかどうかの設定です。デフォルト値は`off`です。
`
  set print pretty [on|off]
`
構造体を整形して表示するかどうかの設定です。
`
  set print raw-values [on|off]
`
値のための整形を行わず生の値を表示するかどうかの設定です。
`
  set print sevenbit-strings [on|off]
`
8bit文字を`\nnn`という形式で表示します。
`
  set print union [on|off]
`
構造体や他のユニオンに含まれるユニオンを表示するかどうかの設定です。デフォルトはonです。

以下はC++関連の設定です。
`
  set print demangle [on|off]
`
C++の名前を型安全リンケージのためにアセンブラやリンカに渡すmangle形式ではなくソース形式で表示します。デフォルト値はonです。
`
  set print asm-demangle [on|off]
`
アセンブラコードの表示時にmangled形式でなくソース形式で表示します。デフォルト値はoffです。
`
  set demangle-style [<style>]
`
C++の名前を表現するためにエンコーディングスキームを選択します。`style`を省略すると設定可能なスタイルのリストが表示されます。デフォルト値は`auto`です。
`
  set print object [on|off]
`
オブジェクトへのポインタを表示する場合、仮想関数テーブルを使用して、宣言された型ではなく、オブジェクトの実際の型を識別します。
`
  set print static-members [on|off]
`
C++オブジェクトの静的メンバを表示します。デフォルト値は`on`です。
`
  set print pascal_static-members [on|off]
`
パスカルのオブジェクトを表示するときに静的メンバを表示します。デフォルト値は`on`です。
`
  set print vtbl [on|off]
`
C++仮想関数テーブルをきれいに表示します。

== きれいな表示
=== pretty-printer導入
GDBが値を表示するとき、まずその値に対応するpretty-printerが登録されているか確認します。あればそれを呼び出し、なければ通常通り表示されます。


=== pretty-printerの例
C++の`std::string`はpretty-printerなしでは
`
$1 = {
  static npos = 4294967295, 
  _M_dataplus = {
    <std::allocator<char>> = {
      <__gnu_cxx::new_allocator<char>> = {
        <No data fields>}, <No data fields>
      },
    members of std::basic_string<char, std::char_traits<char>,
      std::allocator<char> >::_Alloc_hider:
    _M_p = 0x804a014 "abcd"
  }
}
`
のように表示されます。これをpretty-printerに通すと
`
$2 = "abcd"
`
と表示されます。

=== prety-printerのコマンド
`
  info pretty-printer [object-regexp [name-regexp]]
`
インストールされているpretty-printerを名前とともにリストアップします。
`
  disable pretty-printer [object-regexp [name-regexp]]
  enable pretty-printer [object-regexp [name-regexp]]
`
pretty-printerを無効化、有効化します。

== 値の履歴
