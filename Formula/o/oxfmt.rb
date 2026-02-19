class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.34.0.tgz"
  sha256 "0e2f62ff6d6e59e82446bb3609bf2825957ac1fe565482547e6a96fa536176bc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd25dc4f6defe679290c89e14bc806caef4494e9a280ed57aa0b827bf9c4e047"
    sha256 cellar: :any,                 arm64_sequoia: "9f60def22bd9b6bf38d5e5d5fb6516e0b0dffbc9415b96530241e71871ebe57c"
    sha256 cellar: :any,                 arm64_sonoma:  "9f60def22bd9b6bf38d5e5d5fb6516e0b0dffbc9415b96530241e71871ebe57c"
    sha256 cellar: :any,                 sonoma:        "4584365984605b43e2d76f0a1083627a4b6836c7d900ad494345e75bbabc3f11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eca8c034189050a51320182ec82751c9d43095eb90cbbd35137412fa06dddcc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bef427d8eea086b75745c02e2f4bc592f309ae7f80931e43901ab929ed7ae44e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"oxfmt", "test.js"
    assert_equal "const arr = [1, 2];\n", (testpath/"test.js").read
  end
end
