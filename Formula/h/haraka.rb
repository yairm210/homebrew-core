class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.1.3.tgz"
  sha256 "ba9cd4e07169ae3a6e19927f9edddf765297e0ba0475d0c0ca95457196d0a138"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0515de145c79f0191f25ea5b476bb178ab608e6043e8c5061932f5c9a0aaf261"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/haraka --version")

    system bin/"haraka", "--install", testpath/"config"
    assert_path_exists testpath/"config/README"

    output = shell_output("#{bin}/haraka --list")
    assert_match "plugins/auth", output
  end
end
