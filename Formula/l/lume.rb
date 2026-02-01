class Lume < Formula
  desc "Create and manage Apple Silicon-native virtual machines"
  homepage "https://github.com/trycua/cua"
  url "https://github.com/trycua/cua/archive/refs/tags/lume-v0.2.58.tar.gz"
  sha256 "ff478f94ac740cca9860f0293ccf767bada70c8c0f233afdfe24c51f21e41237"
  license "MIT"
  head "https://github.com/trycua/cua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lume[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03720a48948c31366e2e618925de89c576f14fed0e3120a5ee1689b7b02854aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e557a73016fe5d1a27cb3735b8c3207a800e65df2c004deeb8f85ab073e91c79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3578a69119de2724108eeacb76ada1a066fab0bd8ed1be27ede605c53a223117"
  end

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64 # For Swift 6.0
  depends_on :macos

  def install
    cd "libs/lume" do
      system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "lume"
      system "/usr/bin/codesign", "-f", "-s", "-",
             "--entitlement", "resources/lume.entitlements",
             ".build/release/lume"
      bin.install ".build/release/lume"
    end
  end

  service do
    run [opt_bin/"lume", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/lume.log"
    error_log_path var/"log/lume.log"
  end

  test do
    # Test ipsw command
    assert_match "Found latest IPSW URL", shell_output("#{bin}/lume ipsw")

    # Test management HTTP server
    port = free_port
    pid = spawn bin/"lume", "serve", "--port", port.to_s
    sleep 5
    begin
      # Serves 404 Not found if no machines created
      assert_match %r{^HTTP/\d(.\d)? (200|404)}, shell_output("curl -si localhost:#{port}/lume").lines.first
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
