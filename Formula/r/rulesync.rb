class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-6.5.0.tgz"
  sha256 "efcadeae384b53c80f10ae47e7cf13b4d5905eb88a0dc256a196cf4efd4474e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3fd1da38c396a5e26907e4bde0f9d179f4f9f28031c9a67b981c8fcf009834c6"
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
