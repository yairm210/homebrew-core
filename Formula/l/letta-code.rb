class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.16.10.tgz"
  sha256 "6dcc5830acd0ced79e251e99c230bb6587d767486bec66594b5d884fcf35961d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac5b5a3868cb121ee9d3f04fcf30282710297b2e26f4edc0c80094f408ff740c"
    sha256 cellar: :any,                 arm64_sequoia: "ba32ff31cab0cd154465ef9e8274f25465e1180da2953f4923c9ad6b39684221"
    sha256 cellar: :any,                 arm64_sonoma:  "ba32ff31cab0cd154465ef9e8274f25465e1180da2953f4923c9ad6b39684221"
    sha256 cellar: :any,                 sonoma:        "beae8a7d0217e3bbb2b1b4e7179fd5af177abe97c0c83cfdc163fcc2cc44810a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b896ac2820f2a0dc67f7a1cfc121dec59e050c756170ea2fe26400a4c609e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "242527b0a4c48b0f8a0f7535b6ec4db887f8ad6bd861011f45edde4fb4b52175"
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
