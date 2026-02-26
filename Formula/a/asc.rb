class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.34.1.tar.gz"
  sha256 "cca4da28abcf63ba55d85ee4a664e24b4c535e99a05dc2ac50f61af6d7a2816a"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eafdb8249958e8eb66ba534a35f588444d4e6cfc24358d7734b62413f3f0d430"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dae51773af67b3364858def7928310750b2854c2aad2110953da7b1b2df10869"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3765afa72491d5986bc7473cd4c29e7a75653c979754ce9d749b38e27a9f4938"
    sha256 cellar: :any_skip_relocation, sonoma:        "09632b2ca631ec5e61541cd3398d2d95b61428edf23b2341037c6de479cd298d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67727ac87718074e5f59ad5d2af5e536761d2663793762798e87228cccb2b2e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "299db127a0ca1f82767f82dffe6ffab7abb4d27b1141451f96e04c25d8557e81"
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
