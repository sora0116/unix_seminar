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

#let perf(cmd) = raw(cmd, block: true, lang: "shell")
#let options(pre: [文法:], name: "option name", desc: "description", ..con) = {
  pre
  table(
    columns: (2fr, 3fr),
    align: (_, y) => if y==0 {center} else {left},
    [#name], [#desc],
    ..con.pos().flatten()
  )
}
#let sep(text) = table.cell(colspan: 2)[#align(center)[#text]]
#let syn(text) = raw("  (lldb) "+text, block: true, lang: "shell")

#align(center+horizon)[#text(size: 2em)[Perf]]
#align(center)[Chapter 3]
#counter(heading).update(0)
#pagebreak()

= 導入
  PerfはLinux用のプロファイラツールです。
== コマンド
  perfはgitのように`perf <command>`の形式で各種ツールを使用します。
  サポートされるコマンドの一覧は`perf`で閲覧できます。
  ```shell
    $ perf

    usage: perf [--version] [--help] [OPTIONS] COMMAND [ARGS]

    The most commonly used perf commands are:
      annotate        Read perf.data (created by perf record) and display annotated code
      archive         Create archive with object files with build-ids found in perf.data file
      bench           General framework for benchmark suites
      buildid-cache   Manage build-id cache.
      buildid-list    List the buildids in a perf.data file
      c2c             Shared Data C2C/HITM Analyzer.
      config          Get and set variables in a configuration file.
      daemon          Run record sessions on background
      data            Data file related processing
      diff            Read perf.data files and display the differential profile
      evlist          List the event names in a perf.data file
      ftrace          simple wrapper for kernel's ftrace functionality
      inject          Filter to augment the events stream with additional information
      iostat          Show I/O performance metrics
      kallsyms        Searches running kernel for symbols
      kvm             Tool to trace/measure kvm guest os
      list            List all symbolic event types
      mem             Profile memory accesses
      record          Run a command and record its profile into perf.data
      report          Read perf.data (created by perf record) and display the profile
      script          Read perf.data (created by perf record) and display trace output
      stat            Run a command and gather performance counter statistics
      test            Runs sanity tests.
      top             System profiling tool.
      version         display the version of perf binary
      probe           Define new dynamic tracepoints
  ```
  一部のコマンドはカーネルで特殊なサポートを必要とするため使用できない場合があります。各コマンドのオプションの一覧を`-h`で出力することができます。

  例:
  ```shell
    $ perf stat -h

    Usage: perf stat [<options>] [<command>]

      -a, --all-cpus        system-wide collection from all CPUs
      -A, --no-aggr         disable CPU count aggregation
      -B, --big-num         print large numbers with thousands' separators
  ```
== イベント
  perfは測定可能なイベントのリストを表示することができます。イベントは複数のソースからなり、一つはコンテキストスイッチやマイナーフォルトなどのカーネルカウンタです。これをソフトウェアイベントと呼びます。

  もう一つはPerformance Monitoring Unit(PMU)と呼ばれるハードウェアです。PMUはサイクル数、リタイアした命令、L1キャッシュミスなどのマイクロアーキテクチャイベントを測定するためのイベントリストを提供します。これらのイベントをハードウェアイベントと呼びます。

  イベントの一覧は
  ```shell
    $ perf list
  ```
  で閲覧できます。

= statによるカウント
`perf stat`を使用することでプログラム実行時のイベントを集計できます。
```shell
  $ perf stat -e <event>[,<event>]... <command>
```
で`command`実行時の`event`の集計を行えます。

= recordによるサンプリング
`perf record`を使用することでプロファイル情報を収集して、`perf stat`よりも細かいソースコード、命令単位レベルで情報を見ることができます。
```shell
  $ perf record [<options>] <command>
```
#options(
  (`-g`, [コールグラフをレコード]),
  (`-o, --output <file>`, [出力ファイルを指定]),
)
= reportによるサンプルの解析
`perf record`で収集したサンプルを`report`コマンドで閲覧します。
```shell
  $ perf report
```
#options(
  (`-g, --call-graph`, [コールグラフを表示]),
  (`-i, --input <file>`, [読み込むファイルを指定]),
  (`--stdio`, [TUIではなく標準出力に表示]),
)
