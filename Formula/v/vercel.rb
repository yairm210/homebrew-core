class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.11.7.tgz"
  sha256 "34432b6f0ddd6501ab17140dcf6c5baa2e68fa1ce91eabcb2afef4fbf4db44eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "77ea3740d397c95594fd281bc613044c2c03d6810fa92d7e6f5ab687312a268f"
    sha256 cellar: :any,                 arm64_sequoia: "77ea3740d397c95594fd281bc613044c2c03d6810fa92d7e6f5ab687312a268f"
    sha256 cellar: :any,                 arm64_sonoma:  "77ea3740d397c95594fd281bc613044c2c03d6810fa92d7e6f5ab687312a268f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a097d6dfea15506892bebedab86b80cb3810abd6f885b96914cd986700f5eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6c0b39e3fb4d4559643ee5a7faf75c5a6e0687aca3e322c271cdd2a3d99a16d"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    proxy_arch = Hardware::CPU.intel? ? "amd64" : "arm64"
    ["@vercel/go", "@vercel/rust"].each do |package|
      (node_modules/package/"bin").glob("**/proxy-*").each do |f|
        next if OS.linux? && f.basename.to_s == "proxy-linux-#{proxy_arch}"

        rm f
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
