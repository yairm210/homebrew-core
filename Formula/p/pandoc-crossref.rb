class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.22b.tar.gz"
  version "0.3.22b"
  sha256 "f7ce5f637ca27169286ebc66c684a60bee379e0545ba7b5d75b439cf65a84a5e"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "528b3f91d2ea0a7d05ab1cd32081f7c7659807dd7e4327ec10a783d4e98e2271"
    sha256 cellar: :any,                 arm64_sequoia: "630a5c00e8f2723e560a44942ad4ab8f186a395ba75c67b034324b0efef80f97"
    sha256 cellar: :any,                 arm64_sonoma:  "352065d71cf5ea6dc06da75e8f2a913d86356c3671b4d8fb39fe363e178fbc7b"
    sha256 cellar: :any,                 sonoma:        "7cb8dbeea448be750cd49848a2be7c4b0439f786431dc4ff0fb73f761d4c1276"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40c2ee6a13e4f1945d558caf145ead90d950ad3252cc9878ed52f6d2fb667950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63595278b847e03fd84635d14b6faf9df7d4ac9bbc9c3ef349a6796e71b0ed60"
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
