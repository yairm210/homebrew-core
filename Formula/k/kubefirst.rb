class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.konstruct.io/docs/"
  url "https://github.com/konstructio/kubefirst/archive/refs/tags/v2.10.5.tar.gz"
  sha256 "91112d5f07bdcfdb4f85a9da79968f6dc9c2d352d03a50b275f3fdd06b9f8364"
  license "MIT"
  head "https://github.com/konstructio/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7080d87e2b33d65e20fbfe728bef6a7c6c58535522ac17b03fcb8664f43d853"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a71cf112914cf5fc1e6c1857616441e1865eb61209ef40390141ba6a44368589"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d597ead371c5c21f5da3201e3bd706629c16087f42a42e0b79aad1c970b2f538"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6e4206e30a775a924754bed1e8d5862911b0b62f49ba387a9b4f625337d4281"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8162facbec403b43ee7a1bd908e7ca7d2fd99fa59a30c3c448f99c9cc5ea67d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "426580173f34273aa9b3dbb0bc1ec9028e7fd90d57fcfa6df8cd585b1be053f0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/konstructio/kubefirst-api/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubefirst", shell_parameter_format: :cobra)
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_path_exists testpath/".k1/logs"

    output = shell_output("#{bin}/kubefirst version 2>&1")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end
