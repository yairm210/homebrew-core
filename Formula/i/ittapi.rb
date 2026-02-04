class Ittapi < Formula
  desc "Intel Instrumentation and Tracing Technology (ITT) and Just-In-Time (JIT) API"
  homepage "https://github.com/intel/ittapi"
  url "https://github.com/intel/ittapi/archive/refs/tags/v3.26.6.tar.gz"
  sha256 "1e115e18753a95e74ed9647e8da52ec11ec6eccd97d81ed4e6ce2f9ebf9909a6"
  license "GPL-2.0-only"
  head "https://github.com/intel/ittapi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30ff2366656b6f3be77a1ed201f86b23ff8ba01a76d8a8c34c355b9b1d572445"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ba72b9686637c79f19f2345570adcdca05be30b6e85591f865716da5ff35fdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37d5a896b087b9a11be64e7ba41dfd617554763f6d9380dff5316961f0005552"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bbe703dd088be65d9283c1243cf226e99bbe18bc752cff46ac460b9773f3a00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5db9ee4c8298c8248b975defdf2d092c50e0496e501d7467b70ceaaa034c692c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "388b527025297c79906966b73bd202b4579286f72a822747d647a84589ecc606"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ittnotify.h>

      __itt_domain* domain = __itt_domain_create("Example.Domain.Global");
      __itt_string_handle* handle_main = __itt_string_handle_create("main");

      int main()
      {
        __itt_task_begin(domain, __itt_null, __itt_null, handle_main);
        __itt_task_end(domain);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-L#{lib}", "-littnotify"
    system "./test"
  end
end
