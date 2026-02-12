class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.2.10.tar.gz"
  sha256 "7eaace452a4b717b07ebe2ee9f11c1d1d4d5cb7d7f1aa7027a1ee28a019ffcd0"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "735f05c2ee99a27f425d39761da2ed75e08ed703aa133f893f9af1f306d6901c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da90a13316b98f010b06df61565d407df37a47af661ed274955773d2c020e8c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b847a09a6f7ebfbfd1e514647e2261a63e5e95212eec5cb605c05ee0fae809a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e065ff832d7f9f95cb7508247731572bfab91a3becb607612ffb5542b01d74fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa1d419c88a322fbe3f80d85ed23c15a2d833c2a4c0189ab65bd7a5ee8545233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4dbc3edbba05ef814801f55ba559a2989fa2c4652cad38cb95389998106d9fd"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish/vendor_conf.d/mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end
