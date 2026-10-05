class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "528b02ed18f35f556722218c536a10acbc484f64e843a426e8f34dd50b7fa531"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "42eb0dc131cbbf28c8197d0d7e045591a1df623ba3cd1c7ffa539ac0808db5c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "294a53c289bf98b90a429036a36c5279123fd48b9c5ea8ca5594f038103c32f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a35aac7636330b5fcd0d78507fe2c36f0314a4df89c37da1de62e976c7e1419"
    sha256 cellar: :any,                 arm64_linux:       "367f6a60a0a32536899a1699a4c64b7e5fc96c0ae1c8c2376c34b991c02f5472"
    sha256 cellar: :any,                 x86_64_linux:      "04df09960786ce1a58797d9a780362f244a5d6c1964ebf7d61aaadd01ccbbc67"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end
