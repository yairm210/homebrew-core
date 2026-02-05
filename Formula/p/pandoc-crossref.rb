class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.22b.tar.gz"
  version "0.3.22b"
  sha256 "f7ce5f637ca27169286ebc66c684a60bee379e0545ba7b5d75b439cf65a84a5e"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6427d2830bdbd460dc26263bd22b1e4ebf7b732826568b07533121f903e7ee8c"
    sha256 cellar: :any,                 arm64_sequoia: "14a2c83a5b056d6a1d8eee23c35463e979205f4dd82fc158d82044809c2f7a7e"
    sha256 cellar: :any,                 arm64_sonoma:  "7394497d168d588ffe6723b5c58c2fe90d2a227b0867c9ce9f9038caab48704a"
    sha256 cellar: :any,                 sonoma:        "7342140e7ded1bf08d39df44bcf1c205af28bd6017b4f7acd8ce068ae2f359f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac721d9d583ab185495ad485ac4b81731741dcf099c3ad642c3852fefcef0f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da452771807d84017865e73e7ae7665d70d8ed2da0e23f06c535f0f37d2efd1a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  # Fix pandoc upper bound to support pandoc 3.9, upstream bug report, https://github.com/lierdakil/pandoc-crossref/issues/503
  patch :DATA

  def install
    rm("cabal.project.freeze")

    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~MARKDOWN
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    MARKDOWN
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end

__END__
diff --git a/package.yaml b/package.yaml
index 3b8d7b6..c851445 100644
--- a/package.yaml
+++ b/package.yaml
@@ -30,7 +30,7 @@ data-files:
 dependencies:
   base: ">=4.19 && <5"
   text: ">=1.2.2 && <2.2"
-  pandoc: ">=3.8.2 && <3.9"
+  pandoc: ">=3.8.2 && <3.10"
   pandoc-types: ">= 1.23 && < 1.24"
 _deps:
   containers: &containers { containers: ">=0.1 && <0.9" }
diff --git a/pandoc-crossref.cabal b/pandoc-crossref.cabal
index ec6b1cf..18a6584 100644
--- a/pandoc-crossref.cabal
+++ b/pandoc-crossref.cabal
@@ -175,7 +175,7 @@ library
     , microlens >=0.4.12.0 && <0.5.0.0
     , microlens-mtl >=0.2.0.1 && <0.3.0.0
     , mtl >=1.1 && <2.4
-    , pandoc >=3.8.2 && <3.9
+    , pandoc >=3.8.2 && <3.10
     , pandoc-crossref-internal
     , pandoc-types ==1.23.*
     , text >=1.2.2 && <2.2
@@ -229,7 +229,7 @@ library pandoc-crossref-internal
     , microlens-mtl >=0.2.0.1 && <0.3.0.0
     , microlens-th >=0.4.3.10 && <0.5.0.0
     , mtl >=1.1 && <2.4
-    , pandoc >=3.8.2 && <3.9
+    , pandoc >=3.8.2 && <3.10
     , pandoc-types ==1.23.*
     , syb >=0.4 && <0.8
     , template-haskell >=2.7.0.0 && <3.0.0.0
@@ -259,7 +259,7 @@ executable pandoc-crossref
     , gitrev >=1.3.1 && <1.4
     , open-browser >=0.2 && <0.4
     , optparse-applicative >=0.13 && <0.20
-    , pandoc >=3.8.2 && <3.9
+    , pandoc >=3.8.2 && <3.10
     , pandoc-crossref
     , pandoc-types ==1.23.*
     , template-haskell >=2.7.0.0 && <3.0.0.0
@@ -289,7 +289,7 @@ test-suite test-integrative
     , directory >=1 && <1.4
     , filepath >=1.1 && <1.6
     , hspec >=2.4.4 && <3
-    , pandoc >=3.8.2 && <3.9
+    , pandoc >=3.8.2 && <3.10
     , pandoc-crossref
     , pandoc-types ==1.23.*
     , text >=1.2.2 && <2.2
@@ -325,7 +325,7 @@ test-suite test-pandoc-crossref
     , microlens >=0.4.12.0 && <0.5.0.0
     , microlens-mtl >=0.2.0.1 && <0.3.0.0
     , mtl >=1.1 && <2.4
-    , pandoc >=3.8.2 && <3.9
+    , pandoc >=3.8.2 && <3.10
     , pandoc-crossref
     , pandoc-crossref-internal
     , pandoc-types ==1.23.*
@@ -354,7 +354,7 @@ benchmark simple
   build-depends:
       base >=4.19 && <5
     , criterion >=1.5.9.0 && <1.7
-    , pandoc >=3.8.2 && <3.9
+    , pandoc >=3.8.2 && <3.10
     , pandoc-crossref
     , pandoc-types ==1.23.*
     , text >=1.2.2 && <2.2
