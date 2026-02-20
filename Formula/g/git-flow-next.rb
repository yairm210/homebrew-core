class GitFlowNext < Formula
  desc "Modern implementation of the Git-flow branching model"
  homepage "https://git-flow.sh/"
  url "https://github.com/gittower/git-flow-next/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "2efe4fc1416ebf7018ae46954df67992afd187dd51d954e55a61b7bbf716bc23"
  license "BSD-2-Clause"
  head "https://github.com/gittower/git-flow-next.git", branch: "main"

  depends_on "go" => :build

  def install
    commit = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -s -w
      -X github.com/gittower/git-flow-next/version.BuildTime=#{time.iso8601}
      -X github.com/gittower/git-flow-next/version.GitCommit=#{commit}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"git-flow")
  end

  test do
    system "git", "init"
    system "git", "flow", "init", "--defaults"
    system "git", "flow", "config"
    assert_equal "develop", shell_output("git symbolic-ref --short HEAD").chomp
    assert_match version.to_s, shell_output("#{bin}/git-flow version")
  end
end
