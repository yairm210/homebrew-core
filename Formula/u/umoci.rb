class Umoci < Formula
  desc "Reference OCI implementation for creating, modifying and inspecting images"
  homepage "https://github.com/opencontainers/umoci"
  url "https://github.com/opencontainers/umoci/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "400a26c5f7ac06e40af907255e0e23407237d950e78e8d7c9043a1ad46da9ae5"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "gpgme"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/umoci"

    man1.mkpath
    buildpath.glob("doc/man/*.md").each do |f|
      system "go-md2man", "-in", f, "-out", man1/f.basename(".md")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/umoci --version")

    error_message = "invalid image detected"
    assert_match error_message, shell_output("#{bin}/umoci stat --image fake 2>&1", 1)
    assert_match error_message, shell_output("#{bin}/umoci list --layout fake 2>&1", 1)
  end
end
