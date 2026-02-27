class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.56.tar.gz"
  sha256 "12bb3234b497d54d88f18a74c6bbc936b5da83af620c94d09b08746bcac9a00e"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "118208e66eb6ccc15f329c88c2410905fce7506fad2742a250ad16012e47c510"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "118208e66eb6ccc15f329c88c2410905fce7506fad2742a250ad16012e47c510"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "118208e66eb6ccc15f329c88c2410905fce7506fad2742a250ad16012e47c510"
    sha256 cellar: :any_skip_relocation, sonoma:        "7085546c6fe7e6b267602fa9038492aff1eadafca2b78bff596a165abe836396"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9734f34587327bfacdc8ba530d8bdc867718dd332bf4ecdc5c4e24a5a7c25550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e62f93b17098424621df08d984cb4eab5e4a7ab07c48bf16c35923e8ac6da4c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nanobot-ai/nanobot/pkg/version.Tag=v#{version}
      -X github.com/nanobot-ai/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"nanobot", shell_parameter_format: :cobra)
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
