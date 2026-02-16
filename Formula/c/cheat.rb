class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/5.1.0.tar.gz"
  sha256 "5ef8864dacb5b37268d7d26cd01f74b99a33b2e5eb5b290e4221358410c99db4"
  license "MIT"
  head "https://github.com/cheat/cheat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48cda603befa6b05224e3752e0398468a8a5cd11722d0cc41bd05da9ab0a8866"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48cda603befa6b05224e3752e0398468a8a5cd11722d0cc41bd05da9ab0a8866"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48cda603befa6b05224e3752e0398468a8a5cd11722d0cc41bd05da9ab0a8866"
    sha256 cellar: :any_skip_relocation, sonoma:        "87031273ec9b9791df1d014fcd8a650195d98ffc0973e243a7a6324ea837c03a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be0b548e582b510548e365f8c8bcf8fa12416b74c4943ac5a1e08e68a85525c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f95bca61090c186b56de16dcd8910db421974a35c2a5b5b6182ccc569cca54bb"
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", because: "both install a `cheat` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cheat"

    generate_completions_from_executable(bin/"cheat", "--completion", shells: [:bash, :zsh, :fish, :pwsh])

    man1.install "doc/cheat.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "cheatpaths:", output
  end
end
