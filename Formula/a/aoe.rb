class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "4a255c3c43adb942f1e1e883b0120cdf4826643a4bf854bd7a171f730d73cb7c"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3548f7acbb9d6e8f6dbe5229cb691a3fb642d61c05efb28bd5484016e2988712"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74d084f2ad8c4b35b140ec632f674e17561ba684da5102e5ac00842704b83df2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c52644714d027b0d0c69077cdac947e4f93d9aa2748c330f8b1dd801c534ddf8"
    sha256 cellar: :any,                 arm64_linux:   "fd85142304a575db7e14e3bcc83672baba13017ab9439d9311c6f9bc4e72b0f3"
    sha256 cellar: :any,                 x86_64_linux:  "9f6da2318f672ba7fb6dfba5170d0933b0e355533d626863928d42d23edda2ca"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "serve")
    generate_completions_from_executable(bin/"aoe", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]

    port = free_port
    pid = fork do
      exec bin/"aoe", "serve", "--port", port.to_s, "--no-auth"
    end
    sleep 2
    assert_match "Agent of Empires", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
