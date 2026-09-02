class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.40.2.tar.gz"
  sha256 "30e9277ad6a5783697b4e15756299c2c60c6b39feba79455c92d1d6979e8ff00"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3acc8f1f3f78cdd4568cd8916cb724a9dcadd25a53c1d45638d34f1f8a64b2e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3acc8f1f3f78cdd4568cd8916cb724a9dcadd25a53c1d45638d34f1f8a64b2e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3acc8f1f3f78cdd4568cd8916cb724a9dcadd25a53c1d45638d34f1f8a64b2e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9593957893c2ce971bbe49e482482c2dbef8223ff03a8e2aaa1311b609b14448"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c9e4628cf74856ac2e404f67101a51209ac4fe6f1dc8f05dcb3a5609d908b6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d51d7655b27237d49b03ef4f4b72e96e9557103afa5fd6183460f4f6a126564a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}") do |_, _, pid|
      sleep 5

      assert_match "API is healthy", shell_output("curl -s http://localhost:#{port}/api/health")

      assert_path_exists testpath/"pb_data", "pb_data directory should exist"
      assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

      assert_path_exists testpath/"pb_data/data.db", "pb_data/data.db should exist"
      assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

      assert_path_exists testpath/"pb_data/auxiliary.db", "pb_data/auxiliary.db should exist"
      assert_predicate testpath/"pb_data/auxiliary.db", :file?, "pb_data/auxiliary.db should be a file"
    ensure
      Process.kill "TERM", pid
    end
  end
end
