class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.54.tar.gz"
  sha256 "a248dc450581affcb2a870dc6d9ebf7f5204997dd343764cc0bae909fe4d71ed"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "396abb7ea8685d50561a1abcc1a0415a1398b98a8fe61bbc1606e44d6e8ed133"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "396abb7ea8685d50561a1abcc1a0415a1398b98a8fe61bbc1606e44d6e8ed133"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "396abb7ea8685d50561a1abcc1a0415a1398b98a8fe61bbc1606e44d6e8ed133"
    sha256 cellar: :any_skip_relocation, sonoma:        "093adac712024d07e68fbb4c7ab6fa3664413e6c24ce172880eacb9c73c0cd41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bb10683ba84d7967fde4d5b0192cf38c23f4d1a5b594f9e88cbe15653ef74e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c86b2cb763e60e19dbfd8c715b947ec726f1d1585f1295c01a3bd1e095e460f3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nanobot-ai/nanobot/pkg/version.Tag=v#{version}
      -X github.com/nanobot-ai/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanobot --version")

    pid = spawn bin/"nanobot", "run"
    sleep 1
    assert_path_exists testpath/"nanobot.db"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
