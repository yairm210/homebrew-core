class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.43.3.tar.gz"
  sha256 "95c77046cd346c2de68bcb4dfa0174be832f95c39981651a9a42c50373162b68"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d9cb770c0d95b28858fd6aba324ce7e6a7c6e53cdcdb2d67706b3fd73e25753"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d9cb770c0d95b28858fd6aba324ce7e6a7c6e53cdcdb2d67706b3fd73e25753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d9cb770c0d95b28858fd6aba324ce7e6a7c6e53cdcdb2d67706b3fd73e25753"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eba8be23ce24e9dfd84af6830f241d877f5e187742b222508df9f8a5e53783a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e00d3b97964514d31b8c69df6d0d2008da7f7cdf2d63f50cc8bfebfa5586df07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9adab8cceb72ba10344bbd8918d4343d9163d448d8f708aa65d8320c7125cf1d"
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
