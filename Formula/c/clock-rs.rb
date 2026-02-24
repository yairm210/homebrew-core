class ClockRs < Formula
  desc "Modern, digital clock that effortlessly runs in your terminal"
  homepage "https://github.com/Oughie/clock-rs"
  url "https://github.com/Oughie/clock-rs/archive/refs/tags/0.2.0.tar.gz"
  sha256 "9770f5d79408032d635a0eabe2cc70575b0238d8a02c9b5193dc5712a14b8e2d"
  license "Apache-2.0"
  head "https://github.com/Oughie/clock-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "888de832a36ffa73b7dd0ed3fb6550bc8ac3abb5b47a78790dbe38abe5e0fd6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2651ee346ebd462da982f5af9eaf61e5794c1a62832005c6c6bccc330587b9e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f729ff63af707b2934975a55748deb8d2aba7ebce2d61adb032c5217bafaf7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c007e99249690bd1132e53fb319494b4d8ed1c49d0df39e9d5337f6ad1d809a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2573b72f1ed8629305bcd5b147c33009c8845d307e6e61fd3a2688a954bd54d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0256aa75e5cc843eb60ef5ac7e16503a408fce37774eb5b77e1b01d1abcf6798"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "target/completions/clock-rs.bash" => "clock-rs"
    fish_completion.install "target/completions/clock-rs.fish"
    zsh_completion.install  "target/completions/_clock-rs"
  end

  test do
    # clock-rs is a TUI application
    assert_match version.to_s, shell_output("#{bin}/clock-rs --version")
    assert_match "error: unexpected argument '--invalid' found", shell_output("#{bin}/clock-rs --invalid 2>&1", 2)
  end
end
