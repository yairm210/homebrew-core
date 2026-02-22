class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "6605166dc47b179af0d3e9714dba83254b633e78d6b0bc2189592c5067b0ccf2"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "207df90982a246096dd229f68f90440106c068de5e23f880d1d6f650d17c1944"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "207df90982a246096dd229f68f90440106c068de5e23f880d1d6f650d17c1944"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "207df90982a246096dd229f68f90440106c068de5e23f880d1d6f650d17c1944"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9f3bbb181b1be833de8ef518fe731b12dfdab837a965187b36885a8e3df3843"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a4964013504d7e914bb45963f1e832173873a7512c62652b04e0473ffffd09a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6775405c0ac27cb37f6da0fd7675412c09a9177e83a73a6e0290dfcbea9049e"
  end

  depends_on "go" => :build

  conflicts_with "ghostscript", because: "both install `gs` binary"

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"git-spice")
    bin.install_symlink "git-spice" => "gs"

    generate_completions_from_executable(bin/"gs", "shell", "completion")
    generate_completions_from_executable(bin/"git-spice", "shell", "completion")
  end

  def caveats
    <<~EOS
      The executable has been renamed to 'git-spice'.
      To ease the transition, this release also symlinks 'gs' to 'git-spice'.
      The symlink will be dropped in a future release.
      If you prefer to use 'gs', add an alias to your shell configuration:

        alias gs='git-spice'
    EOS
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"

    assert_match "main", shell_output("#{bin}/git-spice log long 2>&1")

    output = shell_output("#{bin}/git-spice branch create feat1 2>&1", 1)
    assert_match "error: Terminal is dumb, but EDITOR unset", output

    assert_match version.to_s, shell_output("#{bin}/git-spice --version")
  end
end
