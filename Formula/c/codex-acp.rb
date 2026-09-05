class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-1.9.0.tgz"
  sha256 "1471eec4113f45ab0796f5657fc698fcbbd2f73b481836ea99ad076ed713e67c"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abb80e5263a7464210ef487616f3145d6107b5b88be8cce99d54cc530273ba66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abb80e5263a7464210ef487616f3145d6107b5b88be8cce99d54cc530273ba66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abb80e5263a7464210ef487616f3145d6107b5b88be8cce99d54cc530273ba66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2f9de399e6a7c2a0e35d303a184bd85af1f20e880ef691b24936ed03b87022d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1ad8eba2c2bb544451de194ddc05bdb4c637386080769bc9cbc787ce1f2f1f1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    rm libexec.glob("lib/node_modules/**/codex-resources/zsh/bin/zsh") if OS.linux?
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"codex-acp") do |stdin, stdout, _e, w|
      stdin.write json
      sleep 3
      output = stdout.readline
      assert_match("\"protocolVersion\":1", output)
      assert_match("\"agentInfo\":{\"name\":\"@agentclientprotocol/codex-acp\"", output)
      Process.kill("KILL", w.pid)
    end
  end
end
