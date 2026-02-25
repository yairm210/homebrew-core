class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.83.0.crate"
  sha256 "575fc67a8aede0c14dfe2de1e19c6120b83249b700dfde6170fe9ae3ecd55ea8"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e214316f36d725b4562e0facf425bf8c022aac9b40640892cfa479cb5bb4c49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ae4cae8a56a3cf6bbb3233dc3663317309c3c31baf42d8ab30f917ec32f6059"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b6b2667f59002f267e4ac2fd67f99b8395d7f05b066e263a9d210609d27e3f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "184fb19c8d37fa986379385d8cdd28e0b949273c5ab14afe9dad3c6b199c98a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a881693662ce189ad15f45e9075c646cf5d8baf3bdd9d766b56cffad0e1c385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01268a276f60fd631954fb8ea9fd139f892a17f7861cb9d850d96305b3636f76"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end
