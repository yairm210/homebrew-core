class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.12.22.tar.gz"
  sha256 "bae75efe717d7c111fc77b0302e363438d0e555eaf3e36cbfa5b16a71073e66b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09859f8ae597d4ba7bc1ca0838ad513d5c4db90c9d6fa138355f88669b57e66b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c726e8294eb6c6a11d0ab6a11217a0113c6b9785a02cea14e3d4e7fc0607deae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb4fb109d1c1c972fb6444eca566dea3cc33092ab4d75394d3aee588c15fc8c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6804a186d55cc8ac4f236df6b22c968c59241d751b163e674e0a523209c0931a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a57fefdc3f64f1cf200a201cdfd893eb65b000c98738bb062c3e78f01e9895aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92489c33e5fd4a7bc1e1c615b17ad241e97fec533420f4b07e08fe4411265c33"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
