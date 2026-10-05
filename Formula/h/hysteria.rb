class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.13.0.tar.gz"
  sha256 "dfde427a93a0dc5ff65ddc1e239df3b1def54bf33f8b137c571daa7b27ecddd0"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3df51fb1f5276dbef654025626eed12f29e34c4608e7a6fdc796c44b9bd62a7d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3df51fb1f5276dbef654025626eed12f29e34c4608e7a6fdc796c44b9bd62a7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3df51fb1f5276dbef654025626eed12f29e34c4608e7a6fdc796c44b9bd62a7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "721c39b87e7e808330f177a977b1bf9c287a7a68029aaa13b8c82952a5e8380f"
    sha256 cellar: :any,                 x86_64_linux:      "b2e266343327ada3022251b9dfc82b058d3e284c1394c7598b6ee704eecefcbd"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    pkg = "github.com/apernet/hysteria/app/v2/cmd"
    ldflags = %W[
      -X #{pkg}.appVersion=v#{version}
      -X #{pkg}.appDate=#{time.iso8601}
      -X #{pkg}.appType=release
      -X #{pkg}.appCommit=#{tap.user}
      -X #{pkg}.appPlatform=#{OS.kernel_name.downcase}
      -X #{pkg}.appArch=#{Hardware::CPU.arch}
    ]
    system "go", "build", *std_go_args(ldflags:), "./app"

    generate_completions_from_executable(bin/"hysteria", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"hysteria", "--config", etc/"hysteria/config.yaml"]
    run_type :immediate
    keep_alive true
  end

  test do
    port = free_port
    (testpath/"config.yaml").write <<~YAML
      listen: :#{port}
      acme:
        domains:
          - your.domain.com
        email: your@email.com

      obfs:
        type: salamander
        salamander:
          password: cry_me_a_r1ver
    YAML
    output = shell_output("#{bin}/hysteria server --disable-update-check -c #{testpath}/config.yaml 2>&1", 1)
    assert_match "maintenance	started background certificate maintenance", output

    assert_match version.to_s, shell_output("#{bin}/hysteria version")
  end
end
