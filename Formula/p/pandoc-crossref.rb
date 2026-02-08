class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.23a.tar.gz"
  version "0.3.23a"
  sha256 "7b3638c8b8d416f28e950cf650c52d3e961f53ce6cc640133caf8ee99b2efade"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "142dc37ee88f270e5b74d3a8eacd46c46c22954dfc276856d3869f0991e45df5"
    sha256 cellar: :any,                 arm64_sequoia: "accd50ffef51a871b9d9d5b37098776aa8278621ddd5a683670855bd0adba916"
    sha256 cellar: :any,                 arm64_sonoma:  "d6ea32accdc7592b7f8d26d53a8fff4c4785976f4780b1aea8a5be763179a9f1"
    sha256 cellar: :any,                 sonoma:        "084f98f78bb4d9799f2bb0aa55a37276b5d052073abdc9105a0512899e29c402"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "899087e66b519e9d91b8d5dd73da6517b9aab9aac7a6f39579cb2baf99c73049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a056548c445e9ccf662e90310ca955481868997103af9c125a07adfe9ba9d920"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "libffi"
  uses_from_macos "zlib"

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
