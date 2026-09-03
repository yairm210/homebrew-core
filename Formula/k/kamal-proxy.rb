class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https://kamal-deploy.org/"
  url "https://github.com/basecamp/kamal-proxy/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "ed75954d6b9aa119d6e3853600b92ab80d9da029b5ed506be07efa016c7646a1"
  license "MIT"
  head "https://github.com/basecamp/kamal-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "478c74971a4fa286300ae1880211ffe67d9f11b03967de22b126da6e7b5e7018"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0978c00a32b8646ada7c683f15017ad06e6e5deeff9ae951819ac6f034c165e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb7443d081fea5fec0f4d28da1c91af52e6bda2fb5c5f311f33b40c8aa7edc17"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf864dd9aea86ee2f33e469fa39c48ba1124170e37b030f8a35b577b6ed53478"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72c88174507d978e9ffa83473089ec872a2aeb535258f84b00b39d73c42a2b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eb60afa749bd752d782ccd3557b4306f1bce197e195bac901b0fe17887a6684"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/kamal-proxy"
  end

  test do
    assert_match "HTTP proxy for zero downtime deployments", shell_output(bin/"kamal-proxy")

    read, write = IO.pipe
    port = free_port
    pid = fork do
      exec "#{bin}/kamal-proxy run --http-port=#{port}", out: write
    end

    system "curl -A 'HOMEBREW' http://localhost:#{port} > /dev/null 2>&1"
    sleep 2

    output = read.gets
    assert_match "Starting kamal-proxy", output
  ensure
    Process.kill("HUP", pid)
  end
end
