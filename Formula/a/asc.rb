class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.29.2.tar.gz"
  sha256 "dd2702177c30d19de3855279014af3bcf9b778bc34d18293c2166fb9bd762f4b"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5af0466a156275286d0e97cd275751b091f17aa6fe542d3cb327d19d2d488d76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecd400a78d7905ce952024be21c30024f6427edb1ac053f4319ee3103d608613"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15ec29b36d136b955318b2e0fedc822468f12440cb7af5d4db13f98f31c3841d"
    sha256 cellar: :any_skip_relocation, sonoma:        "78f887c336c4b6cd77f4115b84e51f0dad7fe3e650f1a0658bd17ac1c1467f09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c61dec1d42ebcf2320fe9a0ad383eda3180d46b52835d0a0dfa155055ce7cb8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99541baffe6261d6c121d86355b757dc8c053df60a57c1c43738656b9f2f4760"
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
