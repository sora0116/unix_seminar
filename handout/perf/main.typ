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

// = プロファイラ
  // == プロファイラとは
  // プロファイラはプログラム実行時の動作を解析(プロファイル)するツールのことをいいます。解析できるものは例えば使用メモリ量、キャッシュミス率や実行サイクル数、関数ごとの処理の時間などがあります。これを用いることでコードの改善すべき部分を発見しやすくなります。

  // == perf
  // perfはLinux向けの性能解析ツールです。
  // 以下ではperfの使い方を解説します。

  // === コマンド
  // perfはgitコマンドのようにサブコマンドを指定することで様々な機能を使用することができます。利用できるサブコマンドを以下に示します(このリストは引数なしで`perf`を実行することで閲覧できます。):
  // ```shell
  // $ perf

  //  usage: perf [--version] [--help] [OPTIONS] COMMAND [ARGS]

  //  The most commonly used perf commands are:
  //    annotate        Read perf.data (created by perf record) and display annotated code
  //    archive         Create archive with object files with build-ids found in perf.data file
  //    bench           General framework for benchmark suites
  //    buildid-cache   Manage build-id cache.
  //    buildid-list    List the buildids in a perf.data file
  //    c2c             Shared Data C2C/HITM Analyzer.
  //    config          Get and set variables in a configuration file.
  //    daemon          Run record sessions on background
  //    data            Data file related processing
  //    diff            Read perf.data files and display the differential profile
  //    evlist          List the event names in a perf.data file
  //    ftrace          simple wrapper for kernel's ftrace functionality
  //    inject          Filter to augment the events stream with additional information
  //    iostat          Show I/O performance metrics
  //    kallsyms        Searches running kernel for symbols
  //    kvm             Tool to trace/measure kvm guest os
  //    list            List all symbolic event types
  //    mem             Profile memory accesses
  //    record          Run a command and record its profile into perf.data
  //    report          Read perf.data (created by perf record) and display the profile
  //    script          Read perf.data (created by perf record) and display trace output
  //    stat            Run a command and gather performance counter statistics
  //    test            Runs sanity tests.
  //    top             System profiling tool.
  //    version         display the version of perf binary
  //    probe           Define new dynamic tracepoints

  //  See 'perf help COMMAND' for more information on a specific command.
  // ```
  // 各コマンドのヘルプは`-h`をつけて実行することで閲覧できます。

  // `top`の場合:
  // ```shell
  // $ perf top -h

  // Usage: perf top [<options>]

  //   -a, --all-cpus        system-wide collection from all CPUs
  //   -b, --branch-any      sample any taken branches
  //   -c, --count <n>       event period to sample
  //   -C, --cpu <cpu>       list of cpus to monitor
  // [以下略...]
  // ```

  // === イベント
  // perfは各種イベントを測定します。
  // `perf list`で観測可能なイベントのリストを表示できます。

  // 例:
  // ```shell
  // $ perf list

  // List of pre-defined events (to be used in -e or -M):

  //   duration_time                                      [Tool event]
  //   user_time                                          [Tool event]
  //   system_time                                        [Tool event]
  // ```

  // === stat
  // perfはサポートされている全てのイベントについてプロセスの実行中にカウントを保持することができます。カウントモードではイベントの発生を集計し、アプリケーション終了後に表示されます。これらの統計情報を生成するには`stat`サブコマンドを使用します。

  // 例えば:
  // ```shell

  // ```

  // ==== 制御するイベントの選択
  // perfツールの実行ごとに1つ以上のイベントを計測することができます。イベントは`-e`で指定できます。

  // 例えば:
  // ```shell
  //   # perf stat -e cycles ./a.out
  // ```

  // ==== 修飾子
  // 各イベントには指定子をつけることができます。指定子の一覧を以下に示します。
  // #align(center)[#table(columns: 3, align: left,
  //   [Modifiers],[#align(center)[Description]],[Example],
  //   [u],[ユーザレベルで監視します],[event:u],
  //   [k],[カーネルレベルで監視します],[event:k],
  //   [h],[仮想環境でハイパーバイザーイベントを監視します],[event:h],
  //   [H],[仮想環境でホストマシンを監視します],[event:H],
  //   [G],[仮想環境でゲストマシンを監視します],[event:G],
  // )]

  // ==== ハードウェアイベント
  // ハードウェアのドキュメントに記載されているPMUを測定するには16進数でパラメータコードを渡します。

  // 例えば:
  // ```shell
  //   # perf stat -e r1a8 -a sleep 1
  // ```

  // ==== 複数のイベント
  // カンマで区切って複数のイベントを指定できます。
  // ```shell
  //   # perf stat -e cycles,instructions,cache-misses ...
  // ```

  // ==== 繰り返し測定
  // `-r`で複数回実行して各カウントについて平均からの標準偏差を取ることができます。

  // 例えば:
  // ```shell
  //   # perf stat -r 5 sleep 1
  // ```

  // === recordによるサンプルの収集
  // `record`コマンドを使うことで分析のためのサンプル収集を行うことができます。

  // 例えば
  // ```shell
  //   # perf record <program>
  // ```

  // === reportによるサンプルの解析

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

  さらにperf_eventsインターフェースは一般的なハードウェアイベントの小さなセットも提供します。各プロセッサにおいて
=== ハードウェアイベント
= statによるカウント
== イベント選択オプション
== 環境選択オプション
== 出力管理オプション
= recordによるサンプリング
== イベントベースサンプリングの概要
=== デフォルトイベント: サイクルカウント
=== Periodとrate
== サンプルの収集
== プロセッサワイドモード
== Flame Graph
== Firefox Profiler
= reportによるサンプルの解析
== 出力制御オプション
== カーネルレポート制御オプション
== プロセッサワイドモード
== オーバーヘッド計算
= annotateによるソースコードレベルの解析
== カーネルコード上でannotateを使う
= topによるライブ解析
= benchによるベンチマーク
== sched: スケジューラベンチマーク
== mem: メモリアクセスベンチマーク
== numa: NUMAスケジューリングとMMベンチマーク
== futex: Futexストレスベンチマーク
= トラブルシューティングとチップス
== ファイルオープンの制限
=== 制限を増やす
== build-idによるバイナリの識別
=== build-idキャッシュ
== アクセス制御
= その他のシナリオ
== スリーブ時間のプロファイル
= その他のリソース
== Linuxソースコード

#outline(indent: 1em)
