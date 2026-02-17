class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/refs/tags/0.12.2.tar.gz"
  sha256 "39cf30af98c3cc62a3baf5ceced2f9c8a88004b452d7fb707707972170e9c624"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc2b3a00006f48103d1a5ff6d3a5ec66314061b7d44213a61a6d145e4ed13f36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc2b3a00006f48103d1a5ff6d3a5ec66314061b7d44213a61a6d145e4ed13f36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc2b3a00006f48103d1a5ff6d3a5ec66314061b7d44213a61a6d145e4ed13f36"
    sha256 cellar: :any_skip_relocation, sonoma:        "a15e32adf3eaa903dfa840d729e3a26078b15428a03b51d56842d648b9598580"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "950b2b9fd28420e32a398e13fbb13ebd6e21d423f88a91461dacc8a7f265b61d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1958ac948573692c26618892e3f65b5e6aaf7ed7e37ee4ce142a4b8b68ca3a9c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.branch=master
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pumba --version")

    # Linux CI container on GitHub actions exposes Docker socket but lacks permissions to read
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      "/var/run/docker.sock: connect: permission denied"
    else
      "Is the docker daemon running?"
    end

    assert_match expected, shell_output("#{bin}/pumba rm test-container 2>&1", 1)
  end
end
