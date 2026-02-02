class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.17.tar.gz"
  sha256 "3c60a21d819e173bc35abb1add87efd89303e9f1fa96c03747561351a84fee00"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "590f667d12b5d99952edbaf25f1ac1f8acb2cfd607d5b2f279fd5291e6e6d45e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28b93ed4b025441ecdc6bfe284d1d727d9a2c552c4972b06da84cb6623a45251"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "691d23d20e954be3be31e5e69a5dbcf883f76efdbc94efc6693cdb30e2d62dcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "bddf7b647a0a98a5a0bc9eb4bb0a9e084df01699e059216bcd0a102f1cd0f7ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6535c6df1362b9af805afb56f61df763d0eb5f24f047c7c161a8bf8a3b2114ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b32cf26298c772e092903f47f453b8951e577f05fa196af37a116a61cba49588"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
