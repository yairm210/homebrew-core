class Lazyjournal < Formula
  desc "TUI for logs from journalctl, file system, Docker, Podman and Kubernetes pods"
  homepage "https://github.com/Lifailon/lazyjournal"
  url "https://github.com/Lifailon/lazyjournal/archive/refs/tags/0.8.5.tar.gz"
  sha256 "2cfc8aa53c195a1ad7b7a6c3f9b17652eac4c24863d8c1079e61acf9497819c1"
  license "MIT"
  head "https://github.com/Lifailon/lazyjournal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d60ad451b8301fbb64cdcece0b8da356daa25c1459ef21edce05caf5c25a17f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d60ad451b8301fbb64cdcece0b8da356daa25c1459ef21edce05caf5c25a17f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d60ad451b8301fbb64cdcece0b8da356daa25c1459ef21edce05caf5c25a17f"
    sha256 cellar: :any_skip_relocation, sonoma:        "03c4d1a90a6ffbeb4ba00df4e07f6d25a3ab8240f633a78c1a53b632c9595d6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5db94f08841d06a917139e9244b6fb057c7699b836b71fcd2a782ac0fc282264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae0d2f165d0cdd65d0c6d134daad5fe9367fc371f87579aff343c9824d8cf28e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.buildSource=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyjournal --version")

    require "pty"
    PTY.spawn bin/"lazyjournal" do |_r, _w, pid|
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
