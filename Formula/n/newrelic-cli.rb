class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.22.tar.gz"
  sha256 "6dfd62483aa73fab8170fad2c9b26109815b8e759707ec5a99bb7e9799ae3313"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce4aeb3115213eedc1250bce8760f4906a8d5c76082cacb09c947cf9bd7bf958"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aea6e9e4f5e2fbfffdaa295a3444bf5d3dc2eebe7a42da1a4c69b8483b160fd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12df40960cac22b0ea32a8eeaeed628c472e09a7b43bba3e7b7ffe11f5cc9d21"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5d8519419c8472b3c1f56c11f7df3fb391d9467e0277cbd0a49e98647a39397"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ba94ad588006b3e36bcb252de94ae2be2258718a32d594d022157261997a8c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8801c3da2f75d8dd93c537fc01d526500969641b582daa71af20c5f3634608e"
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
