class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.20.1.tgz"
  sha256 "ee12668d07dbfa45a409f004b1b6f47dc313bab50b3710d9f3f0136397a52cf6"
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
