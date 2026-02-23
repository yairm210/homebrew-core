class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.4.tgz"
  sha256 "4cb07478f9112ae6d4724546588ff0fe9bd7f145aead21a442ddf123aae94158"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "864d9f0acbc0ce0fce001a6fe821428775bf7466b6efb38368ebd231f293bfd1"
    sha256 cellar: :any,                 arm64_sequoia: "4be03d9c60265676b569d9e22813273706f08ad435f752815c7a4c7f1a4db3fa"
    sha256 cellar: :any,                 arm64_sonoma:  "4be03d9c60265676b569d9e22813273706f08ad435f752815c7a4c7f1a4db3fa"
    sha256 cellar: :any,                 sonoma:        "a257f545e722dd0f1d5b975d7c6f24d0e00c402d0392308cc96339facdb39f1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96121b0ffbb24f77ced29f06fb3089b7d95d34990d6def212c74716bf5950487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9602340a5dd9ac81ffa5f18ceba915b2b288754816319d471baee6b1e521361c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    # Remove incompatible and unneeded Bun binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
