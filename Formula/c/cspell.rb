class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.6.3.tgz"
  sha256 "248635514fe3107d32a7fd667575444db4543873b6e7b5cae7d917fdb5e1ec63"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c172c16945f74198bd331dd98b725c8f41c23f9252021fbf10b924474db93c1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # Skip linking cspell-esm binary, which is identical to cspell.
    bin.install_symlink libexec/"bin/cspell"
  end

  test do
    (testpath/"test.rb").write("misspell_worrd = 1")
    output = shell_output("#{bin}/cspell test.rb", 1)
    assert_match "test.rb:1:10 - Unknown word (worrd)", output
  end
end
