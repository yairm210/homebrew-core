class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.20.0.tgz"
  sha256 "af606c2563c3072c50e3034a12207c69a0e7b36ba7c0cd2ad1f2bedd1c3c313e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "522d7e0e47b74915ef412855ba5939530f248f5a9c435876ff5e923ec6f78ffa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "522d7e0e47b74915ef412855ba5939530f248f5a9c435876ff5e923ec6f78ffa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "522d7e0e47b74915ef412855ba5939530f248f5a9c435876ff5e923ec6f78ffa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a41a9500be3d4e357f5e8861ec7f1d4b6d81b496ba2daae416678b625ee23a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a41a9500be3d4e357f5e8861ec7f1d4b6d81b496ba2daae416678b625ee23a14"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shadcn --version")

    pipe_output = pipe_output("#{bin}/shadcn init -d 2>&1", "brew\n")
    assert_match "Project initialization completed.", pipe_output
    assert_path_exists "#{testpath}/brew/components.json"
  end
end
