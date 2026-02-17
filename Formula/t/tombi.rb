class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.30.tar.gz"
  sha256 "0870a9a9d9b9deb099ccdb1487f613f7674335169ba500a545d8397fc0cde91a"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13b6b4dd6430d82927980b04850b53911f80025d798827ec5f14a5e18d868788"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e384f7a618dadbc429ac4d1cf71c806d6ce190035d6fe49b8ef5024288a45ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4448481612b41463e15688fc67753e9be483046a44f7019665286d9db21ff816"
    sha256 cellar: :any_skip_relocation, sonoma:        "8300a117a9255575382d6471be44d5ccde49aab413c086f438b918120b0eb8c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ea69cb2ae55779579de0a018be42fdc39cc6b623f68522762895c16283048ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc4d6dc113ec931730ef151f4c083d44600d22e7533890dc06760f2858c5e1fd"
  end

  depends_on "rust" => :build

  def install
    ENV["TOMBI_VERSION"] = version.to_s
    system "cargo", "xtask", "set-version"
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tombi --version")

    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
