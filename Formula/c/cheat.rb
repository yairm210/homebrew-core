class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/4.7.0.tar.gz"
  sha256 "61ce6b948d5e154b66535f6c77ea29b426e7a99c7c17d11169e6b8c4b2a600ac"
  license "MIT"
  head "https://github.com/cheat/cheat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7730db54330947a96359e8a660a6fb3ac32af8e024b45679251f7ad4286ca0d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7730db54330947a96359e8a660a6fb3ac32af8e024b45679251f7ad4286ca0d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7730db54330947a96359e8a660a6fb3ac32af8e024b45679251f7ad4286ca0d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3bdd47236b7db05b24110155f94dc5043817a1fe30143d3ab93088d8f268386"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd3826cde45a9711c987723968fd52703b97392648acd320d2f03ff415eca796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcf3232a4f6bb7159026496ec38098c25271f2cbfbda35045f28f631ea62403b"
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
