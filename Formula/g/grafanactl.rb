class Grafanactl < Formula
  desc "CLI to interact with Grafana"
  homepage "https://grafana.github.io/grafanactl/"
  url "https://github.com/grafana/grafanactl/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "f978c3f36d6b6efb1e145a73c9f3fdeca1720def348a137fec6a289fb7df4541"
  license "Apache-2.0"
  head "https://github.com/grafana/grafanactl.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grafanactl"

    generate_completions_from_executable(bin/"grafanactl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grafanactl --version").strip
    assert_match "current-context: default", shell_output("#{bin}/grafanactl config view")
  end
end
