class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.43.1.tar.gz"
  sha256 "7b06b45ded3c3b16076955fc06efebcd418b7d82bc59aee9abc5e6587e684f2a"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa3eb1a9d81b345d46c2a8bf8c5f246e861fda665a528286ad0aa19c4b70bb67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa3eb1a9d81b345d46c2a8bf8c5f246e861fda665a528286ad0aa19c4b70bb67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa3eb1a9d81b345d46c2a8bf8c5f246e861fda665a528286ad0aa19c4b70bb67"
    sha256 cellar: :any_skip_relocation, sonoma:        "6492921cd6b7f6a8138114f2e6d3bba3e0a9d33e94516a5ce6ed042112143fd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9ba7758593b73b8343d3a102c6c41c1d8704d543a19cf62353676b01bc5fec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eebcae820e63cd5b14d5a5aeeb80119a7ed169c6b4cf055c2f7a13123bf6aa63"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"

    bash_completion.install "cmd/autocomplete/scripts/scalingo_complete.bash" => "scalingo"
    zsh_completion.install "cmd/autocomplete/scripts/scalingo_complete.zsh" => "_scalingo"
  end

  test do
    expected = <<~END
      ┌───────────────────┬───────┐
      │ CONFIGURATION KEY │ VALUE │
      ├───────────────────┼───────┤
      │ region            │       │
      └───────────────────┴───────┘
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
