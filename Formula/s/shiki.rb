class Shiki < Formula
  desc "Beautiful yet powerful syntax highlighter"
  homepage "https://shiki.style/"
  url "https://registry.npmjs.org/@shikijs/cli/-/cli-3.23.0.tgz"
  sha256 "8f237bba062ebb2052fa8c33b53a696cd295b5f3ff67d524f631dda50b66d13a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47bc2836626d8597a1870583f518f304c06fa1fdae00224a057e0f1ed100d0c9"
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
