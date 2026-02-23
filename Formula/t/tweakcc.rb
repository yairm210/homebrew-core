class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-4.0.7.tgz"
  sha256 "88986f4b9718cd6c53d8dd931ece33b6cabd56bb8a7a8bbc4c31120afb0317d9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4f3652d038bc85884e1562290bce4bb963d93a25b73dc024afbf2cdb5113a365"
    sha256 cellar: :any,                 arm64_sequoia: "d1c3a87f9f64e65fb871bbae8422037ea0558874bd64f397fd122b52e0e128d3"
    sha256 cellar: :any,                 arm64_sonoma:  "d1c3a87f9f64e65fb871bbae8422037ea0558874bd64f397fd122b52e0e128d3"
    sha256 cellar: :any,                 sonoma:        "cfef106b36c22a070a0019168d8a050adf5f9f0a0af226b9591f0d72b9603509"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2fcdac0931930ae0126dc132fba3aa5ce121ed96053d1dc9729d1dc62f814ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23cabc6b347369dd75e2f29344f6caf3a948f62d7425343cd31d0870c5fda06e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures and musl
    os = OS.linux? ? "linux" : "darwin"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    node_modules = libexec/"lib/node_modules/tweakcc/node_modules"
    prebuilds = node_modules/"node-lief/prebuilds"
    prebuilds.children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "#{os}-#{arch}"
    end
    rm prebuilds/"#{os}-#{arch}/node-lief.musl.node" if OS.linux?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end
