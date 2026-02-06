class MlxC < Formula
  desc "C API for MLX"
  homepage "https://ml-explore.github.io/mlx-c"
  url "https://github.com/ml-explore/mlx-c/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "dcfc404d7004e6da70170c669dbc920913cb25a59c9f7dac781caf92e524cc86"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6784390f093bf0bb9f2d03dcc5d35a50e90e745612e12445464989c832c03283"
    sha256 cellar: :any, arm64_sequoia: "0d6f8ed88a35e0c321bf823d769811942333e49e13bbea04f03980a027d444dd"
    sha256 cellar: :any, arm64_sonoma:  "25f67cc6ab34aca8457eb15a390f54bc3e905a615411473b5e951c58db2794c1"
  end

  depends_on "cmake" => :build
  depends_on arch: :arm64
  depends_on :macos
  depends_on "mlx"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DMLX_C_BUILD_EXAMPLES=OFF
      -DMLX_C_USE_SYSTEM_MLX=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/example.c"
  end

  test do
    system ENV.cc, pkgshare/"example.c", "-o", "test", "-L#{lib}", "-lmlxc"
    assert_match "array([0, 0.5, 1, 1.5, 2, 2.5], dtype=float32)", shell_output("./test")
  end
end
