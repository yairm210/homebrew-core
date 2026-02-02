class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.2.0.tgz"
  sha256 "4c733a3954bc1b0e86569ab1bab903ae4823579bd3ae647a52f27857968f32ee"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec1b8be5c2a676d1969ea7e0b2cbdae9579f2e757d1370e6e9a179f1d2be221a"
    sha256 cellar: :any,                 arm64_sequoia: "6ce7dc3238d8cec7e36c8847c08902f8162298896419ec4c54f217415ea6fa89"
    sha256 cellar: :any,                 arm64_sonoma:  "6ce7dc3238d8cec7e36c8847c08902f8162298896419ec4c54f217415ea6fa89"
    sha256 cellar: :any,                 sonoma:        "98368945ccc997b56344c37a243e318f0d520a85618cae4e88b0aedbc6cbc41a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a29e60b8ff769a27756eef391d6c45f2374849487d3aee2410565c159a8c5a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ed222e10fe22ac6d288204f45bf09fd46297de902e219b7bf7047a14c73a995"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end
