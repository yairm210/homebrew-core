class Adrs < Formula
  desc "Architectural Decision Record tool in Rust"
  homepage "https://joshrotenberg.com/adrs/"
  url "https://github.com/joshrotenberg/adrs/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "26ba39328efab570589d7bebd98b05b1bc6bfce746716fdb1d2896c8cee2a6c3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/joshrotenberg/adrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1517b8e43bcf5b2bb6122a8e7bae235fa05a6c9749809ab2eda5434aa44e7d7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "593aad3d8ee22f858e864e6908b57d26ef5496e112cbd70ecdbeaa8f4d574776"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d45f17d2d1e1486773ca058a3c0674301537d26eb0122b1d64745d4f825aa3b"
    sha256 cellar: :any,                 arm64_linux:   "0191d67fcfe53ba13b51c2e928a44cbee78a6c39ddc9f2da53c79af80b41e64b"
    sha256 cellar: :any,                 x86_64_linux:  "7b8aac0cae1c5e8ee0c8b7fd57ab565fe573ce372ae7e4b8ac91aa772cb539b2"
  end

  depends_on "rust" => :build

  deny_network_access! [:postinstall, :test]

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/adrs")
    generate_completions_from_executable(bin/"adrs", "completions")
  end

  test do
    # Exercise `adrs doctor` as a CI lint gate: it exits 0 for advisory findings
    # and non-zero for structural errors. Drive a sample ADR through the
    # advisory path — ADR014 (advisory: placeholder text left in a fresh template)
    system bin/"adrs", "init", "docs/decisions"

    # init seeds a Nygard-format ADR; drop it so the demo below is MADR-only.
    (testpath/"docs/decisions/0001-record-architecture-decisions.md").unlink

    system bin/"adrs", "new", "--format", "madr", "--no-edit",
           "Use Homebrew for software installation"
    assert_match "ADR014", shell_output("#{bin}/adrs doctor")

    assert_match version.to_s, shell_output("#{bin}/adrs --version")
  end
end
