class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "38c62f8be98fdd76daecd4e94a5afa694564994c0ea56877f2b62e0a4ed615a8"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "160ca44ea352b780d9db37820f8b8c7e649784e036277acd8e41d989e5ef65b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6895ca9ded2995edc702d42bb6df7bb7ecf17f98a64ccff975b12489c1c85ffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b01039bf9c582d3afacccac47758c5a4d1111fe8070fc198e5a519c4f91da73"
    sha256 cellar: :any_skip_relocation, sonoma:        "79354ccaf07b78d6a33abee003481efc4288f3ff1412e21ede164129c0e4de60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b02aa2caf2a95b6f6eddb6cefab80736b7243a1152b17fddf7850c86dd23a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1649aaf8fb85d0bd9dd177389c543ec8302ec3d124b50467c39814f349d2fe1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
