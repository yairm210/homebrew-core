class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.11.2.tgz"
  sha256 "1b5f7e9632009b31e6be7c3979f0a6c7c078ba4ee07c2b404983b55071e89b06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0603a7f576481f2f6e7ef31cad0b6eeaf383f4197a03eedf73f028929b252447"
    sha256 cellar: :any,                 arm64_sequoia: "0603a7f576481f2f6e7ef31cad0b6eeaf383f4197a03eedf73f028929b252447"
    sha256 cellar: :any,                 arm64_sonoma:  "0603a7f576481f2f6e7ef31cad0b6eeaf383f4197a03eedf73f028929b252447"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e0694f6a8ef26c577bb0ddf2ad1c0f2dbb58acdb313e6217bf180dda5e6cbab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d274b62ed888d0e59dba6393491d8dcc589238bc7987804d3d8813780927494b"
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
