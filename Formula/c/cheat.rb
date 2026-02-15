class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/4.5.2.tar.gz"
  sha256 "d6f7ab84bc60842ba5a5bb3543297d2c04f073e00740286585b3bca7cebe8c4f"
  license "MIT"
  head "https://github.com/cheat/cheat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71e2689795a69384bc9271eaa07fc2c9371a028d721057bba0f19529d3cfcee1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71e2689795a69384bc9271eaa07fc2c9371a028d721057bba0f19529d3cfcee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71e2689795a69384bc9271eaa07fc2c9371a028d721057bba0f19529d3cfcee1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b908eab72d744511cd90a09284815d7f9854925e2e3bf8476dfd1043c34aa21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa3fc04d849fe8542f56bcee6f3f72d66bf613504d4ec1956807dbb374f28f85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66767effc95bbb28d835ead2de407030043d46ecf0130f211b65edb89f6b0ed9"
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", because: "both install a `cheat` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash" => "cheat"
    fish_completion.install "scripts/cheat.fish"
    zsh_completion.install "scripts/cheat.zsh" => "_cheat"
    man1.install "doc/cheat.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "cheatpaths:", output
  end
end
