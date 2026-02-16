class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.81.0.crate"
  sha256 "0f5340edcac5e3b01f8dd47c6663b0fa1fa68ee995db5eb78045c82f071045eb"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e7b657006ab9d6e08d6834c63f2ce098681c187b232702ce393c59983966f74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c067796317d7312fd52db3e6533d1c13ae60a3214e7f5c9d6d1860369dbd5037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec5d5243281172c68449b70eda3e5bf87e9db02610ac18bc76abf028954a8ddd"
    sha256 cellar: :any_skip_relocation, sonoma:        "33f3d05a10d6eb3827c2417dbc2c80770d4d059a754ca7277b3472ee42ca0c5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb285274f36ae15d0403e795a1df5fa35e6524bdd6892ae911e02e9ebd5e7222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bf7d99beed1f726f3f8853fa2a27cc39d521794fef919f8028402d2220238ef"
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
