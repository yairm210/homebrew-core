class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "78d94c0a6abbff9e7f75f49180817126423d30e310e3833665a55051fc525cbb"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66fd612b55689a3b5682e47464992e4b6dbcebb3d56cb7879dabb3bb1921e4b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36ea56d100a918150728a2c499924fc25595231db313a1f93e25b5dd32e65b2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a663225b4382cf61c22a0c048a47e5a0c807c6466a25a83d1f850e91ab4e47ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bd51a4a5bd107e8a6fc0d9da019323a55c5a3c92ad1200a2e2c06da03500aca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b897401a56a3bb5325d8a0749db12228af66d2b57563c870a1269adcb6c1018f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "272fd2ab80a5f76ed8397c0e493737ec82a1e77689036c21171f19c9448b442f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end
