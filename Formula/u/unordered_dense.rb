class UnorderedDense < Formula
  desc "Hashmap and hashset based on robin-hood backward shift deletion"
  homepage "https://github.com/martinus/unordered_dense"
  url "https://github.com/martinus/unordered_dense/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "3a3ab0abd80cbfd6b8f86becf9f82fc0961230abcea2d34a8b1035c59d5dd24d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b0c9ec5a9d2cb992302fdf693484535b93a6eab55f3764cd5a7f28432eca31d0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "example"
  end

  test do
    cp pkgshare/"example/main.cpp", testpath
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test"
    system "./test"
  end
end
