class Odiff < Formula
  desc "Very fast SIMD-first image comparison library (with nodejs API)"
  homepage "https://github.com/dmtrKovalenko/odiff"
  url "https://github.com/dmtrKovalenko/odiff/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "da32d852e2145ded6b485398ad31101e9435ed9255b3cbe15c7735374f2b9e6f"
  license "MIT"
  head "https://github.com/dmtrKovalenko/odiff.git", branch: "main"

  depends_on "zig" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odiff --version 2>&1")

    assert_match "Images are identical",
      shell_output("#{bin}/odiff #{test_fixtures("test.png")} #{test_fixtures("test.png")} 2>&1")
  end
end
