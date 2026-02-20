class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.6.0.tgz"
  sha256 "dc67131d42e6b4202985bede7e53e17bf0d7e6df0d918c124819f8f2c004b282"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6d40ed8bfeb777bd92485422c2eb33588ec2323401bf6bf1507fb9a784a36990"
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
