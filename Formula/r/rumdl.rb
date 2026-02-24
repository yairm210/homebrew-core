class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.28.tar.gz"
  sha256 "1d1d737d0e52f74d31bfda4a686e0132ce6e9c7015ece05905a68c094f9cf1e8"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e159ee132ac1bbafe8bc875452d50c22bc4d95259c9e8205231acebac7daa62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eae5b32d08a716013a0d2a9ef83848393000af1ac3491e5b8bf40a3cdc8d6ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c4b200f6f2053528ef9a385608a6aa4f4557fc7bec3964e053f5711543edb38"
    sha256 cellar: :any_skip_relocation, sonoma:        "c74ac8b8eefa633698f85acfba86887b123c4ea2ab044e2448b41b35ac47f07c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f61df9dbe22537b9c25f545998e0fdc126dfc299920a27a563f128f21740ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e09a6e947cd8ceaf0400d377fb1084271597c834aa1e9ada024a37244f6d90de"
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
