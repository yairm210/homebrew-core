class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.10.1.tgz"
  sha256 "592987cc64337bdb81836c4c53b9fd0787adbcb476e7e7ddc5e56dc2bd811cea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6a73f32fff91e7ce2d4ec18b647e0b0219807c80f596e9c93bbe568473b5dbf2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
