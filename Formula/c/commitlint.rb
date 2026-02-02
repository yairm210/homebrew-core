class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-20.4.1.tgz"
  sha256 "7daac80d31639c995a1ba757ad985d98fd9678d8c5b6aa6bc78f6c8cade9d03a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c1a5717e7e98aefce6c9c9abe8ba395f3f99da10b35a8030cb77ff7ef24e39fd"
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
