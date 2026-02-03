class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.9.0.tgz"
  sha256 "336320da14d21992e8b40ce9950ad35658643009ea3d5fb18664aa541563e6d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32a339c5560be454aa600d270779304752933a26e65e48034f95819e0b7ec1df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32a339c5560be454aa600d270779304752933a26e65e48034f95819e0b7ec1df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32a339c5560be454aa600d270779304752933a26e65e48034f95819e0b7ec1df"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cb9a366321525b78404ea180bc4d8da070f5721319cff58efa1375689b1cf16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1187c26e7df09e457eba09bddc7ca0fe205121e7d2295b740ad6faaf3e7119ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50040a7a6c1977ef1ccc44b169aab16f0ad73e9c80de5a906fa2ec7a5f844cb3"
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
