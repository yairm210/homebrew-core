class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.55.tar.gz"
  sha256 "f7750dfcd943573c4ae30046879b4a3290b3bdba510e941c4490ea2e82c8282d"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b125d668ca252514b0b0a4ac40bf13892af6a8392c0de84309febab2a3255cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b125d668ca252514b0b0a4ac40bf13892af6a8392c0de84309febab2a3255cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b125d668ca252514b0b0a4ac40bf13892af6a8392c0de84309febab2a3255cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c3541a5f4d8b0dcd557b38c719e9981b98098611250651f8f1deb5dfab43c8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c86df83387b281edc68c39adb6dc93b9fee53ee2fa13ebeda868e194f411339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3416a132aa55654ba62225c6331f34bce92b8720a9468c877f771cb6e2293a3f"
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
