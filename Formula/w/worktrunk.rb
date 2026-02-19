class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "294baa3aad769ba761b559afbe8ea6c07e38ee09e672bff83e20457146246f98"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f790b56168d40c8e12e4ce7153c3ca352d1f352b4efd011920ed1078c392b311"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6651c93f82a91ce4c09831c8e62d8f07a6d0e413b0e7e884b7ce84da1e82eb2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "491c890240559ab24d2c0e9d62544f4dcb20c3f7b5255bdfdc593b6838768181"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4cabc78ed10e67f401dd3cf662135f31d61491657b376dce0313e3ac00f0243"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5832e1654be71eaa166d5d02f9446af5bf69f74e20d5e5a980228916f7dfb5ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa93795153419c04cd6caf9735f7e00b542ea634824f247874e8e09aa43f6be6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"wt", "config", "shell", "completions")
  end

  test do
    system "git", "init", "test-repo"

    cd "test-repo" do
      system "git", "config", "user.email", "test@example.com"
      system "git", "config", "user.name", "Test User"
      system "git", "commit", "--allow-empty", "-m", "Initial commit"

      # Test that wt can list worktrees (output includes worktree count)
      output = shell_output("#{bin}/wt list")
      assert_match "Showing 1 worktree", output
    end
  end
end
