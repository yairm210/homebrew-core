class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.17.0.tgz"
  sha256 "3f26fb6686fc8fc6d1a24f987830b82a4d74774cf0a1e2fcdb87eb19ec2fdb58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ddf573becc2425b1d2f4ba9f665f3101643079c470d019bf5eafa6502d910d8"
    sha256 cellar: :any,                 arm64_sequoia: "c520ab822e8c8dfdcce221fc8363cbe2e1248d42b29c9e8dd1710cd7dbb745ff"
    sha256 cellar: :any,                 arm64_sonoma:  "c520ab822e8c8dfdcce221fc8363cbe2e1248d42b29c9e8dd1710cd7dbb745ff"
    sha256 cellar: :any,                 sonoma:        "62558e3648c9c914e5bac025049de3091482ad6424435b3340da38fb79431831"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d83b0f71cb3030a4df54f2a9fceeca0473199edf53985a7057d4e9ceab286d4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "456b6e0812fc86afbdb943ee949363b4c419372cf92aa152ac96661d4e256fc3"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
