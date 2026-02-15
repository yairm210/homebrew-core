class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/4.6.0.tar.gz"
  sha256 "9da4c8965440dd05a12c54da92a29f11544164e3f76844c0c1935c36f905d565"
  license "MIT"
  head "https://github.com/cheat/cheat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "597c897a7ce4f56f34228450086081c762010cab96a2a9d70b2a1f808fec3ee2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "597c897a7ce4f56f34228450086081c762010cab96a2a9d70b2a1f808fec3ee2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "597c897a7ce4f56f34228450086081c762010cab96a2a9d70b2a1f808fec3ee2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9624aec6c31f9dce6a9511154ae7b8293d0b81c9155f15b9f7b5657b7ed8bfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac763bc932d7180ff24fae8e4b07be11feb5990d7cefb0072ff0fc1bf441835d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f71316d4108d4dbf6352f2cb83bd56d8cc0a79ab86deb1dd000930715e5be2dd"
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
