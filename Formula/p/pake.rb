class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.8.6.tgz"
  sha256 "76875bb3a5d76f852d9948709cd0b8f588566d35470dc8880ded9f5722987baf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff9fe541eede975ad3cd1e14c7143145021311a0f37443722f0e12a9d8da324a"
    sha256 cellar: :any,                 arm64_sequoia: "40650fe715d34c85a74ce83168a48806c76642455e43e1f4ca002bd25f1aba32"
    sha256 cellar: :any,                 arm64_sonoma:  "40650fe715d34c85a74ce83168a48806c76642455e43e1f4ca002bd25f1aba32"
    sha256 cellar: :any,                 sonoma:        "4af367c7671434264e545c7a32b8ee99b44e8e9c1e9e68ae20d9be425d5c4282"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ad4a24aa726ea0922f91f294e4ee18c4e2075dcccf0851bf4181f20965de2b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc6d750d259955bdbe7bdc4be1c2f1e1f2394ce46827dac3e0bde0cd2bb4d5b2"
  end

  depends_on "node"
  depends_on "pnpm"
  depends_on "rust"
  depends_on "vips"

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.5.0.tgz"
    sha256 "d12f07c8162283b6213551855f1da8dac162331374629830b5e640f130f07910"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.2.0.tgz"
    sha256 "8689bbeb45a3219dfeb5b05a08d000d3b2492e12db02d46c81af0bee5c085fec"
  end

  def install
        ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

        system "npm", "install", *std_npm_args, *resources.map(&:cached_download)
        bin.install_symlink libexec.glob("bin/*")

        node_modules = libexec/"lib/node_modules/pake-cli/node_modules"
        rm_r(libexec.glob("#{node_modules}/icon-gen/node_modules/@img/sharp-*"))

        libexec.glob("#{node_modules}/.pnpm/fsevents@*/node_modules/fsevents/fsevents.node").each do |f|
          deuniversalize_machos f
        end
  end

  test do
    require "expect"
    assert_match version.to_s, shell_output("#{bin}/pake --version")

    (testpath/"index.html").write <<~HTML
      <h1>Hello, World!</h1>
    HTML

    begin
      io = IO.popen("#{bin}/pake index.html --use-local-file --iterative-build --name test")
      sleep 5
    ensure
          Process.kill("TERM", io.pid)
          Process.wait(io.pid)
    end

    assert_match "No icon provided, using default icon.", io.read
  end
end
