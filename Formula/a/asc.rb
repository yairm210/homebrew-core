class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.34.0.tar.gz"
  sha256 "dcb2e0af903a1dfa1ca93513a47f5bf81cb5ba217ccdc48ec141b8d768351842"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53c66c07b296f3d9ef949d1b30eeac6e4f4dc09a5cafb65db71a300d986e4df5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f58e7103d056d973387036232fad428c7b5da5c59164c40f009f1826389a5a98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36c36367ef8ed7b0f2e23ece6c4c39148f6f0240e7076dd859fdff0e52aa1d2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5129d59c33a977f27079ac85a189dccf6674e91b302f1c9a6bd5a7e89d204cd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22c5d81a38673669a5849f5d29b65d49187e046170e17f3d6df821ab50056a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b696f667c11214c2662e9b24d8cda6d2c3eb815007275ffdce02a57dca65364"
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
