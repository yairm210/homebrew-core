class ClockRs < Formula
  desc "Modern, digital clock that effortlessly runs in your terminal"
  homepage "https://github.com/Oughie/clock-rs"
  url "https://github.com/Oughie/clock-rs/archive/refs/tags/v0.1.31.tar.gz"
  sha256 "dc8670d9922ed7b4b5ceb79a9e329f3a194c2c26edbba01655279b0c503d39d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "002bf576942dd9b68666682b720ee3ff566b23c4d6283cdcb3acd6d2cd733af7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83cd616af31d3557e81ce59788724ccc4abcfd467749ba584d37a8f1fa32b601"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e94146ab237c62d89a6b5cbc5e948bf456faa2c21b0c55ed365d5ebd73cc4c25"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f33b06dc2f2d1e8353815959bcfc66b8262952552f5cd8153d24188154dba95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b75baec67210c16e002c7703649ecc9186f7c2f3e89f1ddd808a35051d09b654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e00217eca643f38a182029b3bdc57a9710a1b6d73e4af8c139de5f8a1c73d14"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # clock-rs is a TUI application
    assert_match version.to_s, shell_output("#{bin}/clock-rs --version")
    assert_match "error: unexpected argument '--invalid' found", shell_output("#{bin}/clock-rs --invalid 2>&1", 2)
  end
end
