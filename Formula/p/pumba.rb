class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/refs/tags/1.0.3.tar.gz"
  sha256 "47cb64cfcb9198157bc6879a40fde2089ab968f19ce7fdeb98621aa68e86793a"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7439c60e2080e3d8bf12fa9677d833e3bb2e78e50a84c15de6fa621b00c3c142"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7439c60e2080e3d8bf12fa9677d833e3bb2e78e50a84c15de6fa621b00c3c142"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7439c60e2080e3d8bf12fa9677d833e3bb2e78e50a84c15de6fa621b00c3c142"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d1f6f18331e1e1b6936ca61796bc59807bd26f3468e69fea3748f761a83cb0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aecc7f3ed4280ecc024bc592af7d71f79de0378730004a9d861fff1e449c22ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8acaa358ca77c54e9e0b73faac6e300c237399bb804165bf853a2762ccd537de"
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
