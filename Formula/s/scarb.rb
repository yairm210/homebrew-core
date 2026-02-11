class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.15.2.tar.gz"
  sha256 "612c9a5167b8d089101a63923731f07d02cf07072c6438ce54388f7aeb3c86fe"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "648857e92e0f9207971eb9b40e9c6e8a254cc1b941b34a3ced66edb3a8905a8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f91b2218d75c6b25181687d023d00ddfdaa1aa871815b841c44ceaa024e66d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de89e6ff31438b93e109f411ba8143e7d058ecebeb270de879496125a91e2e32"
    sha256 cellar: :any_skip_relocation, sonoma:        "065f62a57574b6f15bbd0ca570d6b44866eb16db6b35f1e991ac06d689d72351"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3c1351b0bf336612a39ee0efdcdd087c81a4ab1075304226b2f97f356579353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a040cd0f1042e07de3a83a946eece7b2f5d6c55128e00295817f8dafbacf036f"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "none"

    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system bin/"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_path_exists testpath/"src/lib.cairo"
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb doc --version")
  end
end
