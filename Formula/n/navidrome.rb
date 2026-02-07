class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.60.2.tar.gz"
  sha256 "1189697b8de66d443fea512de20c2a7064a985e171c6f0ff0cc8f0d7fb496e68"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e0598e0a7a5ffbec2cad57fab8d15e1f16781f5502665f3984ba8be3a1c2af20"
    sha256 cellar: :any,                 arm64_sequoia: "85bf9a7ef24f284bb98115fe39d9a438150c19781ab16795ea496f7476a32902"
    sha256 cellar: :any,                 arm64_sonoma:  "b25560e78ea95ce7da052e30e0a46e4ba011be65b8ace62bee5ea72265cad5a9"
    sha256 cellar: :any,                 sonoma:        "bc2bf003e5c8536c7017fcd23b711a07d723cd90593291906fc319d8867103ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27618ad68e326b01ea67bfe29b69c8b01c03cb3694d7c7e6c1583a6d1d001970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c6d37076bc7a1d5a9ea56b6a462f8607a13c10eb5297652adcc64ce3ea97eb8"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -s -w
      -X github.com/navidrome/navidrome/consts.gitTag=v#{version}
      -X github.com/navidrome/navidrome/consts.gitSha=source_archive
    ]

    system "make", "setup"
    system "make", "buildjs"
    system "go", "build", *std_go_args(ldflags:, tags: "netgo"), "-buildvcs=false"

    generate_completions_from_executable(bin/"navidrome", shell_parameter_format: :cobra)
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}/navidrome --version").chomp
    port = free_port
    pid = spawn bin/"navidrome", "--port", port.to_s
    sleep 20
    sleep 100 if OS.mac? && Hardware::CPU.intel?
    assert_equal ".", shell_output("curl http://localhost:#{port}/ping")
  ensure
    Process.kill "KILL", pid
    Process.wait pid
  end
end
