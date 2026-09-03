class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "72bf95905a92c592dd0e7316e2cbbad9a8f2ca04ca770cc4f4f7960495a44e15"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c93849ab57ade0d302c02efbf7d7515e4bf929257324f1e0098837c0118f934"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "997aca094234439fc0c72fc1498e996231d6cfadedb72a2d6c097081dd825505"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c34d67fe22057d901b45dfdfd13c6ef911ffc0fc4f9f91c81c23f5840d9f53f7"
    sha256 cellar: :any,                 arm64_linux:   "0b063bfd5f136c105856b9dde71e8a0659d9fdf8a9af7bc1c94b8015d1279511"
    sha256 cellar: :any,                 x86_64_linux:  "253f6806b6df4212c0137272e80e46c3913290f1f6b5a473ca7cadc2dd293555"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"jj", shell_parameter_format: :clap)
    system bin/"jj", "util", "install-man-pages", man
  end

  test do
    touch testpath/"README.md"
    system bin/"jj", "git", "init"
    system bin/"jj", "describe", "-m", "initial commit"
    assert_match "README.md", shell_output("#{bin}/jj file list")
    assert_match "initial commit", shell_output("#{bin}/jj log")
  end
end
