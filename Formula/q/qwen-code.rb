class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.10.4.tgz"
  sha256 "d7d4ad76a7cb3e2a2cb25f4cf1f60ccdc40b77852d510300250d6a66935e2701"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a743d2fcf4ba0b6e047334f3999f2e5e53abb33669cb37ed12aa9e20939e129"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a743d2fcf4ba0b6e047334f3999f2e5e53abb33669cb37ed12aa9e20939e129"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a743d2fcf4ba0b6e047334f3999f2e5e53abb33669cb37ed12aa9e20939e129"
    sha256 cellar: :any_skip_relocation, sonoma:        "10ba1e4116a3a2427101ebe3c49f2a834f29765c1e96d468074b5c2d664c7b31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6c59a6e1a5ee305cd2f087380d866261eab68ef8e5b0cbb4452f0e167ace5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7286fd4d248c9936e2c2755331e2698360def61a929ecc1bb99e183a9ac70928"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    qwen_code = libexec/"lib/node_modules/@qwen-code/qwen-code"

    # Remove incompatible pre-built binaries
    rm_r(qwen_code/"vendor/ripgrep")

    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (qwen_code/"node_modules/node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end
