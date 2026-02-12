class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "444a958bfdb9683cbc43de630e4f52622721189698695aad2ef6d4b3f233b9ff"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f3b735a8cbc5ef416f539657997ed4df3112f1d3366c8d5e5b5e03dafb9255f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b52ec6f82572dba1f8a122830afd9455426f60b2868959bc9d0a4f17117d41ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63246bbe20a9b570e1bc338af5facda74dca47e53605e7375531d04ed7d20f32"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c57dc4049151d9353bf348400146ee7c5cf7b2f187a461b83068aee7f96803e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b9ae0e52f1ed5685a3548582121a09a38278961a6e59ebf2a250838052ac6d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfcb606f9a7560d20c36a326cc26e19505b4f18c11a0c276a2d6325d64adb7e0"
  end

  depends_on "rust" => :build

  def install
    # Restore default features when frizbee supports stable Rust
    # Issue ref: https://github.com/skim-rs/skim/issues/905
    system "cargo", "install", "--no-default-features", "--features", "cli", *std_cargo_args

    generate_completions_from_executable(bin/"sk", "--shell")
    bash_completion.install "shell/key-bindings.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    man1.install buildpath.glob("man/man1/*.1")
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end
