class ClaudeAgentAcp < Formula
  desc "Use Claude Code from any ACP client such as Zed!"
  homepage "https://github.com/zed-industries/claude-agent-acp"
  url "https://registry.npmjs.org/@zed-industries/claude-agent-acp/-/claude-agent-acp-0.17.1.tgz"
  sha256 "a21fe5d56cb4fdd528de447192adbb979c77a0af7f010ffc69e240271460a6a1"
  license "Apache-2.0"
  head "https://github.com/zed-industries/claude-agent-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aef4ab363dd0ee5c0fea05041d86a894620218832c117cbd193f97364034a81c"
    sha256 cellar: :any,                 arm64_sequoia: "857eb1f07eb00bb52e1623c4255c7905814cca376be841c24d38fad8cd30984b"
    sha256 cellar: :any,                 arm64_sonoma:  "857eb1f07eb00bb52e1623c4255c7905814cca376be841c24d38fad8cd30984b"
    sha256 cellar: :any,                 sonoma:        "50f706dec727eba6d5531d2465df10b14d70d98bff51cced2206b21dd04628ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e43469a06364d7ab8be4a2ed822d0bfdb9407b9de0f0a9e6ab21821ee031a8ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7ba8d8c030d6c67dfb3c0e44d97ab84c0fca1953e3131af48ba2a1b1242c2ef"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    ripgrep_path = libexec/"lib/node_modules/@zed-industries/claude-agent-acp" /
                   "node_modules/@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r ripgrep_path
    (bin/"claude-agent-acp").write_env_script libexec/"bin/claude-agent-acp",
                                              USE_BUILTIN_RIPGREP: "1"
  end

  test do
    require "open3"
    require "timeout"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"claude-agent-acp") do |stdin, stdout, stderr, wait_thr|
      stdin.puts json
      stdin.flush

      output = +""
      Timeout.timeout(30) do
        until output.include?("\"protocolVersion\":1")
          ready = IO.select([stdout, stderr])
          ready[0].each do |io|
            chunk = io.readpartial(1024)
            output << chunk if io == stdout
          end
        end
      end
      assert_match "\"protocolVersion\":1", output
    ensure
      stdin.close unless stdin.closed?
      if wait_thr&.alive?
        begin
          Process.kill("TERM", wait_thr.pid)
        rescue Errno::ESRCH
          # Process already exited between alive? check and kill.
        end
      end
    end
  end
end
