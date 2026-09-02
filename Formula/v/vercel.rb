class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.11.0.tgz"
  sha256 "e56ebbb8e85f983fa50c3bc682044e01baf7726db0f63e63610fbba42b9327b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "52af63ec5e8d5fd56cd320a695314084119a8400ead2f01b792c484ec4e7253c"
    sha256 cellar: :any,                 arm64_sequoia: "52af63ec5e8d5fd56cd320a695314084119a8400ead2f01b792c484ec4e7253c"
    sha256 cellar: :any,                 arm64_sonoma:  "52af63ec5e8d5fd56cd320a695314084119a8400ead2f01b792c484ec4e7253c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e1706b2b337eb507159157e70604cc0658f195e0ee4f6af64f656a596fe3883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d23ec430ee5e5840794fa59291868735c51a17c52865dd7a6a61a2c8d51e36a"
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
