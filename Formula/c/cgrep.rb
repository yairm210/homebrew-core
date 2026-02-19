class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://awgn.github.io/cgrep/"
  url "https://hackage.haskell.org/package/cgrep-9.1.0/cgrep-9.1.0.tar.gz"
  sha256 "0bcdc712fcf21422a51338a7a152e3d3095343f595fd600f0e6e530b6565ecff"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "37bd0ff627442bba40b99ec4ece6957d02008f611dfc534a76100b7f9a8caf3e"
    sha256 cellar: :any,                 arm64_sequoia: "ae4697fe71f6e15c595da258cea8289c32ef234d99b91580090d9edd48a738e8"
    sha256 cellar: :any,                 arm64_sonoma:  "caddb9e8b415c6ea98cb60a47c6b5037507186833e8db354bbb8913fe50bd1f5"
    sha256 cellar: :any,                 sonoma:        "43a71f50530e480907517a299f1001c590049529f4b89ea198551c5cb6f20cc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44050fc6cbd4cedae9941e3182684c12acfef6ecd08ce71e80fe6c0d1a80756e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8d9852362ac5b03d08e1c3fcb6679e02962f1f8e8874c5ae6f3644b3fd38304"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  conflicts_with "aerleon", because: "both install `cgrep` binaries"

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    (testpath/"t.rb").write <<~RUBY
      # puts test comment.
      puts "test literal."
    RUBY

    assert_match ":1", shell_output("#{bin}/cgrep --count --comment test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --literal test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --code puts t.rb")
    assert_match ":2", shell_output("#{bin}/cgrep --count puts t.rb")
  end
end
