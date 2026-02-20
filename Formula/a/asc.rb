class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.30.0.tar.gz"
  sha256 "57fbd9234a63853e05ba74b1fe6720f9ecc9765186445329b7a292deb8229a2f"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "918d1d6ca8cb05970d2ee72cf51829153b23c0ce02711c07fae2525ccffd4548"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0de4bef7473dca4fe88d0b8250a04c2fc2386af6d92de1d0e80536877624d73f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "530837176aef3e8621a27c616322a49b860e1ca017d498ca380c358cd1f4e3b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c8736b616bef2ecbd563e07125e27b476bc0c79fdbb013a042146a4c3d343c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cce389e11374a2fa8cd49cff5a1374a52ef5812872ce44471bc608ff472d765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67f60e6ce9c5a1d753a0f45363e968d59d9a2164bd5df4cddbb349091e221672"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
