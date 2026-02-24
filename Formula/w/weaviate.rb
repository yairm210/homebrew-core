class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://github.com/weaviate/weaviate/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "a6a46cf0fc10e79b59e627869429bc2b94ecc3cf6bcde18cfae7ae2e8cbc8560"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d76a3173ce42b3ca10ae659a977c33d79d4673872a261116572e99e5652c9b3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d76a3173ce42b3ca10ae659a977c33d79d4673872a261116572e99e5652c9b3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d76a3173ce42b3ca10ae659a977c33d79d4673872a261116572e99e5652c9b3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b78f4435357261cb5ca42c498797c9250a5512ff6a1a6b714ca827926979079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "117d62891923d7da6ba449adb006e63b9956a1141fb71e6b1cb10a5d1456cf54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f43c8a96e8e3353d7db573903a377c4cd15a62cfa143664d54fc7717afe5ca06"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/weaviate/weaviate/usecases/build.Version=#{version}
      -X github.com/weaviate/weaviate/usecases/build.BuildUser=#{tap.user}
      -X github.com/weaviate/weaviate/usecases/build.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/weaviate-server"
  end

  test do
    port = free_port
    pid = spawn bin/"weaviate", "--host", "0.0.0.0", "--port", port.to_s, "--scheme", "http"
    sleep 10
    assert_match version.to_s, shell_output("curl localhost:#{port}/v1/meta")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
