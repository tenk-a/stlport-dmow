この配布物は STLport ver.5.2.1 を、Windows環境のコンパイラ、主に、
Digitalmars C/C++ v8.56, Open Watcom ver1.9 でコンパイルできるよう
にしてみたモノです。きっちり修正できているかというとそういうわけ
でもないので注意。実験品の類で当然無保証。
ソースのみで、実際の .lib 等は自分でコンパイルする必要があります。

ビルド方法は、本家の build/ 環境を用いず我流(バッチ)です。
dm,ow 以外でもいくつかコンパイルを行えますが、dm,ow版の確認用の側面が
あるので性能は二の次になっているかもしれません。

※ dmc,ow以外で多少でもコンパイルしてみたものは、BCC 5.5.1(フリー版)、
   MinGW(32,64bit TDM版4.71)、vc(2003以降)で、確認作業用としては主に
   vc9を使用。

■配布ファイル＆ディレクトリ
・ 元からあるファイル・ディレクトリ
  doc/            元のドキュメント関係の一部(v5 以前のままの情報も多く)
  etc/            VSに対する設定ファイルとかチェンジログとか細々
  src/            ライブラリ・ソース
  stlport/        ヘッダ（ヘッダでincludeするソース)
  test/           テスト関係
    Compiler/     コンパイラの文法(のごく一部)確認用
    unittest/     ユニットテスト
    eh/           エラーハンドリングテスト

・追加したディレクトリ＆ファイル
  orig_files/     元配布に入っていたファイルで今回の版では使わなかったり
                  事情がかわったりしているファイルやディレクトリを入れたもの.
  docjp/          STLport関係ドキュメントの一部和訳.
  sample/         作成した stlport ライブラリを使うサンプル.
  setcc_stlp.bat  コンパイラ環境設定バッチ
  mk_stlp.bat     stlport コンパイル・バッチ (ライブラリ＆テスト)
  build_all.bat   mk_stlp.bat で主要なバージョンをひと通り生成するバッチ.
  readme.txt      このテキスト.
  stlport521dmow.txt  この配布版についての説明.

詳しくは stlport521dmow.txt を参照のこと。


ライセンスは元の README より
 --------------------------------------------------------------------------
 Copyright (c) 1994
 Hewlett-Packard Company
 Copyright (c) 1996-1999
 Silicon Graphics Computer Systems, Inc.
 Copyright (c) 1997
 Moscow Center for SPARC Technology
 Copyright (c) 1999-2003
 Boris Fomitchev

 This material is provided "as is", with absolutely no warranty expressed
 or implied. Any use is at your own risk.

 Permission to use or copy this software for any purpose is hereby granted 
 without fee, provided the above notices are retained on all copies.
 Permission to modify the code and to distribute modified code is granted,
 provided the above notices are retained, and a notice that the code was
 modified is included with the above copyright notice.
 --------------------------------------------------------------------------
修正分についても当然このライセンスです。
