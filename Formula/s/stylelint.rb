class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.4.0.tgz"
  sha256 "e070b2b0d97389a7ae7f6105d323cce21ab54704d02fe071e986533f6b58b093"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b48a0507e8840b8bdbbddcdd11f077b257d33c2968ea3669764a6334cddfe8fa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/".stylelintrc").write <<~JSON
      {
        "rules": {
          "block-no-empty": true
        }
      }
    JSON

    (testpath/"test.css").write <<~CSS
      a {
      }
    CSS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end
