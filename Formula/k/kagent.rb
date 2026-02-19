class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.17.tar.gz"
  sha256 "2559cc4bffd10e87729187ab550d0e6781bf0dec280aa39c8d3d9065a621bb6f"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b144a637c70d796915966a62809115c930e4a36bca7c3ec9d7870bca17b02f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b144a637c70d796915966a62809115c930e4a36bca7c3ec9d7870bca17b02f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b144a637c70d796915966a62809115c930e4a36bca7c3ec9d7870bca17b02f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "89ea39ee265b050370b0c921db7d5cc1f539db41ca5be845f22c116f83052f23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d70e0c18e2b7a50005d828f591e6a1609bb21ff3be7b37d59cd08eec2f77b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33914041fb786ba45481b41393eae299dc339cc05e957f92ef1f400644d325e0"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    cd "go" do
      ldflags = %W[
        -X github.com/kagent-dev/kagent/go/internal/version.Version=#{version}
        -X github.com/kagent-dev/kagent/go/internal/version.GitCommit=#{tap.user}
        -X github.com/kagent-dev/kagent/go/internal/version.BuildDate=#{Time.now.strftime("%Y-%m-%d")}
      ]
      system "go", "build", *std_go_args(ldflags:), "./cli/cmd/kagent"
    end

    generate_completions_from_executable(bin/"kagent", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kagent version")

    (testpath/"config.yaml").write <<~YAML
      kagent_url: http://localhost:#{free_port}
      namespace: kagent
      output_format: table
      timeout: 5m0s
    YAML
    assert_match "Successfully created adk project ", shell_output("#{bin}/kagent init adk python dice")
    assert_path_exists "dice"

    cd "dice" do
      pid = spawn bin/"kagent", "run", "--config", testpath/"config.yaml", err: "test.log"
      sleep 3
      assert_match "failed to start docker-compose", File.read("test.log")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end

    assert_match "Please run 'install' command first", shell_output("#{bin}/kagent 2>&1")
    assert_match "helm not found in PATH.", shell_output("#{bin}/kagent install 2>&1")
  end
end
