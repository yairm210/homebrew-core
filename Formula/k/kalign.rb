class Kalign < Formula
  desc "Fast multiple sequence alignment program for biological sequences"
  homepage "https://github.com/TimoLassmann/kalign"
  url "https://github.com/TimoLassmann/kalign/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "b3bebfd62e897e6513cc5014b919adeb8f6ab0543262cd9e655d495f0a8bf13c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "66164ffdf937da8c3f932fa479607c9ee834559e02623ab5092aab66ad15bcd1"
    sha256 cellar: :any,                 arm64_sequoia: "842bfdab43e403696a4f909372250a696e22892b4e894872592bc577248ffcf2"
    sha256 cellar: :any,                 arm64_sonoma:  "01754b6eb413322ee2f56a3c6734fa0033da4bf19f06cfb9643447de27af673d"
    sha256 cellar: :any,                 sonoma:        "b5f3370ca6496ed1fc93a46fa99c2a665ee2be96d1cdeda20793274981e683f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9f9ff06096fcf7d682ed8cd9e6eb07bc9d4890d0416a09c2f05c59d2040d020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a6c89fc7c53b6b03d7b0e2669c0fcbbbb72da9789981698e379ac30296e57f2"
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    args = %w[
      -DENABLE_AVX=OFF
      -DENABLE_AVX2=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    input = ">1\nA\n>2\nA"
    (testpath/"test.fa").write(input)
    output = shell_output("#{bin}/kalign test.fa")
    assert_match input, output
  end
end
