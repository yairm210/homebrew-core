class Shiki < Formula
  desc "Beautiful yet powerful syntax highlighter"
  homepage "https://shiki.style/"
  url "https://registry.npmjs.org/@shikijs/cli/-/cli-3.22.0.tgz"
  sha256 "386d022f5aee850e9a79f972ce7d987e67f928af3af759218335adde496caed9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65e912aaf5a1128a09329a4c931f0a86607709f75166c77e9e79bb0fc0c6d0af"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shiki --version")

    (testpath/"test.txt").write <<~TXT
      Hello, world!
    TXT

    assert_match "Hello, world!", shell_output("#{bin}/shiki #{testpath}/test.txt")
  end
end
