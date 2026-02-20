class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.6.0.tgz"
  sha256 "dc67131d42e6b4202985bede7e53e17bf0d7e6df0d918c124819f8f2c004b282"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86eec290c64eb557f5979b83472afd528eabdde501bea0093ae3b88eb70c55fe"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
