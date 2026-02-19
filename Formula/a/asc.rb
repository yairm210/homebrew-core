class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.29.1.tar.gz"
  sha256 "bdc78303d43d811b831f913984a01bf11e3138436a4725c8a6f7688486311d94"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

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
