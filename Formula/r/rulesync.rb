class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.7.0.tgz"
  sha256 "17d37e57ecc75dc1cdffec7307b4f600b13cb7272662d025fc28df45b262f7ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a9dd42f561592419712c35be06f1b7b7bf913a97de402280b4791f5684e1d5be"
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
