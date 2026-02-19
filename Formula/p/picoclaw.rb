class Picoclaw < Formula
  desc "Ultra-efficient personal AI assistant in Go"
  homepage "https://github.com/sipeed/picoclaw"
  url "https://github.com/sipeed/picoclaw/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "973faa529b144954a2a8d2212b80895641676ff0736c1488d0ad1fd70793fe53"
  license "MIT"
  head "https://github.com/sipeed/picoclaw.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "generate", "./cmd/picoclaw"

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/picoclaw"
  end

  service do
    run [opt_bin/"picoclaw", "gateway"]
    keep_alive true
  end

  test do
    ENV["HOME"] = testpath
    assert_match version.to_s, shell_output("#{bin}/picoclaw version")

    system bin/"picoclaw", "onboard"
    assert_path_exists testpath/".picoclaw/config.json"
    assert_path_exists testpath/".picoclaw/workspace/AGENT.md"

    assert_match "picoclaw Status", shell_output("#{bin}/picoclaw status")
  end
end
