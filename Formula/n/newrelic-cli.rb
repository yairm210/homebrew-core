class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.19.tar.gz"
  sha256 "e0a52f67d0bf69fca2da42e9c91e999dae5375010ce1ab8ace0d2629b1610d14"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b191fcb7ea28391d6d6c0b4dfc3590ded20fabf47001569ecc49b565b82b4699"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65deebb513881d7849362c1fc79d02937adbba4c3d27e8735432da77cdf4b90d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e69b17388b522074f639482026fb0a974b286a24e17e14287be76ff1ab36ebf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "732254d84333037d1bb37a6c1938088642ecd58282549104c927b4ef69cc98fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2501fd41a377694d2d31eb6d86d9cf9af66d91ee9c875a25e6870a8599a52a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d9cbc6c101126e48efaba96ea8c5b3729717dccd5a9ea3b595bfa4bcd05e8e8"
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
