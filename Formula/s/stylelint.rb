class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.2.0.tgz"
  sha256 "24dfa7c14ffd40e5114dc700f37a2d22b568b2470a0063166c40835c2e0e2015"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "16d7e0e5ec01247a8ec2e0ee27021604b242599711259ce7dcc19f56563f8dd5"
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
