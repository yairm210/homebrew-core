class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/4.7.0.tar.gz"
  sha256 "61ce6b948d5e154b66535f6c77ea29b426e7a99c7c17d11169e6b8c4b2a600ac"
  license "MIT"
  head "https://github.com/cheat/cheat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afdaee849ce7abd8d02a1c2d55c53e62cfccfc7686cc0fbad5f38956b0c73106"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afdaee849ce7abd8d02a1c2d55c53e62cfccfc7686cc0fbad5f38956b0c73106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afdaee849ce7abd8d02a1c2d55c53e62cfccfc7686cc0fbad5f38956b0c73106"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f728f8330dade5a50a75a5fd1d11010730599e60d75a0d0ecbbaa05d0767f3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5f044cce00a279fe2a92bfb608e3bd9fc5047d62c512e779040d90260c054a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "054f6915b9f88c875c913f40c74ba33b04a4fb035ae4c0761588da67991611ba"
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
