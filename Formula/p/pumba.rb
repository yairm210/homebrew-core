class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/refs/tags/1.0.1.tar.gz"
  sha256 "e1bf9c03b05e2c6d1d599028cd93d0887299a629ad76793426d4ba6971e48b0b"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6229c052683b810ebdce5830f484b720c78397b1075c37c9419ec2bb0d35f2ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6229c052683b810ebdce5830f484b720c78397b1075c37c9419ec2bb0d35f2ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6229c052683b810ebdce5830f484b720c78397b1075c37c9419ec2bb0d35f2ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a9b096a6d2fb60c1a041c37128b79ef8785869309472f6e4bbf61ad850f1423"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb54aa19967ea520a8eab6389d10e942f95b5d850362d4dc6ab3b44a7cdd07b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "611c532fdcbdc034acf4d3d39b7412a7f84551e335bb3e516a0cd46674d64345"
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
