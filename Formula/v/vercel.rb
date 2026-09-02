class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.11.0.tgz"
  sha256 "e56ebbb8e85f983fa50c3bc682044e01baf7726db0f63e63610fbba42b9327b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bea93771e3655515e0549b237755e334800e49fc5d9777ed2bddf722c520b437"
    sha256 cellar: :any,                 arm64_sequoia: "bea93771e3655515e0549b237755e334800e49fc5d9777ed2bddf722c520b437"
    sha256 cellar: :any,                 arm64_sonoma:  "bea93771e3655515e0549b237755e334800e49fc5d9777ed2bddf722c520b437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af32109ba8d08aa9d78e03e9e6da64e6639ea193fbba7f9154c344d7d06e6935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71f7003425f0d2ad52e9d4b0ab86c210c52da11645c16f9a9b21596a0ccd8fb8"
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
