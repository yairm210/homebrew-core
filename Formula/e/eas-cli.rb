class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-27.2.0.tgz"
  sha256 "45fa82fe75b4e6a50e77a86eb69722453ce5468a21254f1a7a02f8fac81765dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71f29a251f2f9cdce9773043ac969fbae42e65700fe6d6329bbacb90ef96b3a9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")
    assert_match "Run this command inside a project directory",
                 shell_output("#{bin}/eas diagnostics 2>&1", 1)
  end
end
