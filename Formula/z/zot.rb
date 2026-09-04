class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.59.tar.gz"
  sha256 "cc02b35dee7d7628f23a180ea39629c34434490c8fc54faf9b541241acaccd01"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ba951883f03b6e9f59d4b044eb910167212d54239d491ca5b5a6f0018b8487c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ba951883f03b6e9f59d4b044eb910167212d54239d491ca5b5a6f0018b8487c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ba951883f03b6e9f59d4b044eb910167212d54239d491ca5b5a6f0018b8487c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d46a1a74de55b3d751792aa3dc362529a6fe684ce1ce0be53f878905a0465895"
    sha256 cellar: :any,                 x86_64_linux:  "409914d054ec74cf5648f551a81381503c176b2da1d583417e5ccc31263f9763"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
