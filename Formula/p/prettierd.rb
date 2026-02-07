class Prettierd < Formula
  desc "Prettier daemon"
  homepage "https://github.com/fsouza/prettierd"
  url "https://registry.npmjs.org/@fsouza/prettierd/-/prettierd-0.27.0.tgz"
  sha256 "a7a3b95cddf5860d315ccfaaf9df26eee4e7631534f427f68bfb7d1d182a163b"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b11cac5d3d092efcc70afca7557edeae6af57e55a6be059585ba50ff6f423a5b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = pipe_output("#{bin}/prettierd test.js", "const arr = [1,2];", 0)
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
