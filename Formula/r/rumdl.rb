class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.30.tar.gz"
  sha256 "881008de2b2b9aec8daf02db07b2149489340b18070923043d45269d4228d56a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "874e45c52d859325ec7d635cc08d86fb72bb453a84749bd90be41a33dd8cbf8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ad5c0151337ea4a53dfad20493e372deb264c68708421ada2434e2db89a8648"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da0852e60c87ed11a880b37aca2b2ddf1a16877a6dc2850093cef44fd7c72048"
    sha256 cellar: :any_skip_relocation, sonoma:        "27ca02164427b6c63ac42dd9ed6d948cf3681d14a3292c3c9fb21836d01cc11b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c753cbe0d5792b97d0b6107fb703621b112979d49daf006296072931e953d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "749c428e4c3f4997b15cc21e016f21e87a14d6f02d1b9d0b2cb501f1d689b1ce"
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
