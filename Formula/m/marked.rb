class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-17.0.2.tgz"
  sha256 "84fdbe8b1a9f6e0709727b4aaa0c577f8c795717f838c053e40009ee8b561d5c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3fad2d5cdd0c08c31a0a20dcb4129bf956aa9f7601649a0e0a07dd9191e3041b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output(bin/"marked", "hello *world*").strip
  end
end
