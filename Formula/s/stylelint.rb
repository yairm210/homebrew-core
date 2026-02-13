class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.3.0.tgz"
  sha256 "5fa4708dda6d5d5b26df68427939913d813f50dd6a9dc170d66722af3340c542"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1db201daae83279d944b777a093ba3f6b1c572d6c4bb7c6416fe576f136fdc38"
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
