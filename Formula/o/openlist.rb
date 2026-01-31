class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  url "https://github.com/OpenListTeam/OpenList/archive/refs/tags/v4.1.10.tar.gz"
  sha256 "0e85b2e9f97c819a79a054c2de1f505b0b0d78e1c8ce6783e12da85ea519840c"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da4923c2b652abd3bf260b75cb2f1b21328004088972358e43af7e42adf7a889"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "269f3bc18c63bfb3c926e7219d89a61d9d90ae34a0309364cac328b6e7648b90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7094c270b9fc842216567fe4ecc99a7b6cf593c891dd89676d03a04b2a1e384"
    sha256 cellar: :any_skip_relocation, sonoma:        "b857d1919185b6279a9861a7f8674c5a8adc9adf4174f1164a54ebfa86d38db9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb87dc3a53d86ade81059a4700fd324280ab5bd4d9a49ba3804e6177aacb25d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2da8ab417df37702c29490e1548429d4fc2f379e76dabfaa63bab57f40a8368d"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "sqlite" => :build
  end

  resource "frontend" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/archive/refs/tags/v4.1.10.tar.gz"
    sha256 "30f92e70b8ba99344833f9da99eedc5803459a74236ee5dd3ab275160fe7dd4b"

    livecheck do
      formula :parent
    end
  end

  resource "i18n" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v4.1.10/i18n.tar.gz"
    sha256 "f25ee76ed4d1e270afb2fe0c7d24477ed52a584f0bcc4173acd8fe93524f1d40"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("i18n").stage buildpath/"i18n"

    resource("frontend").stage do
      cp_r buildpath/"i18n", Pathname.pwd/"src/lang"

      system "pnpm", "install"
      system "pnpm", "build"
      cp_r Pathname.pwd/"dist", buildpath/"public"
    end

    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.BuiltAt=#{time.iso8601}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.GoVersion=#{Formula["go"].version}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.GitAuthor=#{tap.user}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.GitCommit=#{tap.user}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.Version=#{version}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.WebVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/openlist help")
    assert_match(/Version: #{version}/, shell_output("#{bin}/openlist version"))

    test_data_dir = testpath/"data"
    pid = Process.spawn(bin/"openlist", "server", "--data", test_data_dir)

    max_attempts = 10
    attempt = 0
    http_status = "000"

    while attempt < max_attempts
      sleep 3
      http_status = shell_output("curl -s -o /dev/null -w '%<http_code>s' http://127.0.0.1:5244/ 2>&1").strip

      break if http_status != "000" && http_status != "000s"

      attempt += 1
    end

    if pid
      Process.kill("TERM", pid)
      Process.wait(pid)
    end

    refute_equal "000", http_status
  end
end
