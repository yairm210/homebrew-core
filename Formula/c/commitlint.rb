class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-20.4.0.tgz"
  sha256 "0087e617e757a342a69a5cf97c9a943507c39052859e932289f8ef2a6c478e24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ad2991dc820115392cb16861add37eddaecc2b21a126f383744596355ff6d67"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"commitlint.config.js").write <<~JS
      module.exports = {
          rules: {
            'type-enum': [2, 'always', ['foo']],
          },
        };
    JS
    assert_match version.to_s, shell_output("#{bin}/commitlint --version")
    assert_empty pipe_output(bin/"commitlint", "foo: message")
  end
end
