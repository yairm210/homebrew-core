class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.16.4.tgz"
  sha256 "3f8d5fe00559ec438d756f5cc963b8e2ed2e727b44366b47f38021fd9ffb1e93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b4296821b39ed6ebda7d00dc9a8c33269f39ad0fc541e9c67bb3330c8b73cb42"
    sha256 cellar: :any,                 arm64_sequoia: "e53cb3080255a1074a22278e702568c13adaf63c2cab09c3ab78877d01e37750"
    sha256 cellar: :any,                 arm64_sonoma:  "e53cb3080255a1074a22278e702568c13adaf63c2cab09c3ab78877d01e37750"
    sha256 cellar: :any,                 sonoma:        "74c2e053731fe7f1d9879c3c387ae72f10697aed6684863658ab163880570d4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04c53295e020ec7788cbc370ab1b69ff31b2092cc6c3c93a1e6af568d3e85103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67765a0d22783917105187f2167115851c33d1df9b1e9d42551a00d1dc50bd6a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end
