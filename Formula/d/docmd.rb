class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@mgks/docmd/-/docmd-0.4.5.tgz"
  sha256 "d73c88b53de2aa1e169472c3da582f482143fc630a60ca3b05e3c9d1d5c5e031"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d72244bfb5321e0e2df30f00a3f1ce07484a4f690389c90990123dd314e9580f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c01b73625582cab11672a030afaae0cdd260d3b13c89b3f80b9fb2ec3f7b6b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c01b73625582cab11672a030afaae0cdd260d3b13c89b3f80b9fb2ec3f7b6b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4fc760fdc5d89f64e6171bf83dd6e23cfe3b6dea7e9fc04cc381132a5912b52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6764618fca5dc9611698ece80f8203900153e33a94ac60e29fdbaf0a1c7a456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4338857c7e7b779a38bf0c3b1e0cf02f93843d0b30bf3ba175199524fe41b93"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@mgks/docmd/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir)
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      ln_sf Formula["xsel"].opt_bin/"xsel", linux_dir/"xsel"
    end

    # Remove pre-built binaries
    rm_r(libexec/"lib/node_modules/@mgks/docmd/node_modules/@esbuild")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.js"
    assert_match "title: \"Welcome\"", (testpath/"docs/index.md").read
  end
end
