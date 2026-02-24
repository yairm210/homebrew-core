class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.23.1.tgz"
  sha256 "fefac98e1ed2968a75dc7894e63240b537ed322a878a51425b7aa6d072cf2c3e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "af65d12c0c1b32c5a0ba799fa30ddae4053d881a543e0da66027f437fcd5fe62"
    sha256 cellar: :any,                 arm64_sequoia: "e5fbb31d8191a7aaedbcf63160ee3368fe9bffd7fea2f38e3179bbd9a7ca303d"
    sha256 cellar: :any,                 arm64_sonoma:  "e5fbb31d8191a7aaedbcf63160ee3368fe9bffd7fea2f38e3179bbd9a7ca303d"
    sha256 cellar: :any,                 sonoma:        "0663d9eb4788f344aeb08ef9c37cfbab5285f19736cd56bbda75c9b4ef771bb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3d7c400a4265da3286f90609b31bd7eea98f72bb8901ed94640aca78e9a4d19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c6072b424a7a3887ed32de5e07010c874c8211988341c7e6eb1b433a85e54a4"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
