class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.7.0.tgz"
  sha256 "17d37e57ecc75dc1cdffec7307b4f600b13cb7272662d025fc28df45b262f7ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "37946721b65f32b9fa98d422667ad8542d162f5a5a994789a6c6eae5e14e1763"
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
