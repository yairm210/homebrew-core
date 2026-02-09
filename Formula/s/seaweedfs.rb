class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.11",
      revision: "30812b85f3b542aa6d14cc2dc1844fd1da0ae7a5"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a71f91e2b50c7689b670d009304037d5f6b95f0d6aaee3bd4c295e4402201e60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0a3adc34d6bfc8d1c5e7b5cfadffd36f7a61048588b2946014e2f3ab8fc2e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d48177d9803e736215baffb9170858d65f2f97ebcd864c88c70a40e5dc1e3bef"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7c0563549413e3391a2f09104ba32e2871c492a0e606f3079b9f7ad7a69e7a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59f2d7b0acd7f9325dad8aa68af04be7f8503311abf36605b20b94ac082897f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ade97228c1c9db44e1cecb821010cb68da99838c5b9b85bce8fef13437ff40fa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
  end

  def post_install
    (var/"seaweedfs").mkpath
  end

  service do
    run [opt_bin/"weed", "server", "-dir=#{var}/seaweedfs", "-s3"]
    keep_alive true
    error_log_path var/"log/seaweedfs.log"
    log_path var/"log/seaweedfs.log"
    working_dir var
  end

  test do
    # Start SeaweedFS master server/volume server
    master_port = free_port
    volume_port = free_port
    master_grpc_port = free_port
    volume_grpc_port = free_port

    spawn bin/"weed", "server", "-dir=#{testpath}", "-ip.bind=0.0.0.0",
          "-master.port=#{master_port}", "-volume.port=#{volume_port}",
          "-master.port.grpc=#{master_grpc_port}", "-volume.port.grpc=#{volume_grpc_port}"
    sleep 30

    # Upload a test file
    fid = JSON.parse(shell_output("curl http://localhost:#{master_port}/dir/assign"))["fid"]
    system "curl", "-F", "file=@#{test_fixtures("test.png")}", "http://localhost:#{volume_port}/#{fid}"

    # Download and validate uploaded test file against the original
    expected_sum = Digest::SHA256.hexdigest(File.read(test_fixtures("test.png")))
    actual_sum = Digest::SHA256.hexdigest(shell_output("curl http://localhost:#{volume_port}/#{fid}"))
    assert_equal expected_sum, actual_sum
  end
end
