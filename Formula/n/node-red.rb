class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-5.0.6.tgz"
  sha256 "bc37ccced0441d6d4b24e76dcdabef89f02c5a10a96cf8f623e5b0eb5db47352"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c0c669d9b462aae119bce6b864a175ea1c2abab3a237dabb3fb4684a3e186c8a"
    sha256 cellar: :any,                 arm64_sequoia: "c0c669d9b462aae119bce6b864a175ea1c2abab3a237dabb3fb4684a3e186c8a"
    sha256 cellar: :any,                 arm64_sonoma:  "c0c669d9b462aae119bce6b864a175ea1c2abab3a237dabb3fb4684a3e186c8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6807f1dd148f3540fdc565f907ec829a4d7fd9b0f00aec6e40f571ad45632d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76a371c0c5cac78a0cffa30bede2dc91a9bef505f3a7ef5b340d935717d5057a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  service do
    run [opt_bin/"node-red", "--userDir", var/"node-red"]
    keep_alive true
    require_root true
    working_dir var/"node-red"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/node-red --version")

    port = free_port
    pid = fork do
      system bin/"node-red", "--userDir", testpath, "--port", port
    end

    begin
      sleep 5
      output = shell_output("curl -s http://localhost:#{port}").strip
      assert_match "<title>Node-RED</title>", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
