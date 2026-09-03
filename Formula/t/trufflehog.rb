class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.97.3.tar.gz"
  sha256 "f5877711ed48b31cab14272b5a0f4fdc4b8d181b7c0629e3c016bce54e636435"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27defcd406483af9be11e09e21febbd754ff19f0945cad8961a11d73e8f39cb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7869f95fa74b6b9557e449a9f06578e5e62d4aad3d4993cf4838060713ee0efd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d5a274054908ed1f359a64de3d74d8b90f01c11d24e89d9e13baf6c1ed53aeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb3b9efe53c469cfdb375c7b14ba359a8f640d7de3310adf1031bbb35440d40a"
    sha256 cellar: :any,                 x86_64_linux:  "43fe8758021fad08fe7d3f94835b2f03c549aa81f13da7caafa1f3d63b9c4c4f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "docs/man/trufflehog.1"
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
