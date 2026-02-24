class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "480ba339c5b15ebb9eada276d5e25315ee5c36e878d86dcfc1ea17f54a27197a"
  license "MIT"
  head "https://github.com/peco/peco.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "76327c2446971946d8fc58cfe5afe6bfbb4c6e6115fcc069a6c9801b950420d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c7a5fa08c2aa3ad21a733a5523c4fb5fc7217258bebcaaf33e0d61cf11cbefa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "837a17172f4346d52cd042a91b1238e8765fdd829cc2c33b13911a9604612562"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6ee18836e9fb37550e7245924f49a2c4fd6031d0c03398838e93f5ca0ea80bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6ee18836e9fb37550e7245924f49a2c4fd6031d0c03398838e93f5ca0ea80bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6ee18836e9fb37550e7245924f49a2c4fd6031d0c03398838e93f5ca0ea80bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd46db16c2244bb3f959b175812614f58679f13648f3713d2ce669006b39ff60"
    sha256 cellar: :any_skip_relocation, ventura:        "7a91ef4b46bebf8e13308598da973d70b373e30f0d0193e771b1914198120cd2"
    sha256 cellar: :any_skip_relocation, monterey:       "7a91ef4b46bebf8e13308598da973d70b373e30f0d0193e771b1914198120cd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a91ef4b46bebf8e13308598da973d70b373e30f0d0193e771b1914198120cd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "374534cc56672f993900a9d52493162e3a6a610216b0147e97455391a5e8048e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b79dea96e98bb408b0b87bd9b2ea4371c035e23b49c1de71ce7c7387f4ffec51"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/peco/peco.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/peco"
  end

  test do
    system bin/"peco", "--version"

    ENV["TERM"] = "xterm"
    assert_match "homebrew", pipe_output("#{bin}/peco --select-1", "homebrew\n", 0)
  end
end
